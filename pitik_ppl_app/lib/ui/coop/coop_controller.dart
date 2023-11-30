
import 'dart:convert';
import 'dart:io';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/offline_body/smart_scale_body.dart';
import 'package:dao_impl/smart_scale_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/offlinecapability/offline_automation.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';

import '../../flavors.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class CoopController extends GetxController with GetSingleTickerProviderStateMixin {

    BuildContext context;
    CoopController({required this.context});

    var isLoading = false.obs;
    RxList<Coop?> coopList = <Coop?>[].obs;
    RxList<Coop?> coopFilteredList = <Coop?>[].obs;

    late TabController tabController;
    late String pushNotificationPayload;
    late EditField searchCoopField;

    @override
    void onInit() {
        super.onInit();
        _initMixpanel();

        // Start offline automation
        OfflineAutomation()
            .putWithRequest(SmartScaleImpl(), ServicePeripheral(keyMap: 'smartScaleApi', requestBody: SmartScaleBody(), baseUrl: ApiMapping().getBaseUrl()))
            .launch();

        tabController = TabController(vsync: this, length: 2);
        tabController.addListener(() {
            if (tabController.index == 0) {
                generateCoopList(true);
            } else {
                generateCoopList(false);
            }
        });

        searchCoopField = EditField(controller: GetXCreator.putEditFieldController("searchCoopField"), label: "", hint: "Cari kandang", alertText: "", textUnit: "", hideLabel: true, maxInput: 100,
            childPrefix: Padding(padding: const EdgeInsets.all(12), child: SvgPicture.asset('images/search_icon.svg'),), onTyping: (text, editField) {
                coopFilteredList.clear();
                if (text.isEmpty) {
                    coopFilteredList.addAll(coopList);
                } else {
                    for (var element in coopList) {
                        if (element!.coopName!.toLowerCase().contains(text.toLowerCase())) {
                            coopFilteredList.add(element);
                        }
                    }
                }

                coopFilteredList.refresh();
            }
        );

        generateCoopList(true);
    }

    @override
    void onReady() {
        super.onReady();
        WidgetsBinding.instance.addPostFrameCallback((_) => _launchDeeplink());
    }

    void _launchDeeplink() {
        pushNotificationPayload = Get.arguments ?? '';
        if (pushNotificationPayload.isNotEmpty) {
            Map<String, dynamic> payload = jsonDecode(pushNotificationPayload);
            payload = jsonDecode(payload['request']);

            Coop? coopDeeplink = Mapper.child<Coop>(payload['additionalParameters']["coop"]);
            if (payload['target'] == 'id.pitik.mobile.ui.activity.LoginActivity') {
                GlobalVar.invalidResponse();
            } else if (payload['target'] == 'id.pitik.mobile.ListOrderActivity' && !payload['additionalParameters']['isToDashboard']) {
                Get.toNamed(RoutePage.listOrderPage, arguments: [coopDeeplink, !payload['additionalParameters']['isToDashboard']])!.then((value) => _refreshCoopList());
            } else if (payload['target'] == 'id.pitik.mobile.RequestDocIn') {
                Get.toNamed(RoutePage.reqDocInPage, arguments: coopDeeplink)!.then((value) => generateCoopList(false)).then((value) => _refreshCoopList());
            } else if (payload['target'] == 'id.pitik.mobile.DocInActivity' && !payload['additionalParameters']['isToDashboard']) {
                Get.toNamed(RoutePage.docInPage, arguments: [coopDeeplink])!.then((value) => generateCoopList(true)).then((value) => _refreshCoopList());
            } else if (payload['target'] == '{navigation}[COOP_ACTIVE]') {
                tabController.index = 0;
                _refreshCoopList();
            } else if (payload['target'] == '{navigation}[COOP_IDLE]') {
                tabController.index = 1;
                _refreshCoopList();
            } else {
                Get.toNamed(RoutePage.coopDashboard, arguments: [coopDeeplink, payload])!.then((value) => _refreshCoopList());
            }
        }
    }

    void _initMixpanel() async {
        String? deviceTracking = "";
        String? osVersion = "";

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            deviceTracking = androidInfo.model;
            osVersion = Platform.operatingSystemVersion;
        } else {
            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            deviceTracking = iosInfo.model;
            osVersion = Platform.operatingSystem;
        }

        GlobalVar.initMixpanel(F.tokenMixpanel, {
            "Phone_Number": GlobalVar.profileUser!.phoneNumber,
            "Username": GlobalVar.profileUser!.phoneNumber,
            // "Location": "$latitude,$longitude",
            "Device": deviceTracking,
            "Phone_Carrier": 'NO SIMCARD',
            "OS": osVersion,

        });
    }

    void _clearCoopList() {
        coopList.clear();
        coopFilteredList.clear();
    }

    void _refreshCoopList() {
        if (tabController.index == 0) {
            generateCoopList(true);
        } else {
            generateCoopList(false);
        }
    }

    void generateCoopList(bool isCoopActive) {
        isLoading.value = true;
        _clearCoopList();

        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: "coopApi",
                    service: isCoopActive ? 'getCoopActive' : 'getCoopIdle',
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            _clearCoopList();

                            coopList.addAll((body as CoopListResponse).data);
                            coopFilteredList.addAll(coopList);

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

    void actionCoop(Coop coop) {
        if (tabController.index == 0) {
            if (coop.isNew != null && coop.isNew!) {
                _showCoopAdditionalButtonSheet(coop: coop, isRestCoop: false);
            } else {
                Get.toNamed(RoutePage.coopDashboard, arguments: [coop])!.then((value) => _refreshCoopList());
            }
        } else {
            _showCoopAdditionalButtonSheet(coop: coop, isRestCoop: true);
        }
    }

    void _showCoopAdditionalButtonSheet({required Coop coop, required bool isRestCoop}) {
        showModalBottomSheet(
            isScrollControlled: true,
            context: Get.context!,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                )
            ),
            builder: (context) => Container(
                color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Container(
                                    width: 60,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        color: GlobalVar.outlineColor
                                    )
                                )
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Mau memulai siklus?", style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange))
                                )
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Silahkan lakukan Order DOC in lalu Order dan Penerimaan Pakan-OVK", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: const Color(0xFF9E9D9D)))
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: ButtonOutline(
                                    controller: GetXCreator.putButtonOutlineController("orderCoopNew"),
                                    label: "Order",
                                    isHaveIcon: true,
                                    imageAsset: 'images/document_icon.svg',
                                    onClick: () {
                                        Get.back();
                                        Get.toNamed(RoutePage.listOrderPage, arguments: [coop, isRestCoop])!.then((value) => _refreshCoopList());
                                    }
                                )
                            ),
                            ButtonOutline(
                                controller: GetXCreator.putButtonOutlineController("docInCoopNew"),
                                label: "DOC-In",
                                isHaveIcon: true,
                                imageAsset: 'images/calendar_check_icon.svg',
                                onClick: () {
                                    Get.back();
                                    if(isRestCoop){
                                        Get.toNamed(RoutePage.reqDocInPage, arguments: coop)!.then((value) => generateCoopList(false)).then((value) => _refreshCoopList());
                                    } else {
                                        Get.toNamed(RoutePage.docInPage, arguments: coop)!.then((value) => generateCoopList(true)).then((value) => _refreshCoopList());
                                    }
                                }
                            ),
                            const SizedBox(height: 24)
                        ]
                    )
                )
            )
        );
    }

    bool _isCoopNew(Coop coop) {
        return coop.isNew != null && coop.isNew!;
    }

    Widget createCoopActiveCard(int index) {
        Coop coop = coopFilteredList[index]!;
        DateTime? startDate;
        if (coop.startDate != null) {
            startDate = Convert.getDatetime(coop.startDate!);
        }

        return GestureDetector(
            onTap: () => actionCoop(coop),
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: GlobalVar.primaryLight
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: Text(coop.coopName ?? '-', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black),overflow: TextOverflow.clip,)),
                                        _isCoopNew(coop) ? const SizedBox() : Text("Hari ${coop.day}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                    ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: Text('${coop.coopDistrict ?? '-'}, ${coop.coopCity ?? '-'}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), overflow: TextOverflow.clip,)),
                                        startDate != null ? Text(
                                            "DOC-In ${Convert.getDay(startDate)}/${Convert.getMonthNumber(startDate)}/${Convert.getYear(startDate)}",
                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                        ) : const SizedBox()
                                    ],
                                ),
                                const SizedBox(height: 8),
                                _isCoopNew(coop) ? Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: GlobalVar.greenBackground
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                        child: Text(GlobalVar.NEW, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.green)),
                                    ),
                                ) : const SizedBox(),
                                _isCoopNew(coop) ? const SizedBox() :
                                Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.grayBackground)),
                                        color: Colors.white
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Row(
                                                    children: [
                                                        SvgPicture.asset('images/bw_icon.svg', width: 24, height: 24),
                                                        const SizedBox(width: 8),
                                                        Text('BW/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ],
                                                ),
                                                coop.bw == null ? const SizedBox() :
                                                Row(
                                                    children: [
                                                        Text(coop.bw!.actual!.toStringAsFixed(1), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: coop.bw!.actual! > coop.bw!.standard! ? GlobalVar.green : GlobalVar.red)),
                                                        Text(' / ${coop.bw!.standard!}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ],
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                                SizedBox(height: _isCoopNew(coop) ? 0 : 8),
                                _isCoopNew(coop) ? const SizedBox() :
                                Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.grayBackground)),
                                        color: Colors.white
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Row(
                                                    children: [
                                                        SvgPicture.asset('images/ip_icon.svg', width: 24, height: 24),
                                                        const SizedBox(width: 8),
                                                        Text('IP/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ],
                                                ),
                                                coop.ip == null ? const SizedBox() :
                                                Row(
                                                    children: [
                                                        Text(coop.ip!.actual!.toStringAsFixed(1), style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: coop.ip!.actual! > coop.ip!.standard! ? GlobalVar.green : GlobalVar.red)),
                                                        Text(' / ${coop.ip!.standard!}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ],
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                                coop.isActionNeeded != null && coop.isActionNeeded! ?
                                ButtonFill(controller: GetXCreator.putButtonFillController("btnCoopActionNeeded"), label: 'Cek Laporan Harian',
                                    onClick: () {
                                        // TO DAILY REPORT
                                    }
                                ) : const SizedBox()
                            ]
                        ),
                    ),
                ),
            ),
        );
    }

    Widget createCoopIdleCard(int index) {
        Coop coop = coopFilteredList[index]!;
        return GestureDetector(
            onTap: () => actionCoop(coop),
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: GlobalVar.primaryLight
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(coop.coopName!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                Text('${coop.coopDistrict!}, ${coop.coopCity!}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 8),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        color:
                                            coop.statusText == GlobalVar.SUBMISSION_STATUS || coop.statusText == GlobalVar.OVK_REJECTED || coop.statusText == GlobalVar.REJECTED ?
                                                GlobalVar.redBackground :
                                            coop.statusText == GlobalVar.SUBMITTED_STATUS || coop.statusText == GlobalVar.SUBMITTED_OVK || coop.statusText == GlobalVar.SUBMITTED_DOC_IN || coop.statusText == GlobalVar.NEED_APPROVED ?
                                                GlobalVar.primaryLight2 :
                                            coop.statusText == GlobalVar.APPROVED || coop.statusText == GlobalVar.NEW ?
                                                GlobalVar.greenBackground :
                                            coop.statusText == GlobalVar.PROSESSING ?
                                                GlobalVar.primaryLight3 :
                                            Colors.transparent
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                        child:
                                            coop.statusText == GlobalVar.SUBMISSION_STATUS || coop.statusText == GlobalVar.OVK_REJECTED || coop.statusText == GlobalVar.REJECTED ?
                                                Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.red)) :
                                            coop.statusText == GlobalVar.SUBMITTED_STATUS || coop.statusText == GlobalVar.SUBMITTED_OVK || coop.statusText == GlobalVar.SUBMITTED_DOC_IN || coop.statusText == GlobalVar.NEED_APPROVED ?
                                                Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)) :
                                            coop.statusText == GlobalVar.APPROVED || coop.statusText == GlobalVar.NEW ?
                                                Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.green)) :
                                            coop.statusText == GlobalVar.PROSESSING ?
                                                Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.yellow)) :
                                            const SizedBox()
                                    ),
                                )
                            ]
                        ),
                    ),
                ),
            ),
        );
    }
}

class CoopBindings extends Bindings {
    BuildContext context;
    CoopBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<CoopController>(() => CoopController(context: context));
    }
}