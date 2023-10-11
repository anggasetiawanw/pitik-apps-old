
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_setting_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/fan_list_response.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/08/23

class DashboardLampController extends GetxController {
    BuildContext context;
    DashboardLampController({required this.context});
    var isLoading = false.obs;
    Rx<List<DeviceSetting>> lamps = Rx<List<DeviceSetting>>([]);
    late Device device;
    late ControllerData controllerData;

    late ButtonOutline boAddDevice = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("boAddDevice"),
        label: "Tambah Alat", onClick: () {
        Get.toNamed(RoutePage.registerDevicePage);
    },
    );

    late ButtonOutline boOrderDevice = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("boPesanAlat"),
        label: "Pesan Alat", onClick: () {

    },
    );

    late ButtonFill bfAddCoop = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfAddCoop"),
        label: "Buat Kandang", onClick: () {
        Get.toNamed(RoutePage.createCoopPage);
    },
    );

    @override
    void onInit() {
        super.onInit();
        device = Get.arguments[0];
        controllerData = Get.arguments[1];
        isLoading.value = true;
        getDataLamps();
    }

    /// The function `getDataCoops` retrieves data from an API and updates the
    /// `coops` list, `farm` variable, and `isLoading` flag based on the response.
    void getDataLamps(){
        Service.push(
            service: ListApi.getFanData,
            context: context,
            body: [GlobalVar.auth!.token!, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathDeviceData("lamp",device.deviceSummary!.coopCodeId!, device.deviceSummary!.deviceId!)],
            listener: ResponseListener(onResponseDone: (code, message, body, id, packet){
                if ((body as FanListResponse).data!.isNotEmpty){
                    for (var result in (body).data!){
                        lamps.value.add(result as DeviceSetting);
                    }
                }
                isLoading.value = false;
            }, onResponseFail: (code, message, body, id, packet){
                isLoading.value = false;
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
            }, onResponseError: (exception, stacktrace, id, packet){
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );

            },  onTokenInvalid: () => GlobalVar.invalidResponse()));
    }


}
class LampDashboardBindings extends Bindings {
    BuildContext context;
    LampDashboardBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DashboardLampController(context: context));
    }
}