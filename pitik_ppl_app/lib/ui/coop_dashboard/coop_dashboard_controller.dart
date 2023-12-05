import 'dart:async';

import 'package:common_page/history/history_activity.dart';
import 'package:common_page/history/history_controller.dart';
import 'package:common_page/profile/profile_activity.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_activity.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_controller.dart';
import 'package:common_page/smart_scale/bundle/list_smart_scale_bundle.dart';
import 'package:common_page/smart_scale/bundle/smart_scale_weighing_bundle.dart';
import 'package:common_page/smart_scale/detail_smart_scale/detail_smart_scale_activity.dart';
import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_controller.dart';
import 'package:common_page/smart_scale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:components/global_var.dart';
import 'package:components/item_smart_scale_day/item_smart_scale_day.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:dao_impl/smart_scale_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/deeplink.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:model/coop_active_standard.dart';
import 'package:model/coop_model.dart';
import 'package:model/coop_performance.dart';
import 'package:model/error/error.dart';
import 'package:model/monitoring.dart';
import 'package:model/population.dart';
import 'package:model/profile.dart';
import 'package:model/response/list_smart_scale_response.dart';
import 'package:model/response/monitoring_performance_response.dart';
import 'package:model/smart_scale/smart_scale_model.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pitik_ppl_app/utils/deeplink_mapping_arguments.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class CoopDashboardController extends GetxController {
    BuildContext context;
    CoopDashboardController({required this.context});

    late Coop coop;
    late Map<String, dynamic> payloadForPushNotification;
    late Profile? profile;
    late DetailSmartMonitor detailSmartMonitor;
    late HistoryActivity historyActivity;

    var isLoading = false.obs;
    var homeTab = true.obs;
    var historyTab = false.obs;
    var monitorTab = false.obs;
    var profileTab = false.obs;

    var showDocInAlert = false.obs;
    var showDailyReportAlert = false.obs;
    var showHarvestAlert = false.obs;
    var showDailyTaskAlert = false.obs;
    var showFarmClosingAlert = false.obs;
    var showOrderAlert = false.obs;
    var showTransferAlert = false.obs;
    var showSmartScaleAlert = false.obs;
    var showSmartControllerAlert = false.obs;
    var showSmartCameraAlert = false.obs;

    RxInt countUnreadNotifications = 0.obs;

    Rx<Monitoring> monitoring = (Monitoring(
        day: -1,
        performance: CoopPerformance(
            bw: CoopActiveStandard(standard: -1, actual: -1),
            ip: CoopActiveStandard(standard: -1, actual: -1),
            fcr: CoopActiveStandard(standard: -1, actual: -1),
            mortality: CoopActiveStandard(standard: -1, actual: -1),
        ),
        population: Population(
            total: -1,
            mortaled: -1,
            mortality: -1,
            harvested: -1,
            remaining: -1,
            feedConsumed: -1,
            culled: -1
        )
    )).obs;

    @override
    void onInit() async{
        super.onInit();
        coop = Get.arguments[0];

        refreshData();
    }

    void refreshData()async{
        getMonitoringPerformance(coop);
        profile = await ProfileImpl().get();

        Get.put(HistoryController(context: Get.context!, coop: coop));

        historyActivity = HistoryActivity(coop: coop);
        detailSmartMonitor = DetailSmartMonitor(
            controller: Get.put(DetailSmartMonitorController(
                tag: "smartMonitorForDashboard",
                context: Get.context!,
                coop: coop
            ),  tag: "smartMonitorForDashboard"),
            widgetLoading: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                    children: [
                        Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                        const SizedBox(height: 24),
                        Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                        const SizedBox(height: 24),
                        Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                    ],
                ),
            ),
        );
        getUnreadNotifCount();
    }

    void getUnreadNotifCount(){

        AuthImpl().get().then((auth) => {
            if (auth != null){
                Service.push(
                    apiKey: ApiMapping.api,
                    service: ListApi.countUnreadNotifications,
                    context: context,
                    body: [
                        'Bearer ${auth.token}',
                        auth.id,
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            countUnreadNotifications.value = (body.data);
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red,);
                                print(stacktrace);
                        },
                            onTokenInvalid: () => GlobalVar.invalidResponse()))
                    }
            else
                {GlobalVar.invalidResponse()}
        });
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
                    Deeplink.toTarget(target: payloadForPushNotification['target'], arguments: DeeplinkMappingArguments.createArguments(
                        target: payloadForPushNotification['target'],
                        additionalParameters: payloadForPushNotification['additionalParameters']
                    ));
                }
            }
        });
    }

    void getMonitoringPerformance(Coop coop) {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'farmMonitoringApi',
                    service: ListApi.getPerformanceMonitoring,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop.farmingCycleId}/performance'],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            monitoring.value = (body as MonitoringPerformanceResponse).data!;
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
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

        historyActivity.controller.refreshData();
    }

    void toMonitor() {
        homeTab.value = false;
        historyTab.value = false;
        monitorTab.value = true;
        profileTab.value = false;

        detailSmartMonitor.controller.getInitialLatestDataSmartMonitor();
    }

    void toProfile() {
        homeTab.value = false;
        historyTab.value = false;
        monitorTab.value = false;
        profileTab.value = true;
    }

    void showMenuBottomSheet() {
        showModalBottomSheet(
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                )
            ),
            isScrollControlled: true,
            context: Get.context!,
            builder: (context) => Container(
                color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Wrap(
                            children: [
                                Center(
                                    child: Container(
                                        width: 60,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: GlobalVar.outlineColor
                                        )
                                    )
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text("Peternakan", style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                ),
                                const SizedBox(height: 16),
                                Padding(    // ROW 1 PETERNAKAN
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _createMenu("DOC in", 'images/calendar_check_icon.svg', showDocInAlert.value, () => Get.toNamed(RoutePage.docInPage, arguments: [coop])),
                                            _createMenu("Laporan\nHarian", 'images/report_icon.svg', showDailyReportAlert.value, () => Get.toNamed(RoutePage.dailyReport, arguments: coop)),
                                            _createMenu("Panen", 'images/harvest_icon.svg', showHarvestAlert.value, () => Get.toNamed(RoutePage.listHarvest, arguments: coop)),
                                        ],
                                    ),
                                ),
                                Padding(    // ROW 2 PETERNAKAN
                                    padding: const EdgeInsets.only(left: 16, right: 16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            // _createMenu("Tugas\nHarian", 'images/report_check_icon.svg', showDailyTaskAlert.value, () {  // DAILY TASK
                                            //     // TO DAILY TASK
                                            // }),
                                            _createMenu("Farm\nClosing", 'images/empty_document_icon.svg', showFarmClosingAlert.value, () {  // FARM CLOSING
                                                // TO FARM CLOSING
                                            }),
                                            const SizedBox(width: 60)
                                        ],
                                    ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 32),
                                    child: Text("Procurement", style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                ),
                                const SizedBox(height: 16),
                                Padding(    // ROW 1 PROCUREMENT
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _createMenu("Order", 'images/document_icon.svg', showOrderAlert.value, () => Get.toNamed(RoutePage.listOrderPage, arguments: [coop, false])),
                                            _createMenu("Transfer", 'images/transfer_icon.svg', showTransferAlert.value, () => Get.toNamed(RoutePage.listTransferPage, arguments: coop)),
                                            const SizedBox(width: 60)
                                        ],
                                    ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 16),
                                    child: Text("IoT", style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                ),
                                const SizedBox(height: 16),
                                Padding(    // ROW 1 IoT
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _createMenu("Smart\nScale", 'images/smart_scale_icon.svg', showSmartScaleAlert.value, () => Get.toNamed(RoutePage.listSmartScale, arguments: _getListSmartScaleBundle())),
                                            _createMenu("Smart\nController", 'images/smart_controller_icon.svg', showSmartControllerAlert.value, () => Get.toNamed(RoutePage.smartControllerList, arguments: [coop])),
                                            _createMenu("Smart\nCamera", 'images/record_icon.svg', showSmartCameraAlert.value, () => Get.toNamed(RoutePage.listSmartCameraDay, arguments: coop))
                                        ]
                                    )
                                )
                            ]
                        )
                    )
                )
            )
        );
    }

    SmartScaleWeighingBundle _getSmartScaleWeighingBundle() => SmartScaleWeighingBundle(
        routeSave: () => ListApi.saveSmartScale,
        routeEdit: () => ListApi.saveSmartScale,
        routeDetail: () => ListApi.getSmartScaleDetail,
        getBodyRequest: (controller, auth, isEdit) async {
            if (isEdit) {
                await SmartScaleImpl().getById(controller.smartScaleData.value!.id!).then((record) async {
                    if (record != null) {
                        record.details = controller.smartScaleRecords.entries.map( (entry) => entry.value).toList();
                        record.date = Convert.getStringIso(DateTime.now());
                        record.farmingCycleId = coop.farmingCycleId;

                        controller.smartScaleData.value = record;
                    } else {
                        // setting body
                        controller.smartScaleData.value!.id = controller.smartScaleData.value!.id;
                        controller.smartScaleData.value!.farmingCycleId = coop.farmingCycleId;
                        controller.smartScaleData.value!.details = controller.smartScaleRecords.entries.map( (entry) => entry.value).toList();
                        controller.smartScaleData.value!.date = Convert.getStringIso(DateTime.now());
                        controller.smartScaleData.value!.expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
                    }
                });
            } else {
                // setting body
                controller.smartScaleData.value!.farmingCycleId = coop.farmingCycleId;
                controller.smartScaleData.value!.details = controller.smartScaleRecords.entries.map( (entry) => entry.value).toList();
                controller.smartScaleData.value!.date = Convert.getStringIso(DateTime.now());
                controller.smartScaleData.value!.expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
            }

            ListSmartScaleResponse bodyRequest = ListSmartScaleResponse(data: [controller.smartScaleData.value!]);
            return ['Bearer ${auth.token}', auth.id, 'v2/smart-scale/weighing/${coop.farmingCycleId}', Mapper.asJsonString(bodyRequest)];
        },
        getBodyDetail: (controller, auth) => ['Bearer ${auth.token}', auth.id, 'v2/smart-scale/weighing/${coop.farmingCycleId}/dates/${controller.id}']
    );

    ListSmartScaleBundle _getListSmartScaleBundle() => ListSmartScaleBundle(
        getCoop: () => coop,
        isShowWeighingButton: () => false,
        getWeighingBundle: () => _getSmartScaleWeighingBundle(),
        onGetSmartScaleListData: (controller) => AuthImpl().get().then((auth) {
            if (auth != null) {
                Service.push(
                    apiKey: "smartScaleApi",
                    service: ListApi.getListHistoryScale,
                    context: context,
                    body: [auth.token, auth.id, 'v2/smart-scale/weighing/${coop.farmingCycleId}', controller.pageSmartScale.value, controller.limit.value, controller.dateFilter.value == '' ? null : controller.dateFilter.value],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            controller.smartScaleList.value = body.data;
                            _ascendingHistory(controller);

                            controller.isLoadMore.value = false;
                            controller.isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            controller.isLoadMore.value = false;
                            controller.isLoading.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            controller.isLoadMore.value = false;
                            controller.isLoading.value = false;
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            } else {
                GlobalVar.invalidResponse();
            }
        }),
        onCreateCard: (controller, index) => ItemSmartScaleDay(
            smartScale: controller.smartScaleList[index]!,
            isRedChild: index == 0,
            onTap: () async {
                if (controller.smartScaleList[index]!.totalCount == null) {
                    GlobalVar.track("Click_card_smart_scale_weighing");
                    await Get.to(SmartScaleWeighingActivity(), arguments: [controller.bundle.getCoop(), controller.bundle.getWeighingBundle()]);

                    controller.isLoading.value = true;
                    controller.smartScaleList.clear();
                    controller.pageSmartScale.value = 1;
                    Timer(const Duration(milliseconds: 500), () => controller.getSmartScaleListData());
                } else {
                    GlobalVar.track("Click_card_smart_scale_detail");
                    if (controller.smartScaleList[index]!.id != null) {
                        await Get.to(DetailSmartScaleActivity(), arguments: [controller.bundle.getCoop(), controller.smartScaleList[index]!.date, controller.bundle.getWeighingBundle()]);

                        controller.isLoading.value = true;
                        controller.smartScaleList.clear();
                        controller.pageSmartScale.value = 1;
                        Timer(const Duration(milliseconds: 500), () => controller.getSmartScaleListData());
                    } else {
                        controller.showWeighingNotFound();
                    }
                }
            }
        )
    );

    void _ascendingHistory(ListSmartScaleController controller) {
        List<SmartScale?> scalesAscending = [];

        for (int i = coop.day ?? 0; i >= 1; i--) {
            bool isInsert = false;
            bool isLast = false;

            if (controller.smartScaleList.isNotEmpty) {
                for (var model in controller.smartScaleList) {
                    if (model!.day == i) {
                        scalesAscending.add(model);
                        isInsert = true;
                    } else if (i == coop.day) {
                        isLast = true;
                    }
                }
            } else {
                if (i == coop.day) {
                    isLast = true;
                }
            }

            DateTime dateTime = Convert.getDatetime(coop.startDate!).add(Duration(days: i));
            if (!isInsert && !isLast) {
                SmartScale historyScaleTemp = SmartScale(
                    date: '${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}',
                    executionDate: '${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}',
                    day: i,
                    averageWeight: 0.00,
                    totalCount: 0,
                );

                scalesAscending.add(historyScaleTemp);
            } else if (isLast && !isInsert) {
                SmartScale historyScaleTemp = SmartScale(
                    date: '${Convert.getYear(DateTime.now())}-${Convert.getMonthNumber(DateTime.now())}-${Convert.getDay(DateTime.now())}',
                    executionDate: '${Convert.getYear(DateTime.now())}-${Convert.getMonthNumber(DateTime.now())}-${Convert.getDay(DateTime.now())}',
                    day: coop.day,
                    averageWeight: null,
                    totalCount: null,
                );

                scalesAscending.add(historyScaleTemp);
            }
        }

        controller.smartScaleList.value = scalesAscending;
    }

    Widget _createMenu(String title, String imagePath, bool status, Function() function) {
        return GestureDetector(
            onTap: () {
                Navigator.pop(Get.context!);
                function();
            },
            child: Column(
                children: [
                    SizedBox(
                        width: 60,
                        height: 50,
                        child: Stack(
                            children: [
                                Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: GlobalVar.primaryLight2
                                        ),
                                        child: SvgPicture.asset(imagePath),
                                    )
                                ),
                                !status ? const SizedBox() :
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Image.asset('images/alert_red_icon.png')
                                )
                            ]
                        )
                    ),
                    const SizedBox(height: 2),
                    Text(title, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.center)
                ],
            ),
        );
    }
    
    /// The function `generateHomeWidget()` returns a widget that displays various
    /// information related to a coop's monitoring performance and population
    /// details.
    ///
    /// Returns:
    ///   a widget of type `RefreshIndicator` wrapped in a `ListView`.
    Widget generateHomeWidget() {
        DateTime? startDate = coop.startDate == null ? null : Convert.getDatetime(coop.startDate!);
        DateTime? stockOutDate = monitoring.value.feed == null || monitoring.value.feed!.stockoutDate == null ? null : Convert.getDatetime(monitoring.value.feed!.stockoutDate!);
        num populationOutstanding = (monitoring.value.population!.total == null ? 0 : monitoring.value.population!.total!) -
                                    (monitoring.value.population!.harvested == null ? 0 : monitoring.value.population!.harvested!) -
                                    (monitoring.value.population!.mortality == null ? 0 : monitoring.value.population!.mortality!);
        String feedOutstanding = (monitoring.value.feed == null || monitoring.value.feed!.remaining == null ? '0' : monitoring.value.feed!.remaining!.toStringAsFixed(1));

        return RefreshIndicator(
            onRefresh: () => Future.delayed(
                const Duration(milliseconds: 200), () => getMonitoringPerformance(coop)
            ),
            child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        height: 155,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: GlobalVar.primaryOrange
                        ),
                        child: Column(
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Hari ${coop.day}', style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.medium, color: Colors.white)),
                                        Row(
                                            children: [
                                                SvgPicture.asset('images/temperature_white_icon.svg', width: 16, height: 16),
                                                Text('N/A', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.white))
                                            ],
                                        )
                                    ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 12),
                                            child: Text('DOC-In ${startDate == null ? '-' : '${Convert.getDay(startDate)}/${Convert.getMonthNumber(startDate)}/${Convert.getYear(startDate)}'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.white)),
                                        ),
                                        SvgPicture.asset(
                                            coop.day! > 0 && coop.day! <= 3 ?
                                            'images/one_to_three_day_icon.svg' :
                                            coop.day! > 3 && coop.day! <= 7 ?
                                            'images/four_to_seven_day_icon.svg' :
                                            coop.day! > 7 && coop.day! <= 13 ?
                                            'images/eight_to_thirteen_day_icon.svg' :
                                            coop.day! > 13 && coop.day! <= 18 ?
                                            'images/fourteen_to_eighteen_day_icon.svg' :
                                            coop.day! > 18 && coop.day! <= 23 ?
                                            'images/nineteen_to_twentythree_day_icon.svg' :
                                            coop.day! > 23 && coop.day! <= 28 ?
                                            'images/twentyfour_to_twentyeight_day_icon.svg' :
                                            'images/more_twentyeight_day_icon.svg',
                                            width: 112,
                                            height: 96,
                                        )
                                    ],
                                )
                            ]
                        )
                    ),
                    const SizedBox(height: 16),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.gray)),
                            color: Colors.white
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Row(
                                    children: [
                                        SvgPicture.asset('images/calendar_icon.svg', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        Text('Umur rata-rata', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                ),
                                Row(
                                    children: [
                                        Text('${monitoring.value.day}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                        const SizedBox(width: 4),
                                        Text('Hari', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                )
                            ],
                        ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.gray)),
                            color: Colors.white
                        ),
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
                                        Text(
                                            monitoring.value.performance!.bw!.actual!.toStringAsFixed(1),
                                            style: GlobalVar.whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: GlobalVar.bold,
                                                color: monitoring.value.performance!.bw!.actual! > monitoring.value.performance!.bw!.standard! ? GlobalVar.green : GlobalVar.red
                                            )
                                        ),
                                        Text(' / ${monitoring.value.performance?.bw?.standard}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                )
                            ],
                        ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.gray)),
                            color: Colors.white
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Row(
                                    children: [
                                        SvgPicture.asset('images/ip_icon.svg', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        Text('IP/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                ),
                                Row(
                                    children: [
                                        Text(
                                            monitoring.value.performance!.ip!.actual!.toStringAsFixed(1),
                                            style: GlobalVar.whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: GlobalVar.bold,
                                                color: monitoring.value.performance!.ip!.actual! > monitoring.value.performance!.ip!.standard! ? GlobalVar.green : GlobalVar.red
                                            )
                                        ),
                                        Text(' / ${monitoring.value.performance?.ip?.standard}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                )
                            ],
                        ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.gray)),
                            color: Colors.white
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Row(
                                    children: [
                                        SvgPicture.asset('images/fcr_icon.svg', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        Text('FCR/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                ),
                                Row(
                                    children: [
                                        Text(
                                            monitoring.value.performance!.fcr!.actual!.toStringAsFixed(1),
                                            style: GlobalVar.whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: GlobalVar.bold,
                                                color: monitoring.value.performance!.fcr!.actual! > monitoring.value.performance!.fcr!.standard! ? GlobalVar.green : GlobalVar.red
                                            )
                                        ),
                                        Text(' / ${monitoring.value.performance?.fcr?.standard}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                )
                            ],
                        ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.gray)),
                            color: Colors.white
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Row(
                                    children: [
                                        SvgPicture.asset('images/fcr_icon.svg', width: 24, height: 24),
                                        const SizedBox(width: 8),
                                        Text('Mortalitas/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                ),
                                Row(
                                    children: [
                                        Text(
                                            monitoring.value.performance!.mortality!.actual!.toStringAsFixed(1),
                                            style: GlobalVar.whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: GlobalVar.bold,
                                                color: monitoring.value.performance!.mortality!.actual! > monitoring.value.performance!.mortality!.standard! ? GlobalVar.green : GlobalVar.red
                                            )
                                        ),
                                        Text(' / ${monitoring.value.performance?.mortality?.standard}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ],
                                )
                            ],
                        ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.gray)),
                            color: Colors.white
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Detail Populasi', style: GlobalVar.boldTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                const SizedBox(height: 16),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Populasi Awal', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
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
                                                    Text(Convert.toCurrencyWithoutDecimal(monitoring.value.population!.mortality!.toString(), '', '.'), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
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
                                            Text('Total Panen', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                    Text(Convert.toCurrencyWithoutDecimal(monitoring.value.population!.harvested!.toString(), '', '.'), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
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
                                                    Text(Convert.toCurrencyWithoutDecimal(populationOutstanding.toString(), '', '.'), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                    const SizedBox(width: 4),
                                                    Text('Ekor', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                ],
                                            )
                                        ],
                                    ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Sisa Pakan', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                                Text(Convert.toCurrencyWithoutDecimal(feedOutstanding, '', '.'), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                const SizedBox(width: 4),
                                                Text('Karung', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
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
                                            Text('Perkiraan Habis', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Text(stockOutDate == null ? '-' : '${Convert.getDay(stockOutDate)}/${Convert.getMonthNumber(stockOutDate)}/${Convert.getYear(stockOutDate)}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                        ],
                                    ),
                                )
                            ]
                        )
                    ),
                    const SizedBox(height: 70)
                ]
            )
        );
    }

    Widget generateHistoryWidget() => historyActivity;

    /// The function generates a widget for a smart monitor.
    Widget generateMonitorWidget() => detailSmartMonitor;

    /// The function generates a profile widget with various routes for different
    /// pages.
    ///
    /// Returns:
    ///   a ProfileActivity widget.
    Widget generateProfileWidget() {
        return ProfileActivity(
            homeRoute: RoutePage.coopDashboard,
            changePassRoute: RoutePage.changePasswordPage,
            privacyRoute: RoutePage.privacyPage,
            termRoute: RoutePage.termPage,
            aboutUsRoute: RoutePage.aboutPage,
            helpRoute: RoutePage.helpPage,
            licenseRoute: RoutePage.licencePage
        );
    }
}

class CoopDashboardBinding extends Bindings {
    BuildContext context;
    CoopDashboardBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<CoopDashboardController>(() => CoopDashboardController(context: context));
    }
}