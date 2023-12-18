
import 'dart:async';

import 'package:common_page/smart_monitor/detail_smartmonitor_activity.dart';
import 'package:common_page/smart_monitor/detail_smartmonitor_controller.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/profile.dart';
import 'package:model/report.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:model/response/farm_info_response.dart';
import 'package:model/response/task_ticket_response.dart';
import 'package:model/task_ticket_model.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pitik_ppl_app/ui/dashboard/dashboard_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 13/12/2023

class FarmingDashboardController extends GetxController {
    BuildContext context;
    FarmingDashboardController({required this.context});

    late Profile? profile;
    late DetailSmartMonitor detailSmartMonitor;

    var isLoading = false.obs;
    var isLoadingFarmList = false.obs;
    var isLoadingFarmInfo = false.obs;
    var isLoadingTaskTicketList = false.obs;
    var isLoadMore = false.obs;
    var coopSelected = 0.obs;
    var homeTab = true.obs;
    var performTab = false.obs;
    var monitorTab = false.obs;
    var profileTab = false.obs;
    var expanded = false.obs;
    var page = 1.obs;

    RxList<Coop?> coopList = <Coop?>[Coop()].obs;
    RxInt countUnreadNotifications = 0.obs;
    RxList<TaskTicket?> taskTicketList = <TaskTicket?>[].obs;

    var showSmartScaleAlert = false.obs;
    var showSmartControllerAlert = false.obs;
    var showSmartCameraAlert = false.obs;
    var showSmartConventronAlert = false.obs;
    var showIssueReportAlert = false.obs;

    // for detail population
    var farmingCycleStartDate = ''.obs;
    var estimationPopulation = '- Ekor'.obs;
    var initialPopulation = '- Ekor'.obs;
    var totalMortality = '-'.obs;
    var deadChick = '- Ekor'.obs;
    var totalCulled = '- Ekor'.obs;
    var totalHarvested = '- Ekor'.obs;

    // for task ticket list
    var isAlertTicket = true.obs;
    var isCurrentTicket = false.obs;
    var isLateTicket = false.obs;
    var isDoneTicket = false.obs;

