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

class HeaterSetupController extends GetxController {
  BuildContext context;

  HeaterSetupController({required this.context});

  ScrollController scrollController = ScrollController();
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  var isLoading = false.obs;
  var isEdit = false.obs;
  late Device device;
  late ControllerData controllerData;
  late String basePath;
  late bool isForPitikConnect;

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
    basePath = Get.arguments[2];
    isForPitikConnect = Get.arguments[3];

    loadPage();
    boNoSetHeater = ButtonOutline(controller: GetXCreator.putButtonOutlineController("boNoSetHeater"), label: "Tidak", onClick: () => Get.back());
    bfYesSetHeater = ButtonFill(controller: GetXCreator.putButtonFillController("bfYesSetHeater"), label: "Ya", onClick: () => settingHeater());
  }

  /// The function `settingHeater()` is responsible for setting up the heater
  /// device and handling the response from the server.
  void settingHeater() {
    Get.back();
    List ret = validationEdit();
    if (ret[0]) {
      AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          DeviceSetting payload = generatePayloadFanSetup();

          Service.push(
            apiKey: 'smartControllerApi',
            service: ListApi.setController,
            context: context,
            body: [
              'Bearer ${auth.token}',
              auth.id,
              GlobalVar.xAppId ?? '-',
              ListApi.pathSetController(basePath, "heater", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', forPitikConnect: isForPitikConnect, idForNonPitikConnect: controllerData.id ?? ''),
              Mapper.asJsonString(payload)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  isLoading.value = false;
                  Get.off(TransactionSuccessActivity(keyPage: "smartHeaterSaved", message: "Kamu telah berhasil melakukan pengaturan Pemanas", showButtonHome: false, onTapClose: () => Get.back(), onTapHome: () {}));
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
  DeviceSetting generatePayloadFanSetup() => DeviceSetting(deviceId: controllerData.deviceId, temperatureTarget: efDiffTempHeater.getInputNumber());

  showBottomDialog(BuildContext context, HeaterSetupController controller) {
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
                Container(margin: const EdgeInsets.only(top: 8), width: 60, height: 4, decoration: BoxDecoration(color: GlobalVar.outlineColor, borderRadius: BorderRadius.circular(2))),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text("Pastikan semua data yang kamu masukan semua sudah benar", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(margin: const EdgeInsets.only(top: 24), child: SvgPicture.asset("images/ask_bottom_sheet_1.svg")),
                Container(
                    margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: controller.bfYesSetHeater), const SizedBox(width: 16), Expanded(child: controller.boNoSetHeater)])),
                const SizedBox(height: GlobalVar.bottomSheetMargin)
              ]));
        });
  }
}

class HeaterSetupBindings extends Bindings {
  BuildContext context;
  HeaterSetupBindings({required this.context});

  @override
  void dependencies() => Get.lazyPut(() => HeaterSetupController(context: context));
}
