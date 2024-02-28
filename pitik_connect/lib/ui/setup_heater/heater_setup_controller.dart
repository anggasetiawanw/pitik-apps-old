import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/library/model_library.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/device_setting_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 28/07/23

class HeaterSetupController extends GetxController {
  BuildContext context;

  HeaterSetupController({required this.context});

  ScrollController scrollController = ScrollController();
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  var isLoading = false.obs;
  var isEdit = false.obs;
  late Device device;
  late ControllerData controllerData;
  late ButtonFill bfYesSetHeater;
  late ButtonOutline boNoSetHeater;
  late EditField efDiffTempHeater = EditField(
      controller: GetXCreator.putEditFieldController("efDiffTempHeater"),
      label: "Perbedaan Suhu",
      hint: "Ketik disini",
      alertText: "Perbedaan Suhu harus di isi",
      textUnit: "°C",
      inputType: TextInputType.number,
      maxInput: 4,
      onTyping: (value, control) {});

  @override
  void onInit() {
    super.onInit();
    device = Get.arguments[0];
    controllerData = Get.arguments[1];
    loadPage();
    boNoSetHeater = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("boNoSetHeater"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );
    bfYesSetHeater = ButtonFill(
      controller: GetXCreator.putButtonFillController("bfYesSetHeater"),
      label: "Ya",
      onClick: () {
        settingHeater();
      },
    );
  }

  /// The function `settingHeater()` is responsible for setting up the heater
  /// device and handling the response from the server.
  void settingHeater() {
    Get.back();
    List ret = validationEdit();
    if (ret[0]) {
      isLoading.value = true;
      try {
        DeviceSetting payload = generatePayloadFanSetup();
        Service.push(
          service: ListApi.setController,
          context: context,
          body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId, ListApi.pathSetController('v2/b2b/iot-devices/smart-controller/coop/', "heater", device.deviceSummary!.coopCodeId!), Mapper.asJsonString(payload)],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Get.back();
                isLoading.value = false;
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              },
              onTokenInvalid: () => GlobalVar.invalidResponse()),
        );
      } catch (e, st) {
        Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5), backgroundColor: const Color(0xFFFF0000), colorText: Colors.white);
      }
    }
  }

  void loadPage() {
    if (isEdit.isTrue) {
      efDiffTempHeater.setInput("${controllerData.temperature}");
      efDiffTempHeater.controller.enable();
    } else {
      efDiffTempHeater.setInput("${controllerData.temperature}");
      efDiffTempHeater.controller.disable();
    }
    isLoading.value = false;
  }

  /// The `validationEdit` function checks if the `efDiffTempHeater` input is
  /// empty and returns a list indicating whether the validation passed or failed.
  ///
  /// Returns:
  ///   The method `validationEdit()` is returning a list. The list contains two
  /// elements: a boolean value and an empty string.
  List validationEdit() {
    List ret = [true, ""];

    if (efDiffTempHeater.getInput().isEmpty) {
      efDiffTempHeater.controller.showAlert();
      Scrollable.ensureVisible(efDiffTempHeater.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    return ret;
  }

  /// The function generates a payload for fan setup with the device ID and
  /// temperature target.
  ///
  /// Returns:
  ///   a DeviceSetting object.
  DeviceSetting generatePayloadFanSetup() {
    return DeviceSetting(deviceId: controllerData.deviceId, temperatureTarget: efDiffTempHeater.getInputNumber());
  }
}

class HeaterSetupBindings extends Bindings {
  BuildContext context;

  HeaterSetupBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => HeaterSetupController(context: context));
  }
}
