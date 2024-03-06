import 'dart:convert';
import 'dart:io';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/search_bar/search_bar.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/offline_body/smart_scale_body.dart';
import 'package:dao_impl/smart_scale_impl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine/offlinecapability/offline_automation.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/check_version.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/gps_util.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:model/coop_model.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../api_mapping/api_mapping.dart';
import '../../flavors.dart';
import '../../route.dart';

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
  late SearchBarField searchCoopBarField = SearchBarField(
    controller: GetXCreator.putSearchBarController('searchCoopBarField'),
    hint: 'Cari kandang',
    items: const ['Semua', 'Broiler', 'Layer'],
    onTyping: (text, field) {
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
    },
    onCategorySelected: (text) => generateCoopList(tabController.index == 0),
  );

  int startTime = DateTime.now().millisecondsSinceEpoch;

  CheckVersion checkVersion = CheckVersion(
    appStoreId: F.appStoreId,
    androidAppBundleId: F.androidAppBundleId,
  );

  RxBool justLayer = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initMixpanel();
    checkVersion.check(context);
    justLayer.value = FirebaseRemoteConfig.instance.getBool('just_layer');
    // Start offline automation
    OfflineAutomation().putWithRequest(SmartScaleImpl(), ServicePeripheral(keyMap: 'smartScaleApi', requestBody: SmartScaleBody(), baseUrl: ApiMapping().getBaseUrl())).launch();

    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      if (tabController.index == 0) {
        generateCoopList(true);
      } else {
        generateCoopList(false);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (justLayer.value) {
        searchCoopBarField.controller.hideAccordion();
        searchCoopBarField.controller.setSelectedValue('Layer');
        generateCoopList(true);
      } else {
        searchCoopBarField.controller.setSelectedValue('Semua');
        generateCoopList(true);
      }
      _launchDeeplink();
      // track render page time
      GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'Page': 'Coop_List'});
    });
  }

  void _launchDeeplink() {
    pushNotificationPayload = Get.arguments ?? '';
    if (pushNotificationPayload.isNotEmpty) {
      Map<String, dynamic> payload = jsonDecode(pushNotificationPayload);
      payload = jsonDecode(payload['request']);

      final Coop? coopDeeplink = Mapper.child<Coop>(payload['additionalParameters']['coop']);
      if (payload['target'] == 'id.pitik.mobile.ui.activity.LoginActivity') {
        GlobalVar.invalidResponse();
      } else if (payload['target'] == 'id.pitik.mobile.ListOrderActivity' && !payload['additionalParameters']['isToDashboard']) {
        Get.toNamed(RoutePage.listOrderPage, arguments: [coopDeeplink, !payload['additionalParameters']['isToDashboard']])!.then((value) => _refreshCoopList());
      } else if (payload['target'] == 'id.pitik.mobile.RequestDocIn') {
        Get.toNamed(RoutePage.reqDocInPage, arguments: [coopDeeplink])!.then((value) => generateCoopList(false)).then((value) => _refreshCoopList());
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

  Future<void> _initMixpanel() async {
    String? deviceTracking = '';
    String? osVersion = '';

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String phoneCarrier = 'N/A';
    List<SimCard> simCard = [];
    try {
      simCard = await MobileNumber.getSimCards!;
    } catch (_) {}
    if (simCard.isNotEmpty) {
      phoneCarrier = simCard[0].carrierName ?? 'N/A';
    }

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceTracking = androidInfo.model;
      osVersion = Platform.operatingSystemVersion;
    } else {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceTracking = iosInfo.model;
      osVersion = Platform.operatingSystem;
    }

    GlobalVar.initMixpanel(F.tokenMixpanel, {
      'Phone_Number': GlobalVar.profileUser!.phoneNumber,
      'Username': GlobalVar.profileUser!.phoneNumber,
      'User_Type': GlobalVar.profileUser!.userType,
      'Version': packageInfo.version,
      'Location': '${GpsUtil.latitude()},${GpsUtil.longitude()}',
      'Device': deviceTracking,
      'Phone_Carrier': phoneCarrier,
      'OS': osVersion,
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

  String? _getFarmCategory() {
    if (justLayer.value) {
      return 'LAYER';
    } else {
      if (searchCoopBarField.controller.selectedValue.value != 'Broiler' && searchCoopBarField.controller.selectedValue.value != 'Layer') {
        return null;
      } else {
        return searchCoopBarField.controller.selectedValue.value.toUpperCase();
      }
    }
  }

  void generateCoopList(bool isCoopActive) {
    isLoading.value = true;
    GlobalVar.track('Open_kandang_list');
    final int startTime = DateTime.now().millisecondsSinceEpoch;
    _clearCoopList();

    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              Service.push(
                  apiKey: 'coopApi',
                  service: isCoopActive ? 'getCoopActive' : 'getCoopIdle',
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, true, _getFarmCategory()],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        _clearCoopList();

                        coopList.addAll((body as CoopListResponse).data);
                        coopFilteredList.addAll(coopList);

                        isLoading.value = false;
                        GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': isCoopActive ? 'getCoopActive' : 'getCoopIdle', 'Result': 'Success'});
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        isLoading.value = false;
                        GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': isCoopActive ? 'getCoopActive' : 'getCoopIdle', 'Result': 'Fail'});
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                        isLoading.value = false;
                        GlobalVar.trackWithMap('Render_time', {'value': Convert.getRenderTime(startTime: startTime), 'API': isCoopActive ? 'getCoopActive' : 'getCoopIdle', 'Result': 'Error'});
                      },
                      onTokenInvalid: () => GlobalVar.invalidResponse()))
            }
          else
            {GlobalVar.invalidResponse()}
        });
  }

  void actionCoop(Coop coop) {
    if (tabController.index == 0) {
      if (coop.isNew != null && coop.isNew!) {
        GlobalVar.trackWithMap('Click_card_kandang', {'Coop_Status': 'NEW'});
        _showCoopAdditionalButtonSheet(coop: coop, isRestCoop: false);
      } else {
        GlobalVar.trackWithMap('Click_card_kandang', {'Coop_Status': 'ACTIVE'});
        Get.toNamed(coop.farmCategory == 'BROILER' ? RoutePage.coopDashboard : RoutePage.layerDashboard, arguments: [coop])!.then((value) => _refreshCoopList());
      }
    } else {
      GlobalVar.trackWithMap('Click_card_kandang', {'Coop_Status': 'IDLE'});
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
        )),
        builder: (context) => ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(padding: const EdgeInsets.only(top: 16), child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                      Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Align(alignment: Alignment.centerLeft, child: Text('Mau memulai siklus?', style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange)))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_isBroiler(coop) ? 'Silahkan lakukan Order DOC in lalu Order dan Penerimaan Pakan-OVK' : 'Silahkan lakukan pengisian form Pullet In untuk memulai siklus',
                              style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: const Color(0xFF9E9D9D)))),
                      if (_isBroiler(coop)) ...[
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ButtonOutline(
                                controller: GetXCreator.putButtonOutlineController('orderCoopNew'),
                                label: 'Order',
                                isHaveIcon: true,
                                imageAsset: 'images/document_icon.svg',
                                onClick: () {
                                  Get.back();
                                  Get.toNamed(RoutePage.listOrderPage, arguments: [coop, isRestCoop])!.then((value) => _refreshCoopList());
                                })),
                        ButtonOutline(
                            controller: GetXCreator.putButtonOutlineController('docInCoopNew'),
                            label: 'DOC-In',
                            isHaveIcon: true,
                            imageAsset: 'images/calendar_check_icon.svg',
                            onClick: () {
                              GlobalVar.track('Click_DOCin_form');
                              Get.back();
                              if (isRestCoop) {
                                GlobalVar.track('Click_DOCin_form_pengajuan');
                                Get.toNamed(RoutePage.reqDocInPage, arguments: [coop])!.then((value) => generateCoopList(false)).then((value) => _refreshCoopList());
                              } else {
                                Get.toNamed(RoutePage.docInPage, arguments: [coop])!.then((value) => generateCoopList(true)).then((value) => _refreshCoopList());
                              }
                            })
                      ] else ...[
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ButtonOutline(
                                controller: GetXCreator.putButtonOutlineController('pulletInCoopNew'),
                                label: 'Pullet In',
                                isHaveIcon: true,
                                imageAsset: 'images/calendar_check_icon.svg',
                                onClick: () {
                                  GlobalVar.track('Click_PulletIn_form');
                                  Get.back();
                                  GlobalVar.track('Click_PulletIn_form_pengajuan');
                                  Get.toNamed(RoutePage.pulletInForm, arguments: [coop])!.then((value) => generateCoopList(false)).then((value) => _refreshCoopList());
                                }))
                      ],
                      const SizedBox(height: 24)
                    ])))));
  }

  bool _isCoopNew(Coop coop) => coop.isNew != null && coop.isNew!;
  bool _isBroiler(Coop coop) => coop.farmCategory == 'BROILER';
  String _getHdpActual(Coop coop) => coop.hdp == null || coop.hdp!.actual == null ? '-' : coop.hdp!.actual!.toStringAsFixed(1);
  String _getHdpStandard(Coop coop) => coop.hdp == null || coop.hdp!.standard == null ? '-' : coop.hdp!.standard!.toStringAsFixed(1);
  String _getBwActual(Coop coop) => coop.bw == null || coop.bw!.actual == null ? '-' : coop.bw!.actual!.toStringAsFixed(1);
  String _getBwStandard(Coop coop) => coop.bw == null || coop.bw!.standard == null ? '-' : coop.bw!.standard!.toStringAsFixed(1);
  String _getFeedIntakeActual(Coop coop) => coop.feedIntake == null || coop.feedIntake!.actual == null ? '-' : coop.feedIntake!.actual!.toStringAsFixed(1);
  String _getFeedIntakeStandard(Coop coop) => coop.feedIntake == null || coop.feedIntake!.standard == null ? '-' : coop.feedIntake!.standard!.toStringAsFixed(1);
  String _getIpActual(Coop coop) => coop.ip == null || coop.ip!.actual == null ? '-' : coop.ip!.actual!.toStringAsFixed(1);
  String _getIpStandard(Coop coop) => coop.ip == null || coop.ip!.standard == null ? '-' : coop.ip!.standard!.toStringAsFixed(1);

  Widget createCoopActiveCard(int index) {
    final Coop coop = coopFilteredList[index]!;
    DateTime? startDate;
    if (coop.startDate != null) {
      startDate = Convert.getDatetime(coop.startDate!);
    }

    return GestureDetector(
        onTap: () => actionCoop(coop),
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: GlobalVar.primaryLight),
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      coop.farmCategory != null && coop.farmCategory!.isNotEmpty
                          ? Container(
                              decoration: const BoxDecoration(color: GlobalVar.greenBackground2, borderRadius: BorderRadius.all(Radius.circular(16))),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Wrap(children: [
                                SvgPicture.asset('images/${_isBroiler(coop) ? 'chicken_icon.svg' : 'egg_icon.svg'}'),
                                const SizedBox(width: 8),
                                Text(_isBroiler(coop) ? 'Peternakan Broiler' : 'Peternakan Layer', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                              ]),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Expanded(child: Text(coop.coopName ?? '-', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black), overflow: TextOverflow.clip)),
                        _isCoopNew(coop) ? const SizedBox() : Text('Hari ${coop.day}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                      ]),
                      Text('${coop.coopDistrict ?? '-'}, ${coop.coopCity ?? '-'}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), overflow: TextOverflow.clip),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        startDate != null
                            ? Text(
                                "${coop.farmCategory == null || coop.farmCategory!.isEmpty ? '- ' : _isBroiler(coop) ? 'DOC-In' : 'Pullet in'} ${Convert.getYear(startDate)}-${Convert.getMonthNumber(startDate)}-${Convert.getDay(startDate)}",
                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                            : const SizedBox(),
                        coop.week != null ? Text('${coop.week} Minggu', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)) : const SizedBox()
                      ]),
                      const SizedBox(height: 16),
                      _isCoopNew(coop)
                          ? Container(
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: GlobalVar.greenBackground),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(GlobalVar.NEW, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.green)),
                              ),
                            )
                          : const SizedBox(),
                      _isCoopNew(coop) || coop.farmCategory == null || coop.farmCategory!.isEmpty
                          ? const SizedBox()
                          : Container(
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.grayBackground)), color: Colors.white),
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Row(children: [
                                      SvgPicture.asset('images/${_isBroiler(coop) ? 'bw_icon.svg' : 'hdp_icon.svg'}', width: 24, height: 24),
                                      const SizedBox(width: 8),
                                      Text(_isBroiler(coop) ? 'BW/Standar' : 'HDP/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]),
                                    coop.bw == null
                                        ? const SizedBox()
                                        : Row(children: [
                                            Text(_isBroiler(coop) ? _getBwActual(coop) : _getHdpActual(coop),
                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: coop.bw!.actual! > coop.bw!.standard! ? GlobalVar.green : GlobalVar.red)),
                                            Text(' / ${_isBroiler(coop) ? _getBwStandard(coop) : _getHdpStandard(coop)}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                          ])
                                  ]))),
                      SizedBox(height: _isCoopNew(coop) ? 0 : 8),
                      _isCoopNew(coop) || coop.farmCategory == null || coop.farmCategory!.isEmpty
                          ? const SizedBox()
                          : Container(
                              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(width: 1, color: GlobalVar.grayBackground)), color: Colors.white),
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Row(children: [
                                      SvgPicture.asset('images/${_isBroiler(coop) ? 'ip_icon.svg' : 'feed_intake_icon.svg'}', width: 24, height: 24),
                                      const SizedBox(width: 8),
                                      Text(_isBroiler(coop) ? 'IP/Standar' : 'Feed Intake/Standar', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                    ]),
                                    coop.ip == null
                                        ? const SizedBox()
                                        : Row(children: [
                                            Text(_isBroiler(coop) ? _getIpActual(coop) : _getFeedIntakeActual(coop),
                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: coop.ip!.actual! > coop.ip!.standard! ? GlobalVar.green : GlobalVar.red)),
                                            Text(' / ${_isBroiler(coop) ? _getIpStandard(coop) : _getFeedIntakeStandard(coop)}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                          ])
                                  ]))),
                      coop.isActionNeeded != null && coop.isActionNeeded!
                          ? ButtonFill(
                              controller: GetXCreator.putButtonFillController('btnCoopActionNeeded${coop.id}'),
                              label: 'Cek Laporan Harian',
                              onClick: () => Get.toNamed(RoutePage.dailyReport, arguments: [coop, coop.farmCategory == 'LAYER' ? true : false])!.then((value) => _refreshCoopList()))
                          : const SizedBox()
                    ])))));
  }

  Widget createCoopIdleCard(int index) {
    final Coop coop = coopFilteredList[index]!;
    return GestureDetector(
      onTap: () => _isBroiler(coop) ? actionCoop(coop) : {},
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: GlobalVar.primaryLight),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              coop.farmCategory != null && coop.farmCategory!.isNotEmpty
                  ? Container(
                      decoration: const BoxDecoration(color: GlobalVar.greenBackground2, borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Wrap(
                        children: [
                          SvgPicture.asset('images/${_isBroiler(coop) ? 'chicken_icon.svg' : 'egg_icon.svg'}'),
                          const SizedBox(width: 8),
                          Text(_isBroiler(coop) ? 'Peternakan Broiler' : 'Peternakan Layer', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 12),
              Text(coop.coopName!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
              Text('${coop.coopDistrict!}, ${coop.coopCity!}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: coop.statusText == GlobalVar.SUBMISSION_STATUS || coop.statusText == GlobalVar.OVK_REJECTED || coop.statusText == GlobalVar.REJECTED
                        ? GlobalVar.redBackground
                        : coop.statusText == GlobalVar.SUBMITTED_STATUS || coop.statusText == GlobalVar.SUBMITTED_OVK || coop.statusText == GlobalVar.SUBMITTED_DOC_IN || coop.statusText == GlobalVar.NEED_APPROVED
                            ? GlobalVar.primaryLight2
                            : coop.statusText == GlobalVar.APPROVED || coop.statusText == GlobalVar.NEW
                                ? GlobalVar.greenBackground
                                : coop.statusText == GlobalVar.PROSESSING
                                    ? GlobalVar.primaryLight3
                                    : Colors.transparent),
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: coop.statusText == GlobalVar.SUBMISSION_STATUS || coop.statusText == GlobalVar.OVK_REJECTED || coop.statusText == GlobalVar.REJECTED
                        ? Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.red))
                        : coop.statusText == GlobalVar.SUBMITTED_STATUS || coop.statusText == GlobalVar.SUBMITTED_OVK || coop.statusText == GlobalVar.SUBMITTED_DOC_IN || coop.statusText == GlobalVar.NEED_APPROVED
                            ? Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange))
                            : coop.statusText == GlobalVar.APPROVED || coop.statusText == GlobalVar.NEW
                                ? Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.green))
                                : coop.statusText == GlobalVar.PROSESSING
                                    ? Text(coop.statusText!, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.yellow))
                                    : const SizedBox()),
              )
            ]),
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
  void dependencies() => Get.lazyPut<CoopController>(() => CoopController(context: context));
}
