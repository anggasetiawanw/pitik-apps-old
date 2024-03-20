import 'package:common_page/smart_monitor/detail_smartmonitor_activity.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_controller.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/deeplink.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_active_standard.dart';
import 'package:model/coop_model.dart';
import 'package:model/coop_performance.dart';
import 'package:model/monitoring.dart';
import 'package:model/population.dart';
import 'package:model/profile.dart';
import 'package:model/response/monitoring_performance_response.dart';

import '../../../route.dart';
import '../../../utils/deeplink_mapping_arguments.dart';
import '../dashboard_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/01/2024

class LayerDashboardController extends GetxController {
  BuildContext context;
  LayerDashboardController({required this.context});

  int startTime = DateTime.now().millisecondsSinceEpoch;

  late Coop coop;
  late Map<String, dynamic> payloadForPushNotification;
  late Profile? profile;
  late DetailSmartMonitor detailSmartMonitor;

  var isLoading = false.obs;
  var homeTab = true.obs;
  var historyTab = false.obs;
  var monitorTab = false.obs;
  var profileTab = false.obs;

  var showDocInAlert = false.obs;
  var showDailyReportAlert = false.obs;

  RxInt countUnreadNotifications = 0.obs;

  Rx<Monitoring> monitoring = Monitoring(
          day: -1,
          performance: CoopPerformance(
            bw: CoopActiveStandard(standard: -1, actual: -1),
            ip: CoopActiveStandard(standard: -1, actual: -1),
            fcr: CoopActiveStandard(standard: -1, actual: -1),
            mortality: CoopActiveStandard(standard: -1, actual: -1),
          ),
          population: Population(total: -1, mortaled: -1, mortality: -1, harvested: -1, remaining: -1, feedConsumed: -1, culled: -1))
      .obs;

  @override
  void onInit() {
    super.onInit();
    GlobalVar.track('Open_home_layer_page');
    coop = Get.arguments[0];

    refreshData();
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments.length > 1) {
        payloadForPushNotification = Get.arguments[1];
        if (payloadForPushNotification['target'] == '{navigation}[PROFILE_NAVIGATION]') {
          toProfile();
        } else if (payloadForPushNotification['target'] == '{navigation}[MONITOR_NAVIGATION]') {
          toMonitor();
        } else if (payloadForPushNotification['target'] == '{navigation}[HISTORY_NAVIGATION]') {
          toHistory();
        } else {
          Deeplink.toTarget(target: payloadForPushNotification['target'], arguments: DeeplinkMappingArguments.createArguments(target: payloadForPushNotification['target'], additionalParameters: payloadForPushNotification['additionalParameters']));
        }
      }