    @override
    void onInit() {
        super.onInit();
        detailSmartMonitor = DetailSmartMonitor(
            controller: Get.put(DetailSmartMonitorController(
                tag: "smartMonitorForOwnerAppDashboard",
                context: Get.context!,
            ),  tag: "smartMonitorForOwnerAppDashboard"),
            widgetLoading: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                    children: [
                        Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                        const SizedBox(height: 24),
                        Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                        const SizedBox(height: 24),
                        Image.asset("images/card_lazy.gif", width: MediaQuery.of(Get.context!).size.width - 32),
                    ]
                )
            ),
            hideBuildings: true,
        );

        refreshData();
    }

    void _getTaskTicketList({int page = 1}) => AuthImpl().get().then((auth) {
        if (auth != null) {
            String url = isAlertTicket.isTrue ? 'v2/alerts/summary/${coopList[coopSelected.value]!.farmingCycleId}' :
                         isCurrentTicket.isTrue ? 'v2/tasks/current/${coopList[coopSelected.value]!.farmingCycleId}' :
                         isLateTicket.isTrue ? 'v2/tasks/late/${coopList[coopSelected.value]!.farmingCycleId}' :
                         'v2/tasks/done/${coopList[coopSelected.value]!.farmingCycleId}';

            Service.push(
                apiKey: ApiMapping.taskApi,
                service: ListApi.getTaskTicketList,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, url, page, 10, 'DESC'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as TaskTicketResponse).data.isNotEmpty) {
                            if (page == 1) {
                                taskTicketList.clear();
                                taskTicketList.value = body.data;
                            } else {
                                taskTicketList.addAll(body.data);
                            }
                        }

                        isLoadMore.value = false;
                        isLoadingTaskTicketList.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        isLoadMore.value = false;
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        );
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        isLoadMore.value = false;
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        );
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void refreshData() async {
        profile = await ProfileImpl().get();
        _getFarmList();
        DashboardCommon.getUnreadNotificationCount(countUnreadNotifications: countUnreadNotifications);
    }

    void _refreshCoop() {
        page.value = 1;
        isLoadingTaskTicketList.value = true;

        _getFarmInfo();
        _getTaskTicketList();
        _initCoopAndLatestConditionSmartMonitor();
    }

    void _initCoopAndLatestConditionSmartMonitor() {
        detailSmartMonitor.controller.rejuvenateCoop(newCoop: coopList[coopSelected.value]!);
        detailSmartMonitor.controller.getInitialLatestDataSmartMonitor();
    }

    void _getFarmList() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoadingFarmList.value = true;
            isLoadingFarmInfo.value = true;
            isLoadingTaskTicketList.value = true;

            Service.push(
                apiKey: ApiMapping.farmMonitoringApi,
                service: ListApi.farmList,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as CoopListResponse).data.isNotEmpty) {
                            coopList.value = body.data;
                            coopSelected.value = 0;

                            _refreshCoop();
                            isLoadingFarmList.value = false;
                        }
                    },
                    onResponseFail: (code, message, body, id, packet) => Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red
                    ),
                    onResponseError: (exception, stacktrace, id, packet) => Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan Internal",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red
                    ),
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void _getFarmInfo() => AuthImpl().get().then((auth) {
        if (auth != null) {
            Service.push(
                apiKey: ApiMapping.farmMonitoringApi,
                service: ListApi.farmInfo,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coopList[coopSelected.value]!.farmingCycleId}/summary'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as FarmInfoResponse).data != null && body.data!.farmingInfo != null) {
                            farmingCycleStartDate.value = body.data!.farmingInfo!.farmingCycleStartDate ?? '';
                            estimationPopulation.value = body.data!.farmingInfo!.estimatedPopulation == null ? '- Ekor' : '${Convert.toCurrencyWithoutDecimal(body.data!.farmingInfo!.estimatedPopulation!.toString(), '', '.')} Ekor';
                            initialPopulation.value = body.data!.farmingInfo!.initialPopulation == null ? '- Ekor' : '${Convert.toCurrencyWithoutDecimal(body.data!.farmingInfo!.initialPopulation!.toString(), '', '.')} Ekor';
                            totalMortality.value = body.data!.farmingInfo!.mortality == null ? '- Ekor' : '${Convert.toCurrencyWithoutDecimal(body.data!.farmingInfo!.mortality!.toString(), '', '.')} Ekor';
                            deadChick.value = body.data!.farmingInfo!.deadChick == null ? '- Ekor' : '${Convert.toCurrencyWithoutDecimal(body.data!.farmingInfo!.deadChick!.toString(), '', '.')} Ekor';
                            totalCulled.value = body.data!.farmingInfo!.culled == null ? '- Ekor' : '${Convert.toCurrencyWithoutDecimal(body.data!.farmingInfo!.culled!.toString(), '', '.')} Ekor';
                            totalHarvested.value = body.data!.farmingInfo!.harvested == null ? '- Ekor' : '${Convert.toCurrencyWithoutDecimal(body.data!.farmingInfo!.harvested!.toString(), '', '.')} Ekor';

                            isLoadingFarmInfo.value = false;
                        }
                    },
                    onResponseFail: (code, message, body, id, packet) => Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red
                    ),
                    onResponseError: (exception, stacktrace, id, packet) => Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan Internal",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red
                    ),
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void toHome(BuildContext context) {
        homeTab.value = true;
        performTab.value = false;
        monitorTab.value = false;
        profileTab.value = false;

        // getMonitoringPerformance(coop);
    }

    void toPerform() {
        homeTab.value = false;
        performTab.value = true;
        monitorTab.value = false;
        profileTab.value = false;

        // historyActivity.controller.refreshData();
    }

    void toMonitor() {
        homeTab.value = false;
        performTab.value = false;
        monitorTab.value = true;
        profileTab.value = false;

        detailSmartMonitor.controller.getInitialLatestDataSmartMonitor();
    }

    void toProfile() {
        homeTab.value = false;
        performTab.value = false;
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
            backgroundColor: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 20, top: 16),
                                    child: Text("Fitur", style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                ),
                                const SizedBox(height: 16),
                                Padding(    // ROW 1 IoT
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            DashboardCommon.createMenu(
                                                title: "Smart\nScale",
                                                imagePath: 'images/smart_scale_icon.svg',
                                                status: showSmartScaleAlert.value,
                                                function: () => Get.toNamed(RoutePage.listSmartScale, arguments: DashboardCommon.getListSmartScaleBundle(coop: coopList[coopSelected.value]!))
                                            ),
                                            DashboardCommon.createMenu(
                                                title: "Smart\nController",
                                                imagePath: 'images/smart_controller_icon.svg',
                                                status: showSmartControllerAlert.value,
                                                function: () => Get.toNamed(RoutePage.smartControllerList, arguments: [coopList[coopSelected.value]!])
                                            ),
                                            DashboardCommon.createMenu(
                                                title: "Smart\nCamera",
                                                imagePath: 'images/record_icon.svg',
                                                status: showSmartCameraAlert.value,
                                                function: () => Get.toNamed(RoutePage.listSmartCameraDay, arguments: coopList[coopSelected.value]!)
                                            )
                                        ]
                                    )
                                ),
                                const SizedBox(height: 16),
                                Padding(    // ROW 1 PROCUREMENT
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            DashboardCommon.createMenu(title: "Smart\nConventron", imagePath: 'images/smart_conventron_icon.svg', status: showSmartConventronAlert.value, function: () {}),
                                            DashboardCommon.createMenu(title: "Lapor\nIsu", imagePath: 'images/issue_report_icon.svg', status: showIssueReportAlert.value, customBackground: GlobalVar.redBackground, function: () {}),
                                            DashboardCommon.createMenu(title: "Chat", imagePath: 'images/chat_icon.svg', status: showIssueReportAlert.value, function: () {}),
                                        ],
                                    ),
                                ),
                            ]
                        )
                    )
                )
            )
        );
    }

    String _getTemperatureText() {
        if (detailSmartMonitor.controller.deviceSummary.value != null && detailSmartMonitor.controller.deviceSummary.value!.temperature != null) {
            return '${detailSmartMonitor.controller.deviceSummary.value!.temperature!.value}${detailSmartMonitor.controller.deviceSummary.value!.temperature!.uom}';
        } else {
            return 'N/A';
        }
    }

    /// The function `generateHomeWidget()` returns a widget that displays various
    /// information related to a coop's monitoring performance and population
    /// details.
    ///
    /// Returns:
    ///   a widget of type `RefreshIndicator` wrapped in a `ListView`.
    Widget generateHomeWidget() {
        DateTime? startDate = farmingCycleStartDate.value == '' ? null : Convert.getDatetime(farmingCycleStartDate.value);
        return RefreshIndicator(
            color: GlobalVar.primaryOrange,
            onRefresh: () => Future.delayed(
                const Duration(milliseconds: 200), () => refreshData()
            ),
            child: NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                    final metrics = scrollEnd.metrics;
                    if (metrics.atEdge && metrics.pixels != 0) {
                        isLoadMore.value = true;
                        page.value++;
                        _getTaskTicketList(page: page.value);
                    }
                    return true;
                },
                child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                        isLoadingFarmInfo.isTrue ? Image.asset("images/banner_lazy_load.gif") : Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: GlobalVar.primaryOrange
                            ),
                            child: Column(
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text(startDate == null ? '-' : '${Convert.getDay(startDate)} ${Convert.getMonth(startDate)} ${Convert.getYear(startDate)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.white)),
                                            Row(
                                                children: [
                                                    SvgPicture.asset('images/temperature_white_icon.svg', width: 16, height: 16),
                                                    Text(_getTemperatureText(), style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.white))
                                                ],
                                            )
                                        ],
                                    ),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text('Hari ${coopList[coopSelected.value]!.day ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.medium, color: Colors.white)),
                                                    const SizedBox(height: 8),
                                                    Text('Populasi hari ini', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: Colors.white)),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                                            color: Colors.white
                                                        ),
                                                        child: Text(estimationPopulation.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange))
                                                    )
                                                ]
                                            ),
                                            coopList[coopSelected.value]!.day != null ? SvgPicture.asset(
                                                coopList[coopSelected.value]!.day! > 0 && coopList[coopSelected.value]!.day! <= 3 ?
                                                'images/one_to_three_day_icon.svg' :
                                                coopList[coopSelected.value]!.day! > 3 && coopList[coopSelected.value]!.day! <= 7 ?
                                                'images/four_to_seven_day_icon.svg' :
                                                coopList[coopSelected.value]!.day! > 7 && coopList[coopSelected.value]!.day! <= 13 ?
                                                'images/eight_to_thirteen_day_icon.svg' :
                                                coopList[coopSelected.value]!.day! > 13 && coopList[coopSelected.value]!.day! <= 18 ?
                                                'images/fourteen_to_eighteen_day_icon.svg' :
                                                coopList[coopSelected.value]!.day! > 18 && coopList[coopSelected.value]!.day! <= 23 ?
                                                'images/nineteen_to_twentythree_day_icon.svg' :
                                                coopList[coopSelected.value]!.day! > 23 && coopList[coopSelected.value]!.day! <= 28 ?
                                                'images/twentyfour_to_twentyeight_day_icon.svg' :
                                                'images/more_twentyeight_day_icon.svg',
                                                width: MediaQuery.of(Get.context!).size.width * 0.25,
                                                height: MediaQuery.of(Get.context!).size.width * 0.20,
                                            ) : const SizedBox()
                                        ]
                                    )
                                ]
                            )
                        ),
                        const SizedBox(height: 16),
                        isLoadingFarmInfo.isTrue ? Image.asset("images/banner_lazy_load.gif") : GFAccordion(
                            margin: EdgeInsets.zero,
                            title: 'Detail Populasi',
                            textStyle: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 14),
                            onToggleCollapsed: (isExpand) {
                                if (isExpand) {
                                    expanded.value = true;
                                } else {
                                    expanded.value = false;
                                }
                            },
                            collapsedTitleBackgroundColor: GlobalVar.primaryLight,
                            expandedTitleBackgroundColor: GlobalVar.primaryLight,
                            showAccordion: expanded.value,
                            collapsedIcon: SvgPicture.asset("images/arrow_down.svg"),
                            expandedIcon: SvgPicture.asset("images/arrow_up.svg"),
                            titleBorderRadius: expanded.isTrue ? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
                            contentBorder: const Border(
                                bottom: BorderSide(color:GlobalVar.primaryLight, width: 1),
                                left: BorderSide(color: GlobalVar.primaryLight, width: 1),
                                right: BorderSide(color: GlobalVar.primaryLight, width: 1),
                                top: BorderSide(color: GlobalVar.primaryLight, width: 1),
                            ),
                            contentBorderRadius: expanded.isTrue ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
                            contentBackgroundColor: GlobalVar.primaryLight,
                            contentChild: Column(
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Populasi Awal', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Text(initialPopulation.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                        ]
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Total Mortalitas', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Text(totalMortality.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                        ]
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Ayam Mati', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Text(deadChick.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                        ]
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Dimusnahkan', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Text(totalCulled.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                        ]
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Dipanen', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                            Text(totalHarvested.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                        ]
                                    )
                                ]
                            )
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                            width: MediaQuery.of(Get.context!).size.width - 36,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    GestureDetector(
                                        onTap: () {
                                            isAlertTicket.value = true;
                                            isCurrentTicket.value = false;
                                            isLateTicket.value = false;
                                            isDoneTicket.value = false;

                                            page.value = 1;
                                            isLoadingTaskTicketList.value = true;
                                            _getTaskTicketList();
                                        },
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                Text('Peringatan', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: isAlertTicket.isTrue ? GlobalVar.red : GlobalVar.gray)),
                                                const SizedBox(height: 6),
                                                SizedBox(
                                                    width: (MediaQuery.of(Get.context!).size.width - 36) / 4.5,
                                                    height: 3,
                                                    child: Divider(color: isAlertTicket.isTrue ? GlobalVar.red : Colors.white, thickness: 3),
                                                )
                                            ]
                                        )
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                        onTap: () {
                                            isAlertTicket.value = false;
                                            isCurrentTicket.value = true;
                                            isLateTicket.value = false;
                                            isDoneTicket.value = false;

                                            page.value = 1;
                                            isLoadingTaskTicketList.value = true;
                                            _getTaskTicketList();
                                        },
                                        child: Column(
                                            children: [
                                                Text('Berlangsung', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: isCurrentTicket.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray)),
                                                const SizedBox(height: 6),
                                                SizedBox(
                                                    width: (MediaQuery.of(Get.context!).size.width - 36) / 4,
                                                    height: 3,
                                                    child: Divider(color: isCurrentTicket.isTrue ? GlobalVar.primaryOrange : Colors.white, thickness: 3),
                                                )
                                            ]
                                        ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                        onTap: () {
                                            isAlertTicket.value = false;
                                            isCurrentTicket.value = false;
                                            isLateTicket.value = true;
                                            isDoneTicket.value = false;

                                            page.value = 1;
                                            isLoadingTaskTicketList.value = true;
                                            _getTaskTicketList();
                                        },
                                        child: Column(
                                            children: [
                                                Text('Telat', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: isLateTicket.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray)),
                                                const SizedBox(height: 6),
                                                SizedBox(
                                                    width: (MediaQuery.of(Get.context!).size.width - 36) / 7,
                                                    height: 3,
                                                    child: Divider(color: isLateTicket.isTrue ? GlobalVar.primaryOrange : Colors.white, thickness: 3),
                                                )
                                            ]
                                        ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                        onTap: () {
                                            isAlertTicket.value = false;
                                            isCurrentTicket.value = false;
                                            isLateTicket.value = false;
                                            isDoneTicket.value = true;

                                            page.value = 1;
                                            isLoadingTaskTicketList.value = true;
                                            _getTaskTicketList();
                                        },
                                        child: Column(
                                            children: [
                                                Text('Selesai', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: isDoneTicket.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray)),
                                                const SizedBox(height: 6),
                                                SizedBox(
                                                    width: (MediaQuery.of(Get.context!).size.width - 36) / 6,
                                                    height: 3,
                                                    child: Divider(color: isDoneTicket.isTrue ? GlobalVar.primaryOrange : Colors.white, thickness: 3),
                                                )
                                            ]
                                        )
                                    )
                                ]
                            )
                        ),
                        const SizedBox(height: 16),
                        isLoadingTaskTicketList.isTrue ? Image.asset("images/card_height_450_lazy.gif") : Column(
                            children: List.generate(taskTicketList.length, (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                    onTap: () {
                                        if (taskTicketList[index]!.isDailyReport != null && taskTicketList[index]!.isDailyReport!) {
                                            Report report = Report(
                                                taskTicketId: taskTicketList[index]!.id,
                                                date: taskTicketList[index]!.date,
                                                status: isCurrentTicket.isTrue ? 'Berlangsung' : isLateTicket.isTrue ? 'Telat' : 'Selesai'
                                            );

                                            coopList[coopSelected.value]!.startDate = farmingCycleStartDate.value;
                                            if (isDoneTicket.isTrue) {
                                                Get.toNamed(RoutePage.dailyReportDetail, arguments: [coopList[coopSelected.value], report])!.then((value) => _getTaskTicketList());
                                            } else {
                                                Get.toNamed(RoutePage.dailyReportForm, arguments: [coopList[coopSelected.value], report])!.then((value) => _getTaskTicketList());
                                            }
                                        } else {
                                            Get.snackbar(
                                                "Pesan",
                                                "Fitur belum tersedia...!",
                                                snackPosition: SnackPosition.TOP,
                                                colorText: Colors.white,
                                                backgroundColor: Colors.red
                                            );
                                        }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            color: isAlertTicket.isTrue ? GlobalVar.redBackground : GlobalVar.primaryLight
                                        ),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Flexible(child: SvgPicture.asset(isAlertTicket.isTrue ? 'images/alert_icon.svg' : isDoneTicket.isTrue ? 'images/checkbox_circle_green.svg' : 'images/error_icon.svg', width: 24, height: 24)),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                    flex: 8,
                                                    child: Column(
                                                        children: [
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Expanded(child: Text(taskTicketList[index]!.title ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black), overflow: TextOverflow.clip)),
                                                                    Text(taskTicketList[index]!.date == null ? '-' : Convert.getDate(taskTicketList[index]!.date), style: GlobalVar.subTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                ]
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Html(
                                                                data: taskTicketList[index]!.instruction,
                                                                style: {
                                                                    "body": Style(
                                                                        fontSize: FontSize(10),
                                                                        fontWeight: GlobalVar.medium,
                                                                        color: GlobalVar.grayText,
                                                                        margin: Margins.all(0)
                                                                    )
                                                                }
                                                            )
                                                        ]
                                                    )
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(child: Icon(Icons.arrow_forward_ios, color: isAlertTicket.isTrue ? GlobalVar.red : GlobalVar.primaryOrange))
                                            ]
                                        )
                                    ),
                                )
                            ))
                        ),
                        isLoadMore.isTrue ? const Center(child: CircularProgressIndicator(color: GlobalVar.primaryOrange)) : const SizedBox(),
                        const SizedBox(height: 60)
                    ]
                )
            )
        );
    }

    Widget generatePerformWidget() => Container();

    /// The function generates a widget for a smart monitor.
    Widget generateMonitorWidget() => detailSmartMonitor;

    void showCoopList() => showMenu(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
            )
        ),
        color: Colors.white,
        position: const RelativeRect.fromLTRB(0, 110, 0.0, 0.0),
        items: List.generate(coopList.length, (index) => PopupMenuItem<int>(
            value: index,
            child: Column(
                children: [
                    Row(
                        children: [
                            index == coopSelected.value ? SvgPicture.asset("images/on_spin.svg") : SvgPicture.asset("images/off_spin.svg"),
                            const SizedBox(width: 16),
                            Text('${coopList[index]!.coopName ?? '- '} (Hari ${coopList[index]!.day ?? '-'})', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                        ]
                    ),
                    const SizedBox(height: 10)
                ]
            )
        ))
    ).then((indexSelected) {
        coopSelected.value = indexSelected ?? 0;
        _refreshCoop();
    });
}

class FarmingDashboardBinding extends Bindings {
    BuildContext context;
    FarmingDashboardBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<FarmingDashboardController>(() => FarmingDashboardController(context: context));
}