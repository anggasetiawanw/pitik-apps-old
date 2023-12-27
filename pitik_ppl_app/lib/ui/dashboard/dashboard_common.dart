
import 'dart:async';

import 'package:common_page/profile/profile_activity.dart';
import 'package:common_page/smart_scale/bundle/list_smart_scale_bundle.dart';
import 'package:common_page/smart_scale/bundle/smart_scale_weighing_bundle.dart';
import 'package:common_page/smart_scale/detail_smart_scale/detail_smart_scale_activity.dart';
import 'package:common_page/smart_scale/list_smart_scale/list_smart_scale_controller.dart';
import 'package:common_page/smart_scale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:components/global_var.dart';
import 'package:components/item_smart_scale_day/item_smart_scale_day.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/smart_scale_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/list_smart_scale_response.dart';
import 'package:model/smart_scale/smart_scale_model.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 13/12/2023

class DashboardCommon {

    static void getUnreadNotificationCount({required RxInt countUnreadNotifications}) => AuthImpl().get().then((auth) => {
        if (auth != null){
            Service.push(
                apiKey: ApiMapping.api,
                service: ListApi.countUnreadNotifications,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) => countUnreadNotifications.value = (body.data),
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
            )
        } else {
            GlobalVar.invalidResponse()
        }
    });

    static ListSmartScaleBundle getListSmartScaleBundle({required Coop coop, String? startDateCustom}) => ListSmartScaleBundle(
        getCoop: () => coop,
        isShowWeighingButton: () => false,
        getWeighingBundle: () => _getSmartScaleWeighingBundle(coop: coop),
        onGetSmartScaleListData: (controller) => AuthImpl().get().then((auth) {
            if (auth != null) {
                Service.push(
                    apiKey: "smartScaleApi",
                    service: ListApi.getListHistoryScale,
                    context: Get.context!,
                    body: [auth.token, auth.id, 'v2/smart-scale/weighing/${coop.farmingCycleId}', controller.pageSmartScale.value, controller.limit.value, controller.dateFilter.value == '' ? null : controller.dateFilter.value],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            controller.smartScaleList.value = body.data;
                            try {
                                _ascendingHistory(controller, coop, startDateCustom);
                            } catch (e, s) {
                                print('$e -> $s');
                            }

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

    static SmartScaleWeighingBundle _getSmartScaleWeighingBundle({required Coop coop}) => SmartScaleWeighingBundle(
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

    static void _ascendingHistory(ListSmartScaleController controller, Coop coop, String? startDateCustom) {
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

            DateTime dateTime = Convert.getDatetime(startDateCustom ?? coop.startDate!).add(Duration(days: i));
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

    /// The function generates a profile widget with various routes for different
    /// pages.
    ///
    /// Returns:
    ///   a ProfileActivity widget.
    static Widget generateProfileWidget() {
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

    static Widget createMenu({required String title, required String imagePath, required bool status, required Function() function, Color? customBackground}) {
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
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            color: customBackground ?? GlobalVar.primaryLight2
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
}