import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/expandable/expandable_controller.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/item_decrease_temp/item_decrease_temperature.dart';
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
import 'package:model/error/error.dart';
import 'package:model/growth_day_model.dart';
import 'package:model/response/growth_day_response.dart';
import 'package:model/temperature_reduction_model.dart';

import '../../transaction_success_activity.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class GrowthSetupController extends GetxController {
  BuildContext context;

  GrowthSetupController({required this.context});

  ScrollController scrollController = ScrollController();
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
  Rx<List<TemperatureReduction>> list = Rx<List<TemperatureReduction>>([]);

  var isLoading = false.obs;
  var isEdit = false.obs;

  late Device device;
  late ControllerData controllerData;
  late String basePath;
  late bool isForPitikConnect;

  late ButtonFill bfYesEditGrowthDay;
  late ButtonOutline bfNoEditGrowthDay;
  late EditField efTargetTemp = EditField(
      controller: GetXCreator.putEditFieldController("efTargetTemp"),
      label: "Target Suhu Hari Ini",
      hint: "Ketik disini",
      alertText: "Target Suhu Hari Ini harus di isi",
      textUnit: "°C",
      inputType: TextInputType.number,
      maxInput: 4,
      onTyping: (value, control) {});
  late EditField efAge =
      EditField(controller: GetXCreator.putEditFieldController("efAge"), label: "Umur", hint: "Ketik disini", alertText: "Umur harus di isi", textUnit: "Hari", inputType: TextInputType.number, maxInput: 3, onTyping: (value, control) {});
  late EditField efTempDayFirst = EditField(
      controller: GetXCreator.putEditFieldController("efTempDayFirst"),
      label: "Suhu Hari 1",
      hint: "Ketik disini",
      alertText: "Suhu Hari 1 Ini harus di isi",
      textUnit: "°C",
      inputType: TextInputType.number,
      maxInput: 4,
      onTyping: (value, control) {});
  late Expandable expandable = Expandable(
      controller: GetXCreator.putAccordionController("expandableReduceTemperature"),
      headerText: "Pengurangan Suhu",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [itemDecreaseTemperature],
      ));

  late ItemDecreaseTemperature itemDecreaseTemperature;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    device = Get.arguments[0];
    controllerData = Get.arguments[1];
    basePath = Get.arguments[2];
    isForPitikConnect = Get.arguments[3];

    bfNoEditGrowthDay = ButtonOutline(controller: GetXCreator.putButtonOutlineController("bfNoEditGrowthDay"), label: "Tidak", onClick: () => Get.back());
    bfYesEditGrowthDay = ButtonFill(controller: GetXCreator.putButtonFillController("bfYesEditGrowthDay"), label: "Ya", onClick: () => setGrowthDay());

    itemDecreaseTemperature = ItemDecreaseTemperature(controller: GetXCreator.putItemDecreaseController("itemDecreaseTemperature", context));
    getDetailGrowthDay();
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<ExpandableController>(tag: "expandableReduceTemperature");
  }

  /// The function `loadData` populates a list and sets input values based on the
  /// provided `GrowthDay` object.
  ///
  /// Args:
  ///   growthDay (GrowthDay): The `growthDay` parameter is an object of type
  /// `GrowthDay`.
  void loadData(GrowthDay growthDay) {
    list.value.clear();
    itemDecreaseTemperature.controller.removeAll();
    if (growthDay.temperatureReduction!.isNotEmpty) {
      for (var result in growthDay.temperatureReduction!) {
        list.value.add(result!);
      }
    }
    efAge.setInput("${growthDay.growthDay}");
    efTargetTemp.setInput("${growthDay.requestTemperature}");
    efTempDayFirst.setInput("${growthDay.temperature}");
    if (isEdit.isTrue) {
      efAge.controller.enable();
      efTargetTemp.controller.enable();
      efTempDayFirst.controller.enable();
    } else {
      efAge.controller.disable();
      efTargetTemp.controller.disable();
      efTempDayFirst.controller.disable();
    }

    for (int i = 0; i < list.value.length - 1; i++) {
      itemDecreaseTemperature.controller.addCard();
    }
    for (int i = 0; i < list.value.length - 1; i++) {
      itemDecreaseTemperature.controller.efDayTotal.value[i].setInput("${list.value[i].day ?? ''}");
      itemDecreaseTemperature.controller.efDecreaseTemp.value[i].setInput("${list.value[i].reduction ?? ''}");
      if (isEdit.isTrue) {
        itemDecreaseTemperature.controller.efDayTotal.value[i].controller.enable();
        itemDecreaseTemperature.controller.efDecreaseTemp.value[i].controller.enable();
      } else {
        itemDecreaseTemperature.controller.efDayTotal.value[i].controller.disable();
        itemDecreaseTemperature.controller.efDecreaseTemp.value[i].controller.disable();
      }
    }

    isLoading.value = false;
  }

  /// The function `getDetailGrowthDay` makes an API call to retrieve growth day
  /// data and handles the response accordingly.
  void getDetailGrowthDay() => AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          Service.push(
              apiKey: 'smartControllerApi',
              service: ListApi.getDataGrowthDay,
              context: context,
              body: [
                'Bearer ${auth.token}',
                auth.id,
                GlobalVar.xAppId ?? '-',
                ListApi.pathDeviceData(basePath, "growth-day", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', isForPitikConnect ? device.deviceSummary!.deviceId! : device.deviceId ?? '-')
              ],
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) => loadData((body as GrowthDayResponse).data!),
                  onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                      "Pesan",
                      "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                  },
                  onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                      "Pesan",
                      "Terjadi Kesalahan Internal",
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });

  /// The function `setGrowthDay()` sends a request to the server to set the
  /// growth day and handles the response accordingly.
  void setGrowthDay() {
    Get.back();
    List ret = validationEdit();
    if (ret[0]) {
      AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoading.value = true;
          GrowthDay payload = generatePayloadSetGrowthDay();
          Service.push(
            apiKey: 'smartControllerApi',
            service: ListApi.setController,
            context: context,
            body: [
              'Bearer ${auth.token}',
              auth.id,
              GlobalVar.xAppId ?? '-',
              ListApi.pathSetController(basePath, "growth-day", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', forPitikConnect: isForPitikConnect, idForNonPitikConnect: controllerData.id ?? '-'),
              Mapper.asJsonString(payload)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                  isLoading.value = false;
                  Get.off(TransactionSuccessActivity(keyPage: "smartGrowthDaySaved", message: "Kamu telah berhasil melakukan pengaturan Masa Tumbuh", showButtonHome: false, onTapClose: () => Get.back(), onTapHome: () {}));
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

  List validationEdit() {
    List ret = [true, ""];

    if (efTargetTemp.getInput().isEmpty) {
      efTargetTemp.controller.showAlert();
      Scrollable.ensureVisible(efTargetTemp.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (efAge.getInput().isEmpty) {
      efAge.controller.showAlert();
      Scrollable.ensureVisible(efAge.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (efTempDayFirst.getInput().isEmpty) {
      efTempDayFirst.controller.showAlert();
      Scrollable.ensureVisible(efTempDayFirst.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    ret = itemDecreaseTemperature.controller.validation();

    return ret;
  }

  GrowthDay generatePayloadSetGrowthDay() {
    List<TemperatureReduction?> temperatureReductions = [];
    for (int i = 0; i < itemDecreaseTemperature.controller.itemCount.value; i++) {
      int whichItem = itemDecreaseTemperature.controller.index.value[i];
      temperatureReductions.add(TemperatureReduction(
          day: (itemDecreaseTemperature.controller.efDayTotal.value[whichItem].getInputNumber())!.toInt(), reduction: itemDecreaseTemperature.controller.efDecreaseTemp.value[whichItem].getInputNumber(), group: "${whichItem + 1}"));
    }

    return GrowthDay(deviceId: controllerData.deviceId, requestTemperature: efTargetTemp.getInputNumber(), growthDay: (efAge.getInputNumber())!.toInt(), temperature: efTempDayFirst.getInputNumber(), temperatureReduction: temperatureReductions);
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
                Container(margin: const EdgeInsets.only(top: 8), width: 60, height: 4, decoration: BoxDecoration(color: GlobalVar.outlineColor, borderRadius: BorderRadius.circular(2))),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: bfYesEditGrowthDay),
                      const SizedBox(width: 16),
                      Expanded(child: bfNoEditGrowthDay),
                    ],
                  ),
                ),
                const SizedBox(height: GlobalVar.bottomSheetMargin)
              ]));
        });
  }
}

class GrowthSetupBindings extends Bindings {
  BuildContext context;
  GrowthSetupBindings({required this.context});

  @override
  void dependencies() => Get.lazyPut(() => GrowthSetupController(context: context));
}
