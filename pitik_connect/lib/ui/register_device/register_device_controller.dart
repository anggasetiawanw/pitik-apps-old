
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/card_camera/card_camera.dart';
import 'package:components/card_camera/card_camera_controller.dart';
import 'package:components/card_sensor/card_sensor.dart';
import 'package:components/card_sensor/card_sensor_controller.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/edit_field_qr/edit_field_qrcode.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
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
import 'package:model/sensor_model.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 07/07/23
 */

class RegisterDeviceController extends GetxController {
    BuildContext context;
    RegisterDeviceController({required this.context});

    static const String SMART_MONITORING = "Smart Monitoring";
    static const String SMART_CONTROLLER = "Smart Controller";
    static const String SMART_CAMERA = "Smart Camera";
    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    var isFirstLoad = true.obs;
    Rx<String> deviceType = "".obs;
    Rx<String> prefixMacAddress = "".obs;
    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

    late ButtonFill bfYesRegDevice;
    late ButtonOutline boNoRegDevice;
    late EditField efDeviceType = EditField(
        controller: GetXCreator.putEditFieldController(
            "efDeviceType"),
        label: "Jenis Alat",
        hint: "Ketik disini",
        alertText: "Jenis Alat harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 100,
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
        textPrefix: deviceType.value == SMART_MONITORING ? "SMHUB_" : deviceType.value == SMART_CONTROLLER ? "SCCON_" : "SROPI_",
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

    late CardSensor cardSensor ;
    late CardCamera cardCamera ;
    late Coop coop;

    @override
    void onInit() {
        super.onInit();
        // isLoading.value = true;
        timeStart = DateTime.now();
        coop = Get.arguments[0];
        deviceType.value = Get.arguments[1];
        prefixMacAddress.value = deviceType.value == SMART_MONITORING ? "SMHUB_" : deviceType.value == SMART_CONTROLLER? "SCCON_" : "SROPI_";
        efDeviceType.setInput(deviceType.value);
        efCoop.setInput(coop.coopName!);
        efFloor.setInput(coop.room!.name!);
        efDeviceType.controller.disable();
        efCoop.controller.disable();
        efFloor.controller.disable();
        cardSensor = CardSensor(controller: GetXCreator.putCardSensorController("cardSensorController",context));
        cardCamera = CardCamera(controller: GetXCreator.putCardCameraController("cardCameraController",context));
        boNoRegDevice = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoRegDevice"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );

        /// The above code is checking the value of the variable `deviceType`. If
        /// the value is equal to `SMART_MONITORING`, it calls the `track` function
        /// with the argument "Open_form_smart_monitoring_page". If the value is
        /// equal to `SMART_CONTROLLER`, it calls the `track` function with the
        /// argument "Open_form_smart_controller_page". Otherwise, it calls the
        /// `track` function with the argument "Open_form_smart_camera_page".
        deviceType.value == SMART_MONITORING ? GlobalVar.track("Open_form_smart_monitoring_page") : deviceType.value == SMART_CONTROLLER ? GlobalVar.track("Open_form_smart_controller_page") :  GlobalVar.track("Open_form_smart_camera_page") ;
        DateTime timeEnd = DateTime.now();
        GlobalVar.sendRenderTimeMixpanel("Open_form_${deviceType.value == SMART_MONITORING ? "smart_monitoring" : deviceType.value == SMART_CONTROLLER ? "smart_controller" : "smart_camera"}_page", timeStart, timeEnd);
    }

    @override
    void onClose() {
        super.onClose();
    }

    @override
    void onReady() {
        super.onReady();
        Get.find<CardSensorController>(tag: "cardSensorController").numberList.listen((p0) {
        });
        Get.find<CardCameraController>(tag: "cardCameraController").numberList.listen((p0) {
        });
        if(deviceType.value == SMART_MONITORING) {
            cardSensor.controller.visibleCard();
            cardSensor.controller.setPrefixDevice("ATC_");
        }else if(deviceType.value == SMART_CAMERA){
            cardCamera.controller.visibleCard();
            cardCamera.controller.setPrefixDevice("BRD_");
        }
        bfYesRegDevice = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesRegDevice"),
            label: "Ya",
            onClick: () {
                deviceType.value == SMART_MONITORING ? GlobalVar.track("Click_button_simpan") : deviceType.value == SMART_CONTROLLER ? GlobalVar.track("Click_button_simpan") :  GlobalVar.track("Click_button_simpan") ;
                registerDevice();
            },
        );
        efDeviceType.setInput(Get.arguments[1]);
        showInformation();
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
                                                GlobalVar.track("Click_button_ok_popup"),
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

    /// The function `registerDevice()` is used to register a device and handle the
    /// response accordingly.
    void registerDevice() {
        Get.back();
        List ret = validation();
        if (ret[0]) {
            isLoading.value = true;
            try {
                Device payload = generatePayloadRegisterDevice();
                Service.push(
                    service: ListApi.registerDevice,
                    context: context,
                    body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId, Mapper.asJsonString(payload),
                    ListApi.pathRegisterDevice(deviceType.value == SMART_MONITORING? "smart-monitoring" : deviceType.value == SMART_CAMERA? "smart-camera" :"smart-controller")],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
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

    List validation() {
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

    Device generatePayloadRegisterDevice(){
        List<Sensor?> sensors = [];
        if(deviceType == SMART_MONITORING){
            for (int i = 0; i < cardSensor.controller.itemCount.value; i++) {
                int whichItem = cardSensor.controller.index.value[i];
                sensors.add(Sensor(sensorCode :"${cardSensor.controller.efSensorId.value[whichItem].getTextPrefix()}${cardSensor.controller.efSensorId.value[whichItem].getInput()}", sensorType: "XIAOMI_SENSOR"));
            }
        }else if(deviceType == SMART_CAMERA){
            for (int i = 0; i < cardCamera.controller.itemCount.value; i++) {
                int whichItem = cardCamera.controller.index.value[i];
                sensors.add(Sensor(sensorCode :"${cardCamera.controller.efCameraId.value[whichItem].getTextPrefix()}${cardCamera.controller.efCameraId.value[whichItem].getInput()}"));
            }
        }

        return Device(deviceType: deviceType == SMART_MONITORING ? "SMART_MONITORING" : deviceType == SMART_CONTROLLER ? "SMART_CONTROLLER" : "SMART_CAMERA",coopId: coop.coopId, roomId: coop.room!.id,mac: efMacAddress.getInput().replaceAll(prefixMacAddress.value, ""), sensors: sensors);
    }

}

class RegisterDeviceBindings extends Bindings {
    BuildContext context;
    RegisterDeviceBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => RegisterDeviceController(context: context));
    }


}