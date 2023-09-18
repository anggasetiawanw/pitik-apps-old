
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/card_camera/card_camera.dart';
import 'package:components/card_sensor/card_sensor.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/edit_field_qr/edit_field_qrcode.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/device_detail_response.dart';
import 'package:model/sensor_model.dart';

import '../register_device/register_device_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 10/08/23
 */

class ModifyDeviceController extends GetxController {
    BuildContext context;
    ModifyDeviceController({required this.context});

    ScrollController scrollController = ScrollController();
    static const String EDIT_ACTION = "edit";
    static const String RENAME_ACTION = "rename";

    var isLoading = false.obs;
    var isFirstLoad = true.obs;
    late DateTime timeStart;

    Rx<String> deviceType = "".obs;
    Rx<String> prefixMacAddress = "".obs;
    Rx<List<Sensor>> sensors = Rx<List<Sensor>>([]);
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    late ButtonFill bfYesModify;
    late ButtonOutline boNoModify;
    late EditField efDeviceType = EditField(
        controller: GetXCreator.putEditFieldController(
            "efDeviceType"),
        label: "Jenis Alat",
        hint: "Ketik disini",
        alertText: "Jenis Alat harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 50,
        onTyping: (value, control) {
        }
    );

    late EditField efDeviceName = EditField(
        controller: GetXCreator.putEditFieldController(
            "efDeviceName"),
        label: "Nama Alat",
        hint: "Ketik disini",
        alertText: "Nama Alat harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 50,
        onTyping: (value, control) {
        }
    );

    late EditField efCoop = EditField(
        controller: GetXCreator.putEditFieldController(
            "efCoop"),
        label: "Kandang",
        hint: "Ketik disini",
        alertText: "Kandang harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 100,
        onTyping: (value, control) {
        }
    );

    late EditField efFloor = EditField(
        controller: GetXCreator.putEditFieldController(
            "efFloor"),
        label: "Lantai",
        hint: "Ketik disini",
        alertText: "Lantai harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 100,
        onTyping: (value, control) {
        }
    );

    late EditFieldQR efMacAddress = EditFieldQR(
        controller: GetXCreator.putEditFieldQRController(
            "efMacAddress"),
        label: "Kode Alat",
        hint: "AA:AA:AA:AA:AA:AA:AA:AA",
        alertText: "Kode Alat Tidak Sesuai",
        textUnit: "",
        textPrefix: deviceType.value == RegisterDeviceController.SMART_MONITORING ? "SMHUB_" : deviceType.value == RegisterDeviceController.SMART_CONTROLLER ? "SCCON_" : "SROPI_",
        isMacAddres: true,
        inputType: TextInputType.text,
        maxInput: 23,
        onTyping: (value, control) {
            // if(value.isNotEmpty && value.length == 23) {
            //     if (prefixMacAddress.value != "" &&
            //         !value.contains(prefixMacAddress.value!)) {
            //         efMacAddress.controller.showAlert();
            //     }
            // }
        },
    );