      // track render page time
      GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'Purpose': 'Page_Layer'});
    });
  }

  Future<void> refreshData() async {
    getMonitoringPerformance(coop);
    profile = await ProfileImpl().get();

    detailSmartMonitor = DetailSmartMonitor(
        controller: Get.put(DetailSmartMonitorController(tag: 'smartMonitorForDashboard', context: Get.context!, coop: coop), tag: 'smartMonitorForDashboard'),
        widgetLoading: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(children: [
              Image.asset('images/card_lazy.gif', width: MediaQuery.of(Get.context!).size.width - 32),
              const SizedBox(height: 24),
              Image.asset('images/card_lazy.gif', width: MediaQuery.of(Get.context!).size.width - 32),
              const SizedBox(height: 24),
              Image.asset('images/card_lazy.gif', width: MediaQuery.of(Get.context!).size.width - 32),
            ])));

    DashboardCommon.getUnreadNotificationCount(countUnreadNotifications: countUnreadNotifications);
  }

  void getMonitoringPerformance(Coop coop) {
    isLoading.value = true;
    final int startTime = DateTime.now().millisecondsSinceEpoch;

    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: 'farmMonitoringApi',
                  service: ListApi.getPerformanceMonitoring,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop.farmingCycleId}/performance'],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        monitoring.value = (body as MonitoringPerformanceResponse).data!;
                        isLoading.value = false;
                        GlobalVar.trackWithMap('Render_time', {'farmCycle': '${coop.farmingCycleId}', 'value': Convert.getRenderTime(startTime: startTime), 'API': 'getPerformanceMonitoring', 'Result': 'Success'});
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        isLoading.value = false;
                        GlobalVar.trackWithMap('Render_time', {'farmCycle': '${coop.farmingCycleId}', 'value': Convert.getRenderTime(startTime: startTime), 'API': 'getPerformanceMonitoring', 'Result': 'Fail'});
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                        isLoading.value = false;
                        GlobalVar.trackWithMap('Render_time', {'farmCycle': '${coop.farmingCycleId}', 'value': Convert.getRenderTime(startTime: startTime), 'API': 'getPerformanceMonitoring', 'Result': 'Error'});
                      },
                      onTokenInvalid: () => GlobalVar.invalidResponse()))
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }

  void showMenuBottomSheet() {
    GlobalVar.track('Click_floating_menu_layer');
    showModalBottomSheet(
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        )),
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) => Container(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(children: [
                      Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Peternakan', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                          // ROW 1 PETERNAKAN
                          padding: const EdgeInsets.all(16),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            DashboardCommon.createMenu(
                                title: 'Pullet in',
                                imagePath: 'images/calendar_check_icon.svg',
                                status: showDocInAlert.value,
                                function: () {
                                  GlobalVar.track('Click_feature_DOCin');
                                  Get.toNamed(RoutePage.pulletInForm, arguments: [coop]);
                                }),
                            DashboardCommon.createMenu(
                                title: 'Laporan\nHarian',
                                imagePath: 'images/report_icon.svg',
                                status: showDailyReportAlert.value,
                                function: () {
                                  GlobalVar.track('Click_feature_Laporan_harian');
                                  Get.toNamed(RoutePage.dailyReport, arguments: [coop, true]);
                                }),
                            const SizedBox(width: 60)
                          ]))
                    ])))));
  }

  void toHome(BuildContext context) {
    homeTab.value = true;
    historyTab.value = false;
    monitorTab.value = false;
    profileTab.value = false;

    getMonitoringPerformance(coop);
  }

  void toHistory() {
    homeTab.value = false;
    historyTab.value = true;
    monitorTab.value = false;
    profileTab.value = false;

    // historyActivity.controller.refreshData();
  }

  void toMonitor() {
    homeTab.value = false;
    historyTab.value = false;
    monitorTab.value = true;
    profileTab.value = false;

    // detailSmartMonitor.controller.getInitialLatestDataSmartMonitor();
  }

  void toProfile() {
    homeTab.value = false;
    historyTab.value = false;
    monitorTab.value = false;
    profileTab.value = true;
  }

  Widget generateHomeWidget() {
    final DateTime? startDate = coop.startDate == null ? null : Convert.getDatetime(coop.startDate!);
    // final num populationOutstanding = (monitoring.value.population!.total == null ? 0 : monitoring.value.population!.total!) -
    //     (monitoring.value.population!.harvested == null ? 0 : monitoring.value.population!.harvested!) -
    //     (monitoring.value.population!.mortality == null ? 0 : monitoring.value.population!.mortality!);

    return RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => getMonitoringPerformance(coop)),
        child: ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
          Stack(
            children: [
              SvgPicture.asset('images/banner_layer_dashboard.svg', width: MediaQuery.of(Get.context!).size.width - 32),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32),
                  child: Text('${coop.week ?? '-'} Minggu', style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold, color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text('Pullet In ${startDate == null ? '-' : '${Convert.getYear(startDate)}-${Convert.getMonthNumber(startDate)}-${Convert.getDay(startDate)}'}',
                      style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.white)),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text('Hari ${startDate == null ? '-' : Convert.getRangeDateToNow(startDate)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.white)),
                ),
              ])
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [SvgPicture.asset('images/hdp_icon.svg', width: 24, height: 24), const SizedBox(width: 8), Text('HDP/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))],
                ),
                Row(
                  children: [
                    Text('${monitoring.value.performance!.hdp == null ? '-' : monitoring.value.performance!.hdp!.actual!.toStringAsFixed(2)}%',
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16, fontWeight: GlobalVar.bold, color: monitoring.value.performance!.hdp != null && monitoring.value.performance!.hdp!.actual! > monitoring.value.performance!.hdp!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.hdp == null ? '-' : monitoring.value.performance?.hdp?.standard}%', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('images/egg_weight_icon.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('Egg Weight/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                ),
                Row(
                  children: [
                    Text('${monitoring.value.performance!.eggWeight == null ? '-' : monitoring.value.performance!.eggWeight!.actual!.toStringAsFixed(2)}gr',
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: GlobalVar.bold,
                            color: monitoring.value.performance!.eggWeight != null && monitoring.value.performance!.eggWeight!.actual! > monitoring.value.performance!.eggWeight!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.eggWeight == null ? '-' : monitoring.value.performance?.eggWeight?.standard}gr',
                        style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('images/egg_mass_icon.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('Egg Mass/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                ),
                Row(
                  children: [
                    Text('${monitoring.value.performance!.eggMass == null ? '-' : monitoring.value.performance!.eggMass!.actual!.toStringAsFixed(2)}gr',
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: GlobalVar.bold,
                            color: monitoring.value.performance!.eggMass != null && monitoring.value.performance!.eggMass!.actual! > monitoring.value.performance!.eggMass!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.eggMass == null ? '-' : monitoring.value.performance?.eggMass?.standard}gr', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('images/feed_intake_icon.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('Feed Intake/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                ),
                Row(
                  children: [
                    Text(monitoring.value.performance!.feedIntake == null ? '-' : monitoring.value.performance!.feedIntake!.actual!.toStringAsFixed(2),
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: GlobalVar.bold,
                            color: monitoring.value.performance!.feedIntake != null && monitoring.value.performance!.feedIntake!.actual! > monitoring.value.performance!.feedIntake!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.feedIntake == null ? '-' : monitoring.value.performance?.feedIntake?.standard}',
                        style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('images/mortality_icon.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('Mortalitas/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                ),
                Row(
                  children: [
                    Text('${monitoring.value.performance!.mortality == null ? '-' : monitoring.value.performance!.mortality!.actual!.toStringAsFixed(2)}%',
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: GlobalVar.bold,
                            color: monitoring.value.performance!.mortality != null && monitoring.value.performance!.mortality!.actual! > monitoring.value.performance!.mortality!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.mortality == null ? '-' : monitoring.value.performance?.mortality?.standard}%', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('images/bw_icon.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text('BW rata-rata/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                ),
                Row(
                  children: [
                    Text(monitoring.value.performance!.bw == null ? '-' : monitoring.value.performance!.bw!.actual!.toStringAsFixed(2),
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16, fontWeight: GlobalVar.bold, color: monitoring.value.performance!.bw != null && monitoring.value.performance!.bw!.actual! > monitoring.value.performance!.bw!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.bw == null ? '-' : monitoring.value.performance?.bw?.standard}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [SvgPicture.asset('images/fcr_icon.svg', width: 24, height: 24), const SizedBox(width: 8), Text('FCR/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))],
                ),
                Row(
                  children: [
                    Text(monitoring.value.performance!.fcr == null ? '-' : monitoring.value.performance!.fcr!.actual!.toStringAsFixed(2),
                        style: GlobalVar.whiteTextStyle.copyWith(
                            fontSize: 16, fontWeight: GlobalVar.bold, color: monitoring.value.performance!.fcr != null && monitoring.value.performance!.fcr!.actual! > monitoring.value.performance!.fcr!.standard! ? GlobalVar.green : GlobalVar.red)),
                    Text(' / ${monitoring.value.performance!.fcr == null ? '-' : monitoring.value.performance?.fcr?.standard}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.outlineColor)), color: Colors.white),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Detail Populasi', style: GlobalVar.boldTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Populasi Awal', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(monitoring.value.population != null && monitoring.value.population!.total != null ? Convert.toCurrencyWithoutDecimal((monitoring.value.population!.initialPopulation ?? 0).toString(), '', '.') : '-',
                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                        const SizedBox(width: 4),
                        Text('Ekor', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total kematian', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Convert.toCurrencyWithoutDecimal(monitoring.value.population != null && monitoring.value.population!.mortality != null ? monitoring.value.population!.mortality!.toString() : '-', '', '.'),
                              style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                          const SizedBox(width: 4),
                          Text('Ekor', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Afkir', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(monitoring.value.population != null && monitoring.value.population!.culled != null ? Convert.toCurrencyWithoutDecimal(monitoring.value.population!.culled!.toString(), '', '.') : '-',
                              style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                          const SizedBox(width: 4),
                          Text('Ekor', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Divider(
                    height: 1,
                    color: GlobalVar.black,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sisa Populasi', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Convert.toCurrencyWithoutDecimal(monitoring.value.population!.total!.toString(), '', '.'), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                          const SizedBox(width: 4),
                          Text('Ekor', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                        ],
                      )
                    ],
                  ),
                )
              ])),
          const SizedBox(height: 70)
        ]));
  }

  Widget generateHistoryWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/empty_icon.svg'),
            const SizedBox(height: 8),
            Text('Data Kosong,\nFitur dalam pengembangan', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center),
          ],
        ),
      );

  Widget generateMonitorWidgetStock() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('images/empty_icon.svg'),
            const SizedBox(height: 8),
            Text('Data Kosong,\nFitur dalam pengembangan', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center),
          ],
        ),
      );

  /// The function generates a widget for a smart monitor.
  Widget generateMonitorWidget() => detailSmartMonitor;
}

class LayerDashboardBinding extends Bindings {
  BuildContext context;
  LayerDashboardBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<LayerDashboardController>(() => LayerDashboardController(context: context));
}
