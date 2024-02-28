import 'dart:async';

import 'package:common_page/smart_controller/setup_fan/fan_setup_activity.dart';
import 'package:components/device_controller_status.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_setting_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/fan_list_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 02/11/2023

class DashboardFanController extends GetxController {
  BuildContext context;
  DashboardFanController({required this.context});
  var isLoading = false.obs;
  Rx<List<DeviceSetting>> fans = Rx<List<DeviceSetting>>([]);

  late Device device;
  late ControllerData controllerData;
  late String basePath;
  late bool isForPitikConnect;

  @override
  void onInit() {
    super.onInit();
    device = Get.arguments[0];
    controllerData = Get.arguments[1];
    basePath = Get.arguments[2];
    isForPitikConnect = Get.arguments[3];

    getDataFans();
  }

  /// The function `getDataFans` makes an API call to retrieve fan data and
  /// handles the response accordingly.
  void getDataFans() => AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          fans.value.clear();

          Service.push(
              apiKey: 'smartControllerApi',
              service: ListApi.getFanData,
              context: context,
              body: [
                'Bearer ${auth.token}',
                auth.id,
                GlobalVar.xAppId ?? '-',
                ListApi.pathDeviceData(basePath, "fan", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', isForPitikConnect ? device.deviceSummary!.deviceId! : device.deviceId ?? '-')
              ],
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    if ((body as FanListResponse).data!.isNotEmpty) {
                      for (var result in (body).data!) {
                        fans.value.add(result as DeviceSetting);
                      }
                    }
                    isLoading.value = false;
                  },
                  onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                      "Pesan",
                      "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  },
                  onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                      "Pesan",
                      "Terjadi kesalahan internal",
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 5),
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });

  Widget createFanList() => Expanded(
      child: RefreshIndicator(
          color: GlobalVar.primaryOrange,
          backgroundColor: Colors.white,
          onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => getDataFans()),
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: fans.value.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Get.to(const FanSetupActivity(), arguments: [fans.value[index], device, controllerData, basePath, isForPitikConnect])!.then((value) => Timer(const Duration(milliseconds: 300), () => getDataFans()));
                    },
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(border: Border.all(width: 1, color: GlobalVar.outlineColor), borderRadius: BorderRadius.circular(8)),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(width: 40, height: 40, decoration: const BoxDecoration(color: GlobalVar.iconHomeBg, borderRadius: BorderRadius.all(Radius.circular(4))), child: Center(child: SvgPicture.asset("images/fan_icon.svg"))),
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(left: 8, right: 8),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      Text(fans.value[index].fanName!, style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.ellipsis)),
                                      const SizedBox(width: 24),
                                      DeviceStatus(status: fans.value[index].status!, activeString: "Aktif", inactiveString: "Non-Aktif")
                                    ]),
                                    const SizedBox(height: 4),
                                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      RichText(
                                          text: TextSpan(
                                              style: const TextStyle(color: Colors.blue), //apply style to all
                                              children: [
                                            TextSpan(text: 'Target ', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                            TextSpan(text: '${fans.value[index].temperatureTarget} °C', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: const TextStyle(color: Colors.blue), //apply style to all
                                              children: [
                                            TextSpan(text: ' - Intermitten ', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                            TextSpan(text: fans.value[index].intermitten == true ? 'Nyala' : 'Mati', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                          ]))
                                    ])
                                  ])))
                        ])));
              })));
}

class FanDashboardBindings extends Bindings {
  BuildContext context;
  FanDashboardBindings({required this.context});

  @override
  void dependencies() => Get.lazyPut(() => DashboardFanController(context: context));
}
