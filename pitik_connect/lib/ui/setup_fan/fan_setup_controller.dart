import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/switch_button/switch_button.dart';
import 'package:components/time_picker/time_picker_field.dart';
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
import 'package:model/response/fan_detail_response.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 28/07/23

class FanSetupController extends GetxController {
  BuildContext context;

  FanSetupController({required this.context});

  ScrollController scrollController = ScrollController();
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  var isLoading = false.obs;
  var isEdit = false.obs;

  late ButtonFill bfYesSettingFan;
  late ButtonOutline boNoSettingFan;
  late ButtonFill bfSaveGrowthDay;
  late ButtonFill bfEditGrowthDay;
  late Device device;
  late DeviceSetting deviceSetting;
  late ControllerData controllerData;
  late EditField efDiffTemp = EditField(
      controller: GetXCreator.putEditFieldController("efDiffTemp"), label: "Perbedaan Suhu", hint: "Ketik disini", alertText: "Perbedaan Suhu harus di isi", textUnit: "°C", inputType: TextInputType.number, maxInput: 4, onTyping: (value, control) {});
  late TimePickerField tmPickerDurationOn = TimePickerField(
    controller: GetXCreator.putTimePickerController("tmPickerDurationOn"),
    label: "Durasi Nyala",
    hint: "00:00:00",
    flag: TimePickerField.TIME_MINUTES_AND_SECONDS,
    alertText: "Durasi Nyala harus di isi",
    onTimeSelected: (String time) {
      tmPickerDurationOn.controller.setTextSelected(time);
    },
  );
  late TimePickerField tmPickerFanOffDurartion = TimePickerField(
    controller: GetXCreator.putTimePickerController("tmPickerFanOffDurartion"),
    label: "Durasi Mati",
    hint: "00:00:00",
    flag: TimePickerField.TIME_MINUTES_AND_SECONDS,
    alertText: "Durasi Mati harus di isi",
    onTimeSelected: (String time) {
      tmPickerFanOffDurartion.controller.setTextSelected(time);
    },
  );

  late SwitchButton sbIntermittern = SwitchButton(
      controller: GetXCreator.putSwitchButtonController("sbIntermittern"), label: "Intermittern", hint: "00:00:00", alertText: "Jenis Alat harus di isi", textUnit: "", inputType: TextInputType.text, maxInput: 100, onChanged: (value, control) {});

