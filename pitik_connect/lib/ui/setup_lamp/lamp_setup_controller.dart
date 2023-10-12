
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_setting_model.dart';
import 'package:model/error/error.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 28/07/23

class LampSetupController extends GetxController {
    BuildContext context;

    LampSetupController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    var isEdit = false.obs;
    late DeviceSetting lamp;
    late Device device;
    late ControllerData controllerData;
    late ButtonFill bfYesSetingLamp;
    late ButtonOutline boNoSettingLamp;
    late ButtonFill bfSaveSetingLamp;
    late ButtonFill bfEditSettingFan;

    late DateTimeField dtfLampOn = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController(
            "dtfLampOn"),
        label: "Waktu Nyala",
        hint: "00:00",
        flag: DateTimeField.TIME_FLAG,
        alertText: "Durasi Nyala harus di isi",
        onDateTimeSelected: (DateTime time, dateField) {
            dtfLampOn.controller.setTextSelected("${time.hour}:${time.minute}");
        },
    );
    late DateTimeField dtfLampOff = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController(
            "dtfLampOff"),
        label: "Waktu Mati",
        hint: "00: 00",
        flag: DateTimeField.TIME_FLAG,
        alertText: "Durasi Mati harus di isi",
        onDateTimeSelected: (DateTime time, dateField) {
            dtfLampOff.controller.setTextSelected(
                "${time.hour}:${time.minute}");
        },
    );

    @override
    void onInit() {
        super.onInit();
        // isLoading.value = true;
        lamp = Get.arguments[0];
        device = Get.arguments[1];
        controllerData = Get.arguments[2];
        if (Get.arguments != null) {
            if (isEdit.isTrue) {
                dtfLampOn.controller.setTextSelected("${lamp.onlineTime}");
                dtfLampOff.controller.setTextSelected("${lamp.offlineTime}");
                dtfLampOn.controller.enable();
                dtfLampOff.controller.enable();
            } else {
                dtfLampOn.controller.setTextSelected("${lamp.onlineTime}");
                dtfLampOff.controller.setTextSelected("${lamp.offlineTime}");
                dtfLampOn.controller.disable();
                dtfLampOff.controller.disable();
            }
        }

        boNoSettingLamp = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController(
                "boNoRegBuilding"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesSetingLamp = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesSetingLamp"),
            label: "Ya",
            onClick: () {
                settingLamp();
            },
        );
    }


    @override
    void onReady() {
        super.onReady();
        bfSaveSetingLamp = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfSaveSetingLamp"),
            label: "Simpan",
            onClick: () {},
        );
        bfEditSettingFan = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfEditSettingFan"),
            label: "Edit",
            onClick: () {},
        );
    }

    /// The function `settingLamp()` is responsible for setting up a lamp device and
    /// handling the response from the server.
    void settingLamp() {
        Get.back();
        List ret = validationEdit();
        if (ret[0]) {
            isLoading.value = true;
            try {
                DeviceSetting payload = generatePayloadLampSetup();
                Service.push(
                    service: ListApi.setController,
                    context: context,
                    body: [
                        GlobalVar.auth!.token,
                        GlobalVar.auth!.id,
                        GlobalVar.xAppId,
                        ListApi.pathSetController(
                            "lamp", device.deviceSummary!.coopCodeId!),
                        Mapper.asJsonString(payload)
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert",
                                (body as ErrorResponse).error!.message!,
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert", "Terjadi kesalahan internal",
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    ),
                );
            } catch (e, st) {
                Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),
                    backgroundColor: const Color(0xFFFF0000),
                    colorText: Colors.white);
            }
        }
    }

    /// The function generates a payload for lamp setup by retrieving the last
    /// selected time for turning the lamp on and off.
    ///
    /// Returns:
    ///   a DeviceSetting object.
    DeviceSetting generatePayloadLampSetup() {
        return DeviceSetting(
            id: lamp.id,
            deviceId: controllerData.deviceId,
            timeOnLight: dtfLampOn.getLastTimeSelectedText(),
            timeOffLight: dtfLampOff.getLastTimeSelectedText()
        );
    }

    /// The function `validationEdit()` checks if two time fields (`dtfLampOff` and
    /// `dtfLampOn`) are empty and returns a list indicating if the validation
    /// passed or failed.
    ///
    /// Returns:
    ///   a list with two elements. The first element is a boolean value indicating
    /// whether the validation was successful or not. The second element is an empty
    /// string.
    List validationEdit() {
        List ret = [true, ""];

        if (dtfLampOff
            .getLastTimeSelectedText()
            .isEmpty) {
            dtfLampOff.controller.showAlert();
            Scrollable.ensureVisible(
                dtfLampOff.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (dtfLampOn
            .getLastTimeSelectedText()
            .isEmpty) {
            dtfLampOn.controller.showAlert();
            Scrollable.ensureVisible(
                dtfLampOn.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        return ret;
    }

    /// The function `loadPage()` sets the text and enables or disables controllers
    /// based on the value of `isEdit` and then sets `isLoading` to false.
    void loadPage() {
        if (isEdit.isTrue) {
            dtfLampOn.controller.setTextSelected("${lamp.onlineTime}");
            dtfLampOff.controller.setTextSelected("${lamp.offlineTime}");
            dtfLampOn.controller.enable();
            dtfLampOff.controller.enable();
        } else {
            dtfLampOn.controller.setTextSelected("${lamp.onlineTime}");
            dtfLampOff.controller.setTextSelected("${lamp.offlineTime}");
            dtfLampOn.controller.disable();
            dtfLampOff.controller.disable();
        }
        isLoading.value = false;
    }
}

class LampSetupBindings extends Bindings {
    BuildContext context;

    LampSetupBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => LampSetupController(context: context));
    }
}

