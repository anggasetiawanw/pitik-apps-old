import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_setting_model.dart';
import 'package:model/error/error.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

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
  late String basePath;
  late bool isForPitikConnect;

  late ButtonFill bfYesSettingLamp;
  late ButtonOutline boNoSettingLamp;

  late DateTimeField dtfLampOn = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController("dtfLampOn"),
      label: "Waktu Nyala",
      hint: "00:00",
      flag: DateTimeField.TIME_FLAG,
      alertText: "Durasi Nyala harus di isi",
      onDateTimeSelected: (DateTime time, dateField) => dtfLampOn.controller.setTextSelected("${time.hour}:${time.minute}"));
  late DateTimeField dtfLampOff = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController("dtfLampOff"),
      label: "Waktu Mati",
      hint: "00: 00",
      flag: DateTimeField.TIME_FLAG,
      alertText: "Durasi Mati harus di isi",
      onDateTimeSelected: (DateTime time, dateField) => dtfLampOff.controller.setTextSelected("${time.hour}:${time.minute}"));

  @override
  void onInit() {
    super.onInit();
    lamp = Get.arguments[0];
    device = Get.arguments[1];
    controllerData = Get.arguments[2];
    basePath = Get.arguments[3];
    isForPitikConnect = Get.arguments[4];

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

    boNoSettingLamp = ButtonOutline(controller: GetXCreator.putButtonOutlineController("boNoRegBuildingLamp"), label: "Tidak", onClick: () => Get.back());
    bfYesSettingLamp = ButtonFill(controller: GetXCreator.putButtonFillController("bfYesSettingLamp"), label: "Ya", onClick: () => settingLamp());
  }

  /// The function `settingLamp()` is responsible for setting up a lamp device and
  /// handling the response from the server.
  void settingLamp() {
    Get.back();
    List ret = validationEdit();
    if (ret[0]) {
      AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          DeviceSetting payload = generatePayloadLampSetup();

          Service.push(
            apiKey: 'smartControllerApi',
            service: ListApi.setController,
            context: context,
            body: [
              'Bearer ${auth.token}',
              auth.id,
              GlobalVar.xAppId ?? '-',
              ListApi.pathSetController(basePath, "lamp", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', forPitikConnect: isForPitikConnect, idForNonPitikConnect: controllerData.id ?? ''),
              Mapper.asJsonString(payload)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  isLoading.value = false;
                  Get.off(TransactionSuccessActivity(keyPage: "smartLampSaved", message: "Kamu telah berhasil melakukan pengaturan Lampu", showButtonHome: false, onTapClose: () => Get.back(), onTapHome: () {}));
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
        } else {
          GlobalVar.invalidResponse();
        }
      });
    }
  }

  /// The function generates a payload for lamp setup by retrieving the last
  /// selected time for turning the lamp on and off.
  ///
  /// Returns:
  ///   a DeviceSetting object.
  DeviceSetting generatePayloadLampSetup() => DeviceSetting(id: lamp.id, deviceId: controllerData.deviceId, timeOnLight: dtfLampOn.getLastTimeSelectedText(), timeOffLight: dtfLampOff.getLastTimeSelectedText());

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

    if (dtfLampOff.getLastTimeSelectedText().isEmpty) {
      dtfLampOff.controller.showAlert();
      Scrollable.ensureVisible(dtfLampOff.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (dtfLampOn.getLastTimeSelectedText().isEmpty) {
      dtfLampOn.controller.showAlert();
      Scrollable.ensureVisible(dtfLampOn.controller.formKey.currentContext!);
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

  showBottomDialog(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: GlobalVar.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan semua data yang kamu masukan semua sudah benar", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset("images/ask_bottom_sheet_1.svg"),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: bfYesSettingLamp), const SizedBox(width: 16), Expanded(child: boNoSettingLamp)])),
                const SizedBox(height: GlobalVar.bottomSheetMargin)
              ]));
        });
  }
}

class LampSetupBindings extends Bindings {
  BuildContext context;

  LampSetupBindings({required this.context});

  @override
  void dependencies() => Get.lazyPut(() => LampSetupController(context: context));
}