    late SpinnerField spDeviceStatus = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("spDeviceStatus"),
        label: "Status",
        hint: "Pilih Salah Satu",
        alertText: "Status harus dipilih !",
        items: {"Aktif": false, "Non Aktif": false},
        onSpinnerSelected: (value) {
        }
    );

    late CardSensor cardSensor ;
    late CardCamera cardCamera ;
    late Coop coop;
    late Device device;
    late String action="";

    @override
    void onInit() {
        super.onInit();
        timeStart = DateTime.now();
        isLoading.value = true;
        coop = Get.arguments[0];
        device = Get.arguments[1];
        action = Get.arguments[2];
        efDeviceName.controller.invisibleField();
        deviceType.value = device.deviceType == "SMART_MONITORING"
            ? "Smart Monitoring"
            : device.deviceType == "SMART_CONTROLLER"
            ? "Smart Controller"
            : "Smart Camera";
        prefixMacAddress.value =
        deviceType.value == RegisterDeviceController.SMART_MONITORING ? "SMHUB_" : deviceType
            .value == RegisterDeviceController.SMART_CONTROLLER ? "SCCON_" : "SROPI_";
        efDeviceType.setInput(deviceType.value);
        efCoop.setInput(coop.coopName!);
        efFloor.setInput(coop.room!.name!);
        efDeviceType.controller.disable();
        efMacAddress.setInput(
            device.mac!.replaceAll(prefixMacAddress.value, ""));
        efMacAddress.controller.disable();

        efCoop.controller.disable();
        efFloor.controller.disable();
        cardSensor = CardSensor(
            controller: GetXCreator.putCardSensorController(
                "cardSensorControllerModify", context));
        cardCamera = CardCamera(
            controller: GetXCreator.putCardCameraController(
                "cardCameraControllerModify", context));
        boNoModify = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController(
                "boNoModify"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        getDetailSmartMonitor();

        if(deviceType.value == RegisterDeviceController.SMART_MONITORING){
            action == EDIT_ACTION ? GlobalVar.track("Open_edit_form_monitoring_page") : GlobalVar.track("Open_edit_form_rename");
        }else if(deviceType.value == RegisterDeviceController.SMART_CAMERA){
            action == EDIT_ACTION ? GlobalVar.track("Open_edit_form_camera_page") : GlobalVar.track("Open_edit_form_rename_page");
        }
    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
        cardSensor = CardSensor(
            controller: GetXCreator.putCardSensorController(
                "cardSensorControllerModify", context));
        if (deviceType.value == RegisterDeviceController.SMART_MONITORING) {
            cardSensor.controller.visibleCard();
            cardSensor.controller.setPrefixDevice("ATC_");
        } else if (deviceType.value == RegisterDeviceController.SMART_CAMERA) {
            cardCamera.controller.visibleCard();
            cardCamera.controller.setPrefixDevice("BRD");
        }
        bfYesModify = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesModify"),
            label: "Ya",
            onClick: () {
                modifyDevice();
            },
        );
    }

    void loadData(Device device){
        if(action == EDIT_ACTION) {
            spDeviceStatus.controller.setTextSelected(device.status! == "active" ? "Aktif" :"Non-Aktif");
            if (device.sensors!.isNotEmpty) {
                for (var result in device.sensors!) {
                    sensors.value.add(result as Sensor);
                }
                if(deviceType == RegisterDeviceController.SMART_MONITORING) {
                    for (int i = 0; i < sensors.value.length - 1; i++) {
                        cardSensor.controller.addCard();
                    }
                    for (int i = 0; i < sensors.value.length; i++) {
                        cardSensor.controller.efSensorId.value[i].setInput(
                            sensors.value[i].sensorCode!.replaceAll(
                                "ATC_", ""));
                    }
                    DateTime timeEnd = DateTime.now();
                    GlobalVar.sendRenderTimeMixpanel("open_menu_edit_smart_monitoring", timeStart, timeEnd);
                } else if(deviceType== RegisterDeviceController.SMART_CAMERA) {
                    for (int i = 0; i < sensors.value.length - 1; i++) {
                        cardCamera.controller.addCard();
                    }
                    for (int i = 0; i < sensors.value.length; i++) {
                        cardCamera.controller.efCameraId.value[i].setInput(
                            sensors.value[i].sensorCode!.replaceAll(
                                "BRD", ""));
                    }
                    DateTime timeEnd = DateTime.now();
                    GlobalVar.sendRenderTimeMixpanel("open_menu_edit_smart_camera", timeStart, timeEnd);
                }else{
                    DateTime timeEnd = DateTime.now();
                    GlobalVar.sendRenderTimeMixpanel("open_menu_edit_smart_controller", timeStart, timeEnd);
                }
            }
            efDeviceName.controller.invisibleField();
        }else{
            efDeviceName.setInput(device.deviceName!);
            efDeviceName.controller.visibleField();
            efDeviceType.controller.invisibleField();
            efCoop.controller.invisibleField();
            efFloor.controller.invisibleField();
            efMacAddress.controller.invisibleField();
            spDeviceStatus.controller.invisibleSpinner();
            cardSensor.controller.invisibleCard();
        }
    }

    void showInformation(){
        Get.dialog(Center(
            child: Container(
                width: 300,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Row(
                            children: [
                                SvgPicture.asset(
                                    "images/information_blue_icon.svg",
                                    height: 24,
                                    width: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Informasi",
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, decoration: TextDecoration.none),
                                ),
                            ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            "Kamu bisa mendaftarkan alat dengan dua cara mengisi manual dan scan QRCODE yang tertera pada masing-masing alat." ,
                            style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                        ),
                        const SizedBox(height: 16),
                        Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                        height: 32,
                                        width: 100,
                                        color: Colors.transparent,
                                    ),
                                    Container(
                                        width: 100,
                                        child: ButtonFill(
                                            controller:
                                            GetXCreator.putButtonFillController("Dialog"),
                                            label: "OK",
                                            onClick: () => {
                                                isFirstLoad.value = false,
                                                Get.back(),
                                            }
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        ));
    }

    /// The function `getDetailSmartMonitor` makes an API call to retrieve detailed
    /// information about a smart monitoring device and handles the response
    /// accordingly.
    void getDetailSmartMonitor(){
        Service.push(
            service: ListApi.getDetailSmartMonitoring,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathDetailSmartMonitoring(device.deviceId!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    loadData((body as DeviceDetailResponse).data!);
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

    /// The `modifyDevice` function is responsible for modifying a device and
    /// handling the response.
    void modifyDevice() {
        Get.back();
        List ret = action == EDIT_ACTION ? validationEdit() : validationRename();
        if (ret[0]) {
            isLoading.value = true;
            try {
                Device payload = action == EDIT_ACTION ? generatePayloadModifyDevice() : generatePayloadRenameDevice();
                Service.push(
                    service: ListApi.modifyDevice,
                    context: context,
                    body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId,
                        ListApi.pathModifyDevice(deviceType == RegisterDeviceController.SMART_MONITORING ? "smart-monitoring" : deviceType == RegisterDeviceController.SMART_CAMERA ? "smart-camera" : "smart-controller",
                            device.deviceId!, action),
                        Mapper.asJsonString(payload)],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if(action == RENAME_ACTION){
                                Get.back(result: [
                                    {"backValue": (body as DeviceDetailResponse).data!.deviceName!}
                                ]);
                            }else {
                                Get.back();
                            }
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert","Terjadi kesalahan internal", snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onTokenInvalid: GlobalVar.invalidResponse()
                    ),
                );
            } catch (e,st) {
                Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 5),
                    backgroundColor: Color(0xFFFF0000),
                    colorText: Colors.white);
            }

        }
    }

    List validationEdit() {
        List ret = [true, ""];

        if (efMacAddress
            .getInput()
            .isEmpty) {
            efMacAddress.controller.showAlert();
            Scrollable.ensureVisible(
                efMacAddress.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if(deviceType == RegisterDeviceController.SMART_MONITORING) {
            ret = cardSensor.controller.validation();
        }else if(deviceType == RegisterDeviceController.SMART_CAMERA){
            ret = cardCamera.controller.validation();
        }

        return ret;
    }

    List validationRename() {
        List ret = [true, ""];

        if (efDeviceName
            .getInput()
            .isEmpty) {
            efDeviceName.controller.showAlert();
            Scrollable.ensureVisible(
                efDeviceName.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        return ret;
    }

    Device generatePayloadModifyDevice(){
        List<Sensor?> sensors = [];
        if(deviceType == RegisterDeviceController.SMART_MONITORING){
            for (int i = 0; i < cardSensor.controller.itemCount.value; i++) {
                int whichItem = cardSensor.controller.index.value[i];
                sensors.add(Sensor(
                    sensorCode: "${cardSensor.controller.efSensorId
                        .value[whichItem].getTextPrefix()}${cardSensor
                        .controller.efSensorId.value[whichItem].getInput()}",
                    sensorType: "XIAOMI_SENSOR"));
            }
        }else if(deviceType == RegisterDeviceController.SMART_CAMERA){
            for (int i = 0; i < cardCamera.controller.itemCount.value; i++) {
                int whichItem = cardCamera.controller.index.value[i];
                sensors.add(Sensor(
                    sensorCode: "${cardCamera.controller.efCameraId
                        .value[whichItem].getTextPrefix()}${cardCamera
                        .controller.efCameraId.value[whichItem].getInput()}"));
            }
        }
        return Device(status: spDeviceStatus.controller.textSelected.value == "Aktif" ? "active" : "inactive", sensors: sensors);
    }

    Device generatePayloadRenameDevice(){
        return Device(deviceName: efDeviceName.getInput());
    }

}

class ModifyDeviceBindings extends Bindings {
    BuildContext context;
    ModifyDeviceBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => ModifyDeviceController(context: context));
    }


}