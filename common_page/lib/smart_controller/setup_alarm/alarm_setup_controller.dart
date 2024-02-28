import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
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

class AlarmSetupController extends GetxController {
  BuildContext context;
  AlarmSetupController({required this.context});

  ScrollController scrollController = ScrollController();
  RxMap<String, bool> mapList = RxMap<String, bool>({});

  var isLoading = false.obs;
  var isEdit = false.obs;

  late Device device;
  late ControllerData controllerData;
  late String basePath;
  late bool isForPitikConnect;

  late ButtonFill bfYesSetAlarm;
  late ButtonOutline boNoSetAlarm;
  late EditField efDiffHotTemp = EditField(
      controller: GetXCreator.putEditFieldController("efDiffHotTemp"),
      label: "Perbedaan Suhu Panas",
      hint: "Ketik disini",
      alertText: "Perbedaan Suhu Panas harus di isi",
      textUnit: "°C",
      inputType: TextInputType.number,
      maxInput: 4,
      onTyping: (value, control) {});
  late EditField efDiffColdTemp = EditField(
      controller: GetXCreator.putEditFieldController("efDiffColdTemp"),
      label: "Perbedaan Suhu Dingin",
      hint: "Ketik disini",
      alertText: "Perbedaan Suhu Dingin harus di isi",
      textUnit: "°C",
      inputType: TextInputType.number,
      maxInput: 4,
      onTyping: (value, control) {});

  @override
  void onInit() {
    super.onInit();
    device = Get.arguments[0];
    controllerData = Get.arguments[1];
    basePath = Get.arguments[2];
    isForPitikConnect = Get.arguments[3];

    boNoSetAlarm = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("boNoSetAlarm"),
      label: "Tidak",
      onClick: () => Get.back(),
    );

    bfYesSetAlarm = ButtonFill(
      controller: GetXCreator.putButtonFillController("bfYesSetAlarm"),
      label: "Ya",
      onClick: () => setAlarm(),
    );

    loadData(controllerData);
  }

  /// The function loads data into the controller and enables or disables the
  /// temperature inputs based on whether it is in edit mode or not.
  ///
  /// Args:
  ///   controllerData (ControllerData): An object that contains data related to
  /// the controller. It likely has properties such as "hot" and "cold" which
  /// represent temperature values.
  void loadData(ControllerData controllerData) {
    efDiffHotTemp.setInput("${controllerData.hot}");
    efDiffColdTemp.setInput("${controllerData.cold}");

    if (isEdit.isTrue) {
      efDiffHotTemp.controller.enable();
      efDiffColdTemp.controller.enable();
    } else {
      efDiffHotTemp.controller.disable();
      efDiffColdTemp.controller.disable();
    }

    isLoading.value = false;
  }

  /// The function `setAlarm()` sends a request to a server to set an alarm, and
  /// handles the response accordingly.
  void setAlarm() {
    Get.back();
    List ret = validationEdit();
    if (ret[0]) {
      AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          DeviceSetting payload = generatePayloadSetAlarm();

          Service.push(
            apiKey: 'smartControllerApi',
            service: ListApi.setController,
            context: context,
            body: [
              'Bearer ${auth.token}',
              auth.id,
              GlobalVar.xAppId ?? '-',
              ListApi.pathSetController(basePath, "alarm", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', forPitikConnect: isForPitikConnect, idForNonPitikConnect: controllerData.id ?? '-'),
              Mapper.asJsonString(payload)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  isLoading.value = false;
                  Get.off(TransactionSuccessActivity(keyPage: "smartAlarmSaved", message: "Kamu telah berhasil melakukan pengaturan Alarm", showButtonHome: false, onTapClose: () => Get.back(), onTapHome: () {}));
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

  /// The `validationEdit` function checks if two input fields are empty and
  /// returns a list indicating if the validation passed or failed, while the
  /// `generatePayloadSetAlarm` function creates a `DeviceSetting` object with
  /// values from the input fields.
  ///
  /// Returns:
  ///   The function `validationEdit()` returns a list containing two elements: a
  /// boolean value and an empty string.
  List validationEdit() {
    List ret = [true, ""];

    if (efDiffHotTemp.getInput().isEmpty) {
      efDiffHotTemp.controller.showAlert();
      Scrollable.ensureVisible(efDiffHotTemp.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (efDiffColdTemp.getInput().isEmpty) {
      efDiffColdTemp.controller.showAlert();
      Scrollable.ensureVisible(efDiffColdTemp.controller.formKey.currentContext!);
      return ret = [false, ""];
    }

    return ret;
  }

  /// The function generates a payload for setting alarms on a device, using the
  /// device ID and input numbers for cold and hot alarms.
  ///
  /// Returns:
  ///   a DeviceSetting object.
  DeviceSetting generatePayloadSetAlarm() => DeviceSetting(deviceId: controllerData.deviceId, coldAlarm: efDiffColdTemp.getInputNumber(), hotAlarm: efDiffHotTemp.getInputNumber());

  showBottomDialog(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: GlobalVar.outlineColor,
                      borderRadius: BorderRadius.circular(2),
                    )),
                Container(margin: const EdgeInsets.only(top: 24, left: 16, right: 73), child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold))),
                Container(margin: const EdgeInsets.only(top: 8, left: 16, right: 52), child: const Text("Pastikan semua data yang kamu masukan semua sudah benar", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12))),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset("images/ask_bottom_sheet_1.svg"),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 24, left: 16, right: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: bfYesSetAlarm), const SizedBox(width: 16), Expanded(child: boNoSetAlarm)])),
                const SizedBox(height: GlobalVar.bottomSheetMargin)
              ]));
        });
  }
}

class AlarmSetupBindings extends Bindings {
  BuildContext context;
  AlarmSetupBindings({required this.context});

  @override
  void dependencies() => Get.lazyPut(() => AlarmSetupController(context: context));
}
