
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
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/room_detail_response.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 14/07/23
 */

class DashboardDeviceController extends GetxController {
    BuildContext context;
    DashboardDeviceController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<Device>> smartMonitordevices = Rx<List<Device>>([]);
    Rx<List<Device>> smartControllerdevices = Rx<List<Device>>([]);
    Rx<List<Device>> smartCameradevices = Rx<List<Device>>([]);
    Rx<List<Device>> smartScaledevices = Rx<List<Device>>([]);

    var isLoadMore = false.obs;
    var pageSmartMonitor = 1.obs;
    var pageSmartController = 1.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    late DateTime timeStart;

    late Coop coop;
    late Coop coopDetail;

    ScrollController scrollMonitorController = ScrollController();
    ScrollController scrollSmartConController = ScrollController();
    ScrollController scrollCameraController = ScrollController();
    ScrollController scrollScaleController = ScrollController();

    var isLoading = false.obs;

    late EditField efBuildingName = EditField(
        controller: GetXCreator.putEditFieldController("efBuildingName"),
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
        GlobalVar.track("Open_lantai_page");
        coop = Get.arguments;
        isLoading.value = true;
        getDetailRoom();
    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
    }

    /// The function `getDetailRoom` retrieves the details of a room and populates
    /// different lists based on the device type.
    void getDetailRoom(){
        timeStart = DateTime.now();
        Service.push(
            service: ListApi.getDetailRoom,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!, ListApi.pathDetailRoom(coop.id!, coop.room!.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    coopDetail = (body as RoomDetailResponse).data!;
                    if (coopDetail.room!.devices.isNotEmpty){
                        for (var result in body.data!.room!.devices) {
                            if(result!.deviceType == "SMART_MONITORING") {
                                smartMonitordevices.value.add(result);
                            }
                            if(result.deviceType == "SMART_CONTROLLER") {
                                smartControllerdevices.value.add(result);
                            }
                            if(result.deviceType == "SMART_CAMERA") {
                                smartCameradevices.value.add(result);
                            }
                            if (result.deviceType == "SMART_SCALE") {
                                smartScaledevices.value.add(result);
                            }
                        }
                    }
                    DateTime timeEnd = DateTime.now();
                    GlobalVar.sendRenderTimeMixpanel("Open_dashboard_device", timeStart, timeEnd);
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
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

class DashboardDeviceBindings extends Bindings {
    BuildContext context;

    DashboardDeviceBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => DashboardDeviceController(context: context));
    }
}

