
import 'package:app_settings/app_settings.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/bluetooth_le_service.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/smart_scale_response.dart';
import 'package:model/smart_scale/smart_scale_model.dart';
import 'package:model/smart_scale/smart_scale_record_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

class SmartScaleWeighingController extends GetxController {

    BuildContext context;
    SmartScaleWeighingController({required this.context});

    late Coop coop;

    var isLoading = false.obs;
    var id = "".obs;
    var weighingValue = "".obs;
    var batteryStatus = "".obs;
    var isTimeout = true.obs;
    var numberList = 0.obs;

    RxList<int> index = RxList<int>([]);
    RxList<int> numberLabel = RxList<int>([]);
    Rx<SmartScale?> smartScaleData = (SmartScale()).obs;
    RxMap<int, SmartScaleRecord> smartScaleRecords = <int, SmartScaleRecord>{}.obs;
    RxMap<int, Widget> smartScaleDataWidget = <int, Widget>{}.obs;
    RxMap<int, Widget> smartScaleDataWidgetNumber = <int, Widget>{}.obs;
    BluetoothLeService? bluetoothLeService;

    final EditField totalWeighingField = EditField(controller: GetXCreator.putEditFieldController("totalWeighingFieldSmartScale"), label: "Jumlah Ditimbang", hint: "Ketik disini..!", alertText: "Harus isi jumlah ditimbang..!",
        textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
        onTyping: (text, editField) {}
    );

    final EditField outstandingTotalWeighingField = EditField(controller: GetXCreator.putEditFieldController("outstandingTotalWeighingFieldSmartScale"), label: "Sisa Belum Ditimbang", hint: "", alertText: "",
        textUnit: "kg", inputType: TextInputType.number, maxInput: 10,
        onTyping: (text, editField) {

        }
    );

    final EditField totalChicken = EditField(controller: GetXCreator.putEditFieldController("totalChickenField"), label: "Jumlah Ayam", hint: "Ketik disini..!", alertText: "Harus diisi..!",
        textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
        onTyping: (text, editField) {}
    );

    final EditField totalWeighing = EditField(controller: GetXCreator.putEditFieldController("totalWeighingField"), label: "Total Timbang", hint: "", alertText: "",
        textUnit: "kg", inputType: TextInputType.number, maxInput: 10,
        onTyping: (text, editField) {}
    );

    void _setOutstandingWeighing() {
        if (totalWeighingField.getInput() != '') {
            int count = totalWeighingField.getInputNumber()!.toInt();
            smartScaleRecords.forEach((key, value) {
                count -= value.count!;
            });

            outstandingTotalWeighingField.setInput(count.toString());
        } else {
            outstandingTotalWeighingField.setInput('0.0');
        }
    }

    void removeWeighing(int idx) {
        index.removeWhere((item) => item == idx);
        smartScaleDataWidget.removeWhere((key, value) => key == idx);
        smartScaleDataWidgetNumber.removeWhere((key, value) => key == idx);
        smartScaleRecords.removeWhere((key, value) => key == idx);

        _setOutstandingWeighing();
        smartScaleDataWidget.refresh();
        _generateNumberList();
    }

