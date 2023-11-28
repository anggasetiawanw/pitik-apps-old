
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/time_picker/time_picker_field.dart';
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
import 'package:model/response/cooler_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class CoolerSetupController extends GetxController {
    BuildContext context;

    CoolerSetupController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    var isEdit = false.obs;

    late Device device;
    late ControllerData controllerData;
    late String basePath;
    late bool isForPitikConnect;

    late ButtonFill bfYesSetCooler;
    late ButtonOutline boNoSetCooler;
    late EditField efTargetTempColler = EditField(
        controller: GetXCreator.putEditFieldController("efTargetTempCooler"),
        label: "Target Suhu",
        hint: "Ketik disini",
        alertText: "Target Suhuharus di isi",
        textUnit: "°C",
        inputType: TextInputType.number,
        maxInput: 4,
        onTyping: (value, control) {}
    );
    late TimePickerField tmPickerDurationCoolerOn = TimePickerField(
        controller: GetXCreator.putTimePickerController("tmPickerDurationOnCooler"),
        label: "Durasi Nyala",
        hint: "00:00:00",
        flag: TimePickerField.TIME_HOURS_AND_MINUTES,
        alertText: "Durasi Nyala harus di isi",
        onTimeSelected: (String time) => tmPickerDurationCoolerOn.controller.setTextSelected(time)
    );
    late TimePickerField tmPickerCoolerOffDuration = TimePickerField(
        controller: GetXCreator.putTimePickerController("tmPickerFanOffDurationCooler"),
        label: "Durasi Mati",
        hint: "00:00:00",
        flag: TimePickerField.TIME_HOURS_AND_MINUTES,
        alertText: "Durasi Mati harus di isi",
        onTimeSelected: (String time) => tmPickerCoolerOffDuration.controller.setTextSelected(time)
    );

    @override
    void onInit() {
        super.onInit();
        device = Get.arguments[0];
        controllerData = Get.arguments[1];
        basePath = Get.arguments[2];
        isForPitikConnect = Get.arguments[3];

        isLoading.value = true;

        boNoSetCooler = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoSetCooler"),
            label: "Tidak",
            onClick: () => Get.back()
        );

        bfYesSetCooler = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesSetCooler"),
            label: "Ya",
            onClick: () => settingCooler()
        );

        getDataCooler();
    }

    @override
    void onReady() {
        super.onReady();
        tmPickerDurationCoolerOn.controller.disable();
    }

    /// The function `getDataCooler` retrieves cooler data from an API and handles
    /// different response scenarios.
    void getDataCooler() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'smartControllerApi',
                service: ListApi.getCoolerData,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, GlobalVar.xAppId ?? '-', ListApi.pathDeviceData(
                    basePath,
                    "cooler/detail",
                    isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-',
                    isForPitikConnect ? device.deviceSummary!.deviceId! : device.deviceId ?? '-'
                )],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as CoolerResponse).data != null) {
                            loadData((body).data!);
                        }

                        isLoading.value = false;
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
                        isLoading.value = false;
                        Get.snackbar(
                            "Pesan",
                            "Terjadi kesalahan internal",
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                        );
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });
    
    /// The function loads data into various input fields and controllers based on
    /// the device settings, and enables or disables them based on whether it is in
    /// edit mode or not.
    ///
    /// Args:
    ///   deviceSetting (DeviceSetting): The deviceSetting parameter is an object of
    /// type DeviceSetting. It contains properties such as temperatureTarget,
    /// onlineDuration, offlineDuration, and isEdit.
    void loadData(DeviceSetting deviceSetting) {
        efTargetTempColler.setInput("${deviceSetting.temperatureTarget}");
        tmPickerDurationCoolerOn.controller.setTextSelected("${deviceSetting.onlineDuration}");
        tmPickerCoolerOffDuration.controller.setTextSelected("${deviceSetting.offlineDuration}");

        if (isEdit.isTrue) {
            efTargetTempColler.controller.enable();
            tmPickerDurationCoolerOn.controller.enable();
            tmPickerCoolerOffDuration.controller.enable();
        } else {
            efTargetTempColler.controller.disable();
            tmPickerDurationCoolerOn.controller.disable();
            tmPickerCoolerOffDuration.controller.disable();
        }
    }

    /// The function `settingCooler()` is responsible for setting up a cooler device
    /// and handling the response from the server.
    void settingCooler() {
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
                            ListApi.pathSetController(basePath, "cooler/detail", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', forPitikConnect: isForPitikConnect, idForNonPitikConnect: controllerData.id ?? ''),
                            Mapper.asJsonString(payload)
                        ],
                        listener:ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                isLoading.value = false;
                                Get.off(TransactionSuccessActivity(
                                    keyPage: "smartCoolerSaved",
                                    message: "Kamu telah berhasil melakukan pengaturan pendingin",
                                    showButtonHome: false,
                                    onTapClose: () => Get.back(),
                                    onTapHome: () {}
                                ));
                            },
                            onResponseFail: (code, message, body, id, packet) {
                                isLoading.value = false;
                                Get.snackbar(
                                    "Alert", (body as ErrorResponse).error!.message!,
                                    snackPosition: SnackPosition.TOP,
                                    duration: const Duration(seconds: 5),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white
                                );
                            },
                            onResponseError: (exception, stacktrace, id, packet) {
                                isLoading.value = false;
                                Get.snackbar(
                                    "Alert","Terjadi kesalahan internal",
                                    snackPosition: SnackPosition.TOP,
                                    duration: const Duration(seconds: 5),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white
                                );
                            },
                            onTokenInvalid: () => GlobalVar.invalidResponse()
                        ),
                    );
                } else {
                    GlobalVar.invalidResponse();
                }
            });
        }
    }

    /// The function `validationEdit()` checks if certain input fields are empty and
    /// returns a list indicating whether the validation was successful and an error
    /// message if applicable.
    ///
    /// Returns:
    ///   a list containing two elements: a boolean value and an empty string.
    List validationEdit() {
        List ret = [true, ""];

        if (efTargetTempColler.getInput().isEmpty) {
            efTargetTempColler.controller.showAlert();
            Scrollable.ensureVisible(
                efTargetTempColler.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (tmPickerDurationCoolerOn.getLastTimeSelectedText().isEmpty) {
            tmPickerDurationCoolerOn.controller.showAlert();
            Scrollable.ensureVisible(
                tmPickerDurationCoolerOn.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (tmPickerCoolerOffDuration.getLastTimeSelectedText().isEmpty) {
            tmPickerCoolerOffDuration.controller.showAlert();
            Scrollable.ensureVisible(
                tmPickerCoolerOffDuration.controller.formKey.currentContext!);
            return ret = [false, ""];
        }

        return ret;
    }

    /// The function generates a payload for fan setup by retrieving input values
    /// for cooling pad temperature, time on cooling pad, and time off cooling pad.
    ///
    /// Returns:
    ///   a DeviceSetting object.
    DeviceSetting generatePayloadFanSetup() => DeviceSetting(deviceId : controllerData.deviceId,  coolingPadTemperature : efTargetTempColler.getInputNumber(), timeOnCoolingPad: tmPickerDurationCoolerOn.getLastTimeSelectedText(), timeOffCoolingPad: tmPickerCoolerOffDuration.getLastTimeSelectedText());

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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: GlobalVar.outlineColor,
                                    borderRadius: BorderRadius.circular(2),
                                )
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
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: bfYesSetCooler),
                                        const SizedBox(width: 16),
                                        Expanded(child: boNoSetCooler),
                                    ]
                                )
                            ),
                            const SizedBox(height: GlobalVar.bottomSheetMargin)
                        ]
                    )
                );
            }
        );
    }
}

class CoolerSetupBindings extends Bindings {
    BuildContext context;
    CoolerSetupBindings({required this.context});

    @override
    void dependencies() => Get.lazyPut(() => CoolerSetupController(context: context));
}