  @override
  void onInit() {
    super.onInit();
    deviceSetting = Get.arguments[0];
    device = Get.arguments[1];
    controllerData = Get.arguments[2];
    // if(Get.arguments != null){
    //     if(isEdit.isTrue){
    //         efDiffTemp.setInput("${deviceSetting.temperatureTarget}");
    //         if(deviceSetting.status == true) {
    //             sbIntermittern.controller.setOn();
    //         }else{
    //             sbIntermittern.controller.setOn();
    //         }
    //         sbIntermittern.controller.enable();
    //         efDiffTemp.controller.enable();
    //         tmPickerDurationOn.controller.enable();
    //         tmPickerFanOffDurartion.controller.enable();
    //     }else{
    //         efDiffTemp.setInput("${deviceSetting.temperatureTarget}");
    //         if(deviceSetting.status == true) {
    //             sbIntermittern.controller.setOn();
    //         }else{
    //             sbIntermittern.controller.setOn();
    //         }
    //         sbIntermittern.controller.disable();
    //         efDiffTemp.controller.disable();
    //         tmPickerDurationOn.controller.disable();
    //         tmPickerFanOffDurartion.controller.disable();
    //     }
    //
    // }
    // isLoading.value = true;
    boNoSettingFan = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("boNoSettingFan"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );
    bfYesSettingFan = ButtonFill(
      controller: GetXCreator.putButtonFillController("bfYesSettingFan"),
      label: "Ya",
      onClick: () {
        settingFan();
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    bfSaveGrowthDay = ButtonFill(
      controller: GetXCreator.putButtonFillController("bfSaveGrowthDay"),
      label: "Simpan",
      onClick: () {},
    );
    bfEditGrowthDay = ButtonFill(
      controller: GetXCreator.putButtonFillController("bfEditGrowthDay"),
      label: "Edit",
      onClick: () {},
    );
    getDetailFan();
  }

  void getDetailFan() {
    Service.push(
        service: ListApi.getFanDetail,
        context: context,
        body: [GlobalVar.auth!.token!, GlobalVar.auth!.id, GlobalVar.xAppId!, ListApi.pathDetailFanData('v2/b2b/iot-devices/smart-controller/coop/', "fan", device.deviceSummary!.coopCodeId!, device.deviceSummary!.deviceId!, deviceSetting.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as FanDetailResponse).data != null) {
                loadPage((body).data);
              }
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
  }

  /// The function `settingFan()` is responsible for setting up a fan device and
  /// making an API call to update the device settings.
  void settingFan() {
    Get.back();
    List ret = validationEdit();
    if (ret[0]) {
      isLoading.value = true;
      try {
        DeviceSetting payload = generatePayloadFanSetup();
        Service.push(
          service: ListApi.setController,
          context: context,
          body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId, ListApi.pathSetController('v2/b2b/iot-devices/smart-controller/coop/', "fan", device.deviceSummary!.coopCodeId!), Mapper.asJsonString(payload)],
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

  /// The function generates a payload for fan setup with the given device
  /// settings.
  ///
  /// Returns:
  ///   a DeviceSetting object.
  DeviceSetting generatePayloadFanSetup() {
    return DeviceSetting(
        id: deviceSetting.id,
        deviceId: controllerData.deviceId,
        intermitten: sbIntermittern.getValue(),
        temperatureTarget: efDiffTemp.getInputNumber(),
        timeOnFan: tmPickerDurationOn.getLastTimeSelectedText(),
        timeOffFan: tmPickerFanOffDurartion.getLastTimeSelectedText());
  }

  /// The function `validationEdit()` checks if certain input fields are empty and
  /// returns a list indicating whether the validation passed or failed.
  ///
  /// Returns:
  ///   a list with two elements. The first element is a boolean value indicating
  /// whether the validation is successful (true) or not (false). The second
  /// element is an empty string.
  List validationEdit() {
    List ret = [true, ""];

    if (efDiffTemp.getInput().isEmpty) {
      efDiffTemp.controller.showAlert();
      Scrollable.ensureVisible(efDiffTemp.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (tmPickerDurationOn.getLastTimeSelectedText().isEmpty) {
      tmPickerDurationOn.controller.showAlert();
      Scrollable.ensureVisible(tmPickerDurationOn.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (tmPickerFanOffDurartion.getLastTimeSelectedText().isEmpty) {
      tmPickerFanOffDurartion.controller.showAlert();
      Scrollable.ensureVisible(tmPickerFanOffDurartion.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    return ret;
  }

  /// The function `loadPage()` sets the input values and enables or disables
  /// controllers based on the `isEdit` flag and the `deviceSetting` status.
  void loadPage(DeviceSetting? fanData) {
    if (isEdit.isTrue) {
      efDiffTemp.setInput("${fanData!.temperatureTarget}");
      tmPickerDurationOn.controller.setTextSelected("${fanData.onlineDuration}");
      tmPickerFanOffDurartion.controller.setTextSelected("${fanData.offlineDuration}");
      if (fanData.intermitten == true) {
        sbIntermittern.controller.setOn();
      } else {
        sbIntermittern.controller.setOff();
      }
      sbIntermittern.controller.enable();
      efDiffTemp.controller.enable();
      tmPickerDurationOn.controller.enable();
      tmPickerFanOffDurartion.controller.enable();
    } else {
      efDiffTemp.setInput("${fanData!.temperatureTarget}");
      tmPickerDurationOn.controller.setTextSelected("${fanData.onlineDuration}");
      tmPickerFanOffDurartion.controller.setTextSelected("${fanData.offlineDuration}");

      if (fanData.intermitten == true) {
        sbIntermittern.controller.setOn();
      } else {
        sbIntermittern.controller.setOff();
      }
      sbIntermittern.controller.disable();
      efDiffTemp.controller.disable();
      tmPickerDurationOn.controller.disable();
      tmPickerFanOffDurartion.controller.disable();
    }
    isLoading.value = false;
  }
}

class FanSetupBindings extends Bindings {
  BuildContext context;

  FanSetupBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => FanSetupController(context: context));
  }
}