    void addWeighing(SmartScaleRecord? dataParam) {
        if (totalChicken.getInput() == '' && dataParam == null) {
            totalChicken.controller.showAlert();
        } else {
            index.add(numberList.value);
            int idx = numberList.value;

            SmartScaleRecord smartScaleRecord;
            if (dataParam != null) {
                smartScaleRecord = dataParam;
            } else {
                smartScaleRecord = SmartScaleRecord(
                    count: totalChicken.getInputNumber()!.toInt(),
                    weight: totalWeighing.getInputNumber()
                );
            }
            smartScaleRecords.putIfAbsent(idx, () => smartScaleRecord);

            final EditField totalChick = EditField(controller: GetXCreator.putEditFieldController("totalChickenAdd$idx"), label: "", hint: "", alertText: "",
                textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
                onTyping: (text, editField) {}
            );

            final EditField totalWeight = EditField(controller: GetXCreator.putEditFieldController("totalWeighingAdd$idx"), label: "", hint: "", alertText: "",
                textUnit: "kg", inputType: TextInputType.number, maxInput: 10,
                onTyping: (text, editField) {}
            );

            totalChick.controller.invisibleLabel();
            totalWeight.controller.invisibleLabel();

            totalChick.setInput(smartScaleRecord.count.toString());
            totalWeight.setInput(smartScaleRecord.weight.toString());

            totalChick.controller.disable();
            totalWeight.controller.disable();

            _setOutstandingWeighing();
            smartScaleDataWidget.putIfAbsent(idx, () =>
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        const SizedBox(width: 8),
                        Expanded(child: totalChick),
                        const SizedBox(width: 8),
                        Expanded(child: totalWeight),
                        const SizedBox(width: 8),
                        Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(width: 2, color: GlobalVar.primaryOrange),
                            ),
                            child: GestureDetector(
                                child: SvgPicture.asset('images/minus_orange_icon.svg', width: 16, height: 16),
                                onTap: () => removeWeighing(idx),
                            )
                        )
                    ]
                )
            );

            numberList.value++;
            smartScaleDataWidget.refresh();
            _generateNumberList();
        }
    }

    void _generateNumberList() {
        int indexNumber = 1;
        smartScaleDataWidgetNumber.clear();
        smartScaleDataWidget.forEach((key, value) {
            final numberField = Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Container(
                    height: 50,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: GlobalVar.gray
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Center(child: Text('$indexNumber', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: const Color(0xFF9E9D9D))))
                    )
                )
            );

            smartScaleDataWidgetNumber.putIfAbsent(key, () => numberField);
            indexNumber++;
        });
    }

    @override
    void onInit() {
        super.onInit();
        try {
            id.value = Get.arguments[2];
            isLoading.value = true;
        } catch (exception) {}

        coop = Get.arguments[0];
        outstandingTotalWeighingField.controller.disable();
        totalWeighing.controller.disable();
        getSmartScaleWeighingDetail(Get.arguments[1]);

        bluetoothLeService = BluetoothLeService().timeout(true, 5).start(BluetoothLeConstant.TEXT_RESULT, ['PTK-SCL'], BluetoothLeCallback(
            onLeReceived: (data) {
                isTimeout.value = false;
                weighingValue.value = data.substring(0, data.lastIndexOf('-'));
                batteryStatus.value = data.substring(data.lastIndexOf('-') + 1, data.length - 1);

                totalWeighing.setInput(weighingValue.value);
            },
            onDisabled: () => AppSettings.openBluetoothSettings(callback: () async {

            }),
            onTimeout: () {
                isTimeout.value = true;
                batteryStatus.value = '-';
            }
        ));
    }

    @override
    void onClose() {
        if (bluetoothLeService != null) {
            bluetoothLeService!.stop();
        }
        super.onClose();
    }

    /// The function `getSmartScaleWeighingDetail` retrieves smart scale weighing
    /// details based on a boolean flag indicating whether it is a new request or
    /// not.
    ///
    /// Args:
    ///   isNew (bool): isNew is a boolean parameter that indicates whether the
    /// weighing detail is new or not. If isNew is true, it means that the weighing
    /// detail is new and needs to be fetched. If isNew is false, it means that the
    /// weighing detail already exists and does not need to be fetched again.
    void getSmartScaleWeighingDetail(bool isNew) => AuthImpl().get().then((auth) => {
        if (!isNew) {
            if (auth != null) {
                Service.push(
                    apiKey: "smartScaleApi",
                    service: ListApi.getSmartScaleDetail,
                    context: context,
                    body: [auth.token, auth.id, ListApi.pathSmartScaleForDetailAndUpdate(id.value)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            smartScaleData.value = SmartScale();
                            smartScaleData.value = (body as SmartScaleResponse).data;

                            if (smartScaleData.value != null && smartScaleData.value!.records.isNotEmpty) {
                                for (var element in smartScaleData.value!.records) {
                                  addWeighing(element);
                                }
                            }

                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                        onTokenInvalid: GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        }
    });

    /// The function `saveSmartScaleWeighing()` saves smart scale weighing data to
    /// the server.
    saveSmartScaleWeighing() {
        AuthImpl().get().then((auth) {
            if (auth != null) {
                if (smartScaleRecords.isNotEmpty) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: Get.context!,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                            )
                        ),
                        builder: (context) => Container(
                            color: Colors.transparent,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Container(
                                                width: 60,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                    color: GlobalVar.outlineColor
                                                )
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 24),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange))
                                            )
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: const Color(0xFF9E9D9D)))
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 24),
                                            child: SvgPicture.asset("images/ask_bottom_sheet_1.svg")
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 24, bottom: 32),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(
                                                        child: ButtonFill(
                                                            controller: GetXCreator.putButtonFillController("bfYesSaveSmartScaleWeighing"),
                                                            label: "Ya",
                                                            onClick: () {
                                                                // before check is edit or not
                                                                bool isEdit = smartScaleData.value!.id != null;

                                                                // setting body
                                                                smartScaleData.value!.records = smartScaleRecords.entries.map( (entry) => entry.value).toList();
                                                                smartScaleData.value!.roomId = coop.room!.id;
                                                                smartScaleData.value!.executionDate = Convert.getStringIso(DateTime.now());

                                                                isLoading.value = true;
                                                                Navigator.pop(context);
                                                                Service.push(
                                                                    apiKey: "smartScaleApi",
                                                                    service: isEdit ? ListApi.updateSmartScale : ListApi.saveSmartScale,
                                                                    context: context,
                                                                    body: [auth.token, auth.id, Mapper.asJsonString(smartScaleData.value), isEdit ? ListApi.pathSmartScaleForDetailAndUpdate(id.value) : null],
                                                                    listener: ResponseListener(
                                                                        onResponseDone: (code, message, body, id, packet) {
                                                                            print('SAVE SMART SCALE SUCCESS');
                                                                            isLoading.value = false;
                                                                        },
                                                                        onResponseFail: (code, message, body, id, packet) {
                                                                            isLoading.value = false;
                                                                            Get.snackbar(
                                                                                "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                                                                snackPosition: SnackPosition.TOP,
                                                                                colorText: Colors.white,
                                                                                duration: const Duration(seconds: 5),
                                                                                backgroundColor: Colors.red,
                                                                            );
                                                                        },
                                                                        onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                                                                        onTokenInvalid: GlobalVar.invalidResponse()
                                                                    )
                                                                );
                                                            }
                                                        )
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                        child: ButtonOutline(
                                                            controller: GetXCreator.putButtonOutlineController("boNoSaveSmartScaleWeighing"),
                                                            label: "Tidak",
                                                            onClick: () => Navigator.pop(context)
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    );
                } else {
                    Get.snackbar(
                        "Pesan", "Data timbang masih kosong, silahkan isi data timbang dahulu..!",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                    );
                }
            } else {
                GlobalVar.invalidResponse();
            }
        });
    }
}

class SmartScaleWeighingBinding extends Bindings {

    BuildContext context;
    SmartScaleWeighingBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SmartScaleWeighingController>(() => SmartScaleWeighingController(context: context));
    }
}