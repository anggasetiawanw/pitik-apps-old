
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_controller_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/detail_controller_response.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/07/23
 */

class DetailSmartControllerController extends GetxController {
    BuildContext context;
    DetailSmartControllerController({required this.context});
    ScrollController scrollController = ScrollController();
    var isLoadMore = false.obs;
    var pageSmartMonitor = 1.obs;
    var pageSmartController = 1.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    var deviceUpdatedName = "".obs;
    late DateTime timeStart;

    late Coop coop;
    late Device device;
    DeviceController? deviceController;

    ScrollController scrollMonitorController = ScrollController();

    scrollPurchaseListener() async {
        scrollMonitorController.addListener(() {
            if (scrollMonitorController.position.maxScrollExtent == scrollMonitorController.position.pixels) {
                isLoadMore.value = true;
                pageSmartMonitor++;
            }
        });
    }



    var isLoading = false.obs;
    late EditField efBuildingName = EditField(
        controller: GetXCreator.putEditFieldController(
            "efBuildingName"),
        label: "Kandang",
        hint: "Ketik Disini",
        alertText: "Nama Kandang",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 20,
        onTyping: (value, control) {}
    );
    late SpinnerField spBuildingType = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("spBuildingType"),
        label: "Jenis Kandang",
        hint: "Pilih Salah Satu",
        alertText: "Jenis Kandang harus dipilih!",
        items: {"Open House": false, "Semi House": false, "Close House": false},
        onSpinnerSelected: (value) {
        }
    );

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        device = Get.arguments[1];
        isLoading.value = true;
        getDetailSmartController();
    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }

    void getDetailSmartController(){
        timeStart = DateTime.now();
        Service.push(
            service: ListApi.getDetailSmartController,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathdetailSmartController(device.deviceSummary!.coopCodeId!, device.deviceSummary!.deviceId!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    if((body as DetailControllerResponse).data != null) {
                        deviceController = (body).data;
                    }
                    DateTime timeEnd = DateTime.now();
                    GlobalVar.sendRenderTimeMixpanel("Open_smart_controller_page", timeStart, timeEnd);
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet){
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        duration: Duration(seconds: 5),
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;

                }, onTokenInvalid: GlobalVar.invalidResponse())
        );
    }


}

class DetailSmartControllerBindings extends Bindings {
    BuildContext context;

    DetailSmartControllerBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => DetailSmartControllerController(context: context));
    }
}

