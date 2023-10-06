import 'package:common_page/profile/profile_activity.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_active_standard.dart';
import 'package:model/coop_model.dart';
import 'package:model/coop_performance.dart';
import 'package:model/monitoring.dart';
import 'package:model/population.dart';
import 'package:model/profile.dart';
import 'package:model/response/monitoring_performance_response.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class CoopDashboardController extends GetxController {
    BuildContext context;
    CoopDashboardController({required this.context});

    late Coop coop;
    late Profile? profile;

    var isLoading = false.obs;
    var homeTab = true.obs;
    var historyTab = false.obs;
    var monitorTab = false.obs;
    var profileTab = false.obs;

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
    void onInit() async {
        super.onInit();
        coop = Get.arguments[0];

        getMonitoringPerformance(coop);
        profile = await ProfileImpl().get();
    }

    void getMonitoringPerformance(Coop coop) {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    service: 'getPerformanceMonitoring',
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
                            print('$exception -> $stacktrace');
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void getMonitorData(Coop coop) {

    }

    void getHistoryData(Coop coop) {

    }

    void getProfile() {

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
    }

    void toMonitor() {
        homeTab.value = false;
        historyTab.value = false;
        monitorTab.value = true;
        profileTab.value = false;
    }
    void toProfile() {
        homeTab.value = false;
        historyTab.value = false;
        monitorTab.value = false;
        profileTab.value = true;
    }
    
    Widget generateHomeWidget() {
        DateTime startDate = Convert.getDatetime(coop.startDate!);
        DateTime stockOutDate = Convert.getDatetime(monitoring.value.feed!.stockoutDate!);
        num populationOutstanding = (monitoring.value.population!.total == null ? 0 : monitoring.value.population!.total!) -
                                    (monitoring.value.population!.harvested == null ? 0 : monitoring.value.population!.harvested!) -
                                    (monitoring.value.population!.mortality == null ? 0 : monitoring.value.population!.mortality!);
        String feedOutstanding = (monitoring.value.feed!.remaining == null ? '0' : monitoring.value.feed!.remaining!.toStringAsFixed(1));

        return RefreshIndicator(
            onRefresh: () => Future.delayed(
                const Duration(milliseconds: 200), () => getMonitoringPerformance(coop)
            ),
            child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        height: 155,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                                            child: Text('DOC-In ${Convert.getDay(startDate)}/${Convert.getMonthNumber(startDate)}/${Convert.getYear(startDate)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.white)),
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
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                                Padding(
                                    padding: const EdgeInsets.only(left: 8),
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
                                            Text('${Convert.getDay(stockOutDate)}/${Convert.getMonthNumber(stockOutDate)}/${Convert.getYear(stockOutDate)}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
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

    Widget generateHistoryWidget() {
        return RefreshIndicator(
            onRefresh: () => Future.delayed(
                const Duration(milliseconds: 200), () => getMonitorData(coop)
            ),
            child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [

                ],
            ),
        );
    }

    Widget generateMonitorWidget() {
        return RefreshIndicator(
            onRefresh: () => Future.delayed(
                const Duration(milliseconds: 200), () => getMonitorData(coop)
            ),
            child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [

                ],
            ),
        );
    }

    Widget generateProfileWidget() {
        return ProfileActivity(
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