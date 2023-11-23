
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
///@create date 16/08/23

class ResetTimeController extends GetxController {
    BuildContext context;

    ResetTimeController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    late Device device;
    late ControllerData controllerData;
    var isLoading = false.obs;
    var isEdit = false.obs;

    late ButtonFill bfYesResetTime;
    late ButtonOutline boNoResetTime;
    late ButtonFill bfSaveResetTime;
    late ButtonFill bfEditResetTime;
    late DateTimeField dtfLampReset = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController(
            "dtfLampReset"),
        label: "Waktu",
        hint: "00:00:00",
        flag: DateTimeField.TIME_FLAG,
        alertText: "Durasi Nyala harus di isi", onDateTimeSelected: (DateTime time, dateField) {
        dtfLampReset.controller.setTextSelected("${time.hour}:${time.minute}:${time.second}");
    });

    @override
    void onInit() {
        super.onInit();
        // isLoading.value = true;
        device = Get.arguments[0];
        controllerData = Get.arguments[1];
        boNoResetTime = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoResetTime"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesResetTime = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesResetTime"),
            label: "Ya",
            onClick: () {
                resetTime();
            },
        );

        bfSaveResetTime = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfSaveResetTime"),
            label: "Simpan",
            onClick: () {
            },
        );
        bfEditResetTime = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfEditResetTime"),
            label: "Edit",
            onClick: () {
            },
        );
        loadData(controllerData);

    }



    /// The function `resetTime()` sends a request to reset the time on a device and
    /// handles the response accordingly.
    void resetTime() {
        Get.back();
        List ret = validationEdit();
        if (ret[0]) {
            isLoading.value = true;
            try {
                DeviceSetting payload = generatePayloadResetTime();
                Service.push(
                    service: ListApi.setController,
                    context: context,
                    body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId,
                        ListApi.pathSetController('v2/b2b/iot-devices/smart-controller/coop/', "alarm",device.deviceSummary!.coopCodeId!),
                        Mapper.asJsonString(payload)],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert","Terjadi kesalahan internal", snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    ),
                );
            } catch (e,st) {
                Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),
                    backgroundColor: const Color(0xFFFF0000),
                    colorText: Colors.white);
            }

        }
    }

    /// The function `validationEdit()` checks if a text field is empty and returns
    /// a list indicating whether the validation passed or failed.
    ///
    /// Returns:
    ///   The function `validationEdit()` is returning a list with two elements. The
    /// first element is a boolean value (`true` or `false`) and the second element
    /// is an empty string (`""`).
    List validationEdit() {
        List ret = [true, ""];

        if (dtfLampReset.getLastTimeSelectedText().isEmpty) {
            dtfLampReset.controller.showAlert();
            Scrollable.ensureVisible(
                dtfLampReset.controller.formKey.currentContext!);
            return ret = [false, ""];
        }

        return ret;
    }

    /// The function "generatePayloadResetTime" returns a new instance of the
    /// "DeviceSetting" class.
    ///
    /// Returns:
    ///   An instance of the DeviceSetting class.
    DeviceSetting generatePayloadResetTime(){
        return DeviceSetting();
    }

    /// The function loads data into a controller and enables or disables certain
    /// buttons and fields based on a condition.
    ///
    /// Args:
    ///   controllerData (ControllerData): An object of type ControllerData, which
    /// contains information about the controller's online time.
    void loadData(ControllerData controllerData){
        dtfLampReset.controller.setTextSelected("${controllerData.onlineTime}");
        if(isEdit.isTrue){
            dtfLampReset.controller.enable();
        }else{
            dtfLampReset.controller.disable();
        }
        isLoading.value = false;
        bfSaveResetTime.controller.disable();
        bfEditResetTime.controller.disable();
        dtfLampReset.controller.disable();
    }



}

class ResetTimeBindings extends Bindings {
    BuildContext context;

    ResetTimeBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => ResetTimeController(context: context));
    }
}

