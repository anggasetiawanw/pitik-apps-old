
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/switch_button/switch_button.dart';
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
import 'package:model/response/fan_detail_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class FanSetupController extends GetxController {
    BuildContext context;

    FanSetupController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var isLoading = false.obs;
    var isEdit = false.obs;

    late ButtonFill bfYesSettingFan;
    late ButtonOutline boNoSettingFan;
    late Device device;
    late DeviceSetting deviceSetting;
    late ControllerData controllerData;
    late String basePath;
    late bool isForPitikConnect;

    late EditField efDiffTemp = EditField(
        controller: GetXCreator.putEditFieldController("efDiffTemp"),
        label: "Perbedaan Suhu",
        hint: "Ketik disini",
        alertText: "Perbedaan Suhu harus di isi",
        textUnit: "°C",
        inputType: TextInputType.number,
        maxInput: 4,
        onTyping: (value, control) {}
    );
    late TimePickerField tmPickerDurationOn = TimePickerField(
        controller: GetXCreator.putTimePickerController("tmPickerDurationOn"),
        label: "Durasi Nyala",
        hint: "00:00:00",
        flag: TimePickerField.TIME_MINUTES_AND_SECONDS,
        alertText: "Durasi Nyala harus di isi",
        onTimeSelected: (String time) => tmPickerDurationOn.controller.setTextSelected(time)
    );
    late TimePickerField tmPickerFanOffDurartion = TimePickerField(
        controller: GetXCreator.putTimePickerController("tmPickerFanOffDurartion"),
        label: "Durasi Mati",
        hint: "00:00:00",
        flag: TimePickerField.TIME_MINUTES_AND_SECONDS,
        alertText: "Durasi Mati harus di isi",
        onTimeSelected: (String time) => tmPickerFanOffDurartion.controller.setTextSelected(time),
    );

    late SwitchButton sbIntermittern = SwitchButton(
        controller: GetXCreator.putSwitchButtonController("sbIntermittern"),
        label: "Intermittern",
        hint: "00:00:00",
        alertText: "Jenis Alat harus di isi",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 100,
        onChanged: (value, control) {}
    );

    @override
    void onInit() {
        super.onInit();
        deviceSetting = Get.arguments[0];
        device = Get.arguments[1];
        controllerData = Get.arguments[2];
        basePath = Get.arguments[3];
        isForPitikConnect = Get.arguments[4];

        boNoSettingFan = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoSettingFan"),
            label: "Tidak",
            onClick: () => Get.back()
        );

        bfYesSettingFan = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesSettingFan"),
            label: "Ya",
            onClick: () => settingFan()
        );
    }

    @override
    void onReady() {
        super.onReady();
        getDetailFan();
    }

    void getDetailFan() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'smartControllerApi',
                service: ListApi.getFanDetail,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, GlobalVar.xAppId ?? '-', ListApi.pathDetailFanData(
                    basePath,
                    "fan",
                    isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-',
                    isForPitikConnect ? device.deviceSummary!.deviceId! : device.deviceId ?? '-',
                    deviceSetting.id!)
                ],
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

    /// The function `settingFan()` is responsible for setting up a fan device and
    /// making an API call to update the device settings.
    void settingFan() {
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
                            ListApi.pathSetController(basePath, "fan", isForPitikConnect ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-', forPitikConnect: isForPitikConnect, idForNonPitikConnect: controllerData.id ?? '-'),
                            Mapper.asJsonString(payload)
                        ],
                        listener:ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                isLoading.value = false;
                                Get.off(TransactionSuccessActivity(
                                    keyPage: "smartFanSaved",
                                    message: "Kamu telah berhasil melakukan pengaturan kipas",
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
                        )
                    );
                } else {
                    GlobalVar.invalidResponse();
                }
            });
        }
    }

    /// The function generates a payload for fan setup with the given device
    /// settings.
    ///
    /// Returns:
    ///   a DeviceSetting object.
    DeviceSetting generatePayloadFanSetup() => DeviceSetting(id: deviceSetting.id, deviceId:controllerData.deviceId,  intermitten: sbIntermittern.getValue(), temperatureTarget: efDiffTemp.getInputNumber(), timeOnFan: tmPickerDurationOn.getLastTimeSelectedText(), timeOffFan: tmPickerFanOffDurartion.getLastTimeSelectedText());

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
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: GlobalVar.outlineColor,
                                    borderRadius: BorderRadius.circular(2)
                                )
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                                child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold)),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                                child: const Text("Pastikan semua data yang kamu masukan semua sudah benar", style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12))
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
                                        Expanded(child: bfYesSettingFan),
                                        const SizedBox(width: 16),
                                        Expanded(child: boNoSettingFan)
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

class FanSetupBindings extends Bindings {
    BuildContext context;
    FanSetupBindings({required this.context});

    @override
    void dependencies() => Get.lazyPut(() => FanSetupController(context: context));
}

