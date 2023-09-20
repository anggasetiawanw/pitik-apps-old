// ignore_for_file: slash_for_doc_comments, empty_catches

import 'package:app_settings/app_settings.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/smart_scale_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/bluetooth_le_service.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:model/auth_model.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/smart_scale/smart_scale_model.dart';
import 'package:model/smart_scale/smart_scale_record_model.dart';

import '../smart_scale_done_summary.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class SmartScaleWeighingController extends GetxController {

    BuildContext context;
    SmartScaleWeighingController({required this.context});

    final DateTime startWeighingTime = DateTime.now();
    late Coop coop;

    var isLoading = false.obs;
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
            smartScaleData.value = Get.arguments[1];
            isLoading.value = true;
            getSmartScaleWeighingDetail();
        } catch (exception) {}

        coop = Get.arguments[0];
        outstandingTotalWeighingField.controller.disable();
        // totalWeighing.controller.disable();

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

    /// The function retrieves smart scale weighing details and adds them to a list,
    /// then sets the loading state to false.
    void getSmartScaleWeighingDetail() {
        if (smartScaleData.value != null && smartScaleData.value!.records.isNotEmpty) {
            for (var element in smartScaleData.value!.records) {
                addWeighing(element);
            }
        }

        isLoading.value = false;
    }

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
                                                                Navigator.pop(context);

                                                                // before check is edit or not
                                                                bool isEdit = smartScaleData.value!.id != null;

                                                                if (isEdit) {
                                                                    SmartScaleImpl().getById(smartScaleData.value!.id!).then((record) async {
                                                                        if (record != null) {
                                                                            record.records = smartScaleRecords.entries.map( (entry) => entry.value).toList();
                                                                            record.startDate = Convert.getStringIso(startWeighingTime);
                                                                            record.executionDate = Convert.getStringIso(DateTime.now());
                                                                            record.updatedDate = Convert.getStringIso(DateTime.now());

                                                                            _pushSmartScaleData(auth, isEdit, record);
                                                                        } else {
                                                                            // setting body
                                                                            smartScaleData.value!.id = smartScaleData.value!.id;
                                                                            smartScaleData.value!.records = smartScaleRecords.entries.map( (entry) => entry.value).toList();
                                                                            smartScaleData.value!.roomId = coop.room!.id;
                                                                            smartScaleData.value!.startDate = Convert.getStringIso(startWeighingTime);
                                                                            smartScaleData.value!.updatedDate = Convert.getStringIso(DateTime.now());
                                                                            smartScaleData.value!.executionDate = Convert.getStringIso(DateTime.now());
                                                                            smartScaleData.value!.expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

                                                                            _pushSmartScaleData(auth, isEdit, smartScaleData.value!);
                                                                        }
                                                                    });
                                                                } else {
                                                                    // setting body
                                                                    smartScaleData.value!.records = smartScaleRecords.entries.map( (entry) => entry.value).toList();
                                                                    smartScaleData.value!.roomId = coop.room!.id;
                                                                    smartScaleData.value!.startDate = Convert.getStringIso(startWeighingTime);
                                                                    smartScaleData.value!.executionDate = Convert.getStringIso(DateTime.now());
                                                                    smartScaleData.value!.expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

                                                                    _pushSmartScaleData(auth, isEdit, smartScaleData.value!);
                                                                }
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

    void _saveSmartScaleToDb(SmartScale? data, int flag) {
        if (data != null) {
            data.flag = flag;
            SmartScaleImpl().save(data, keyForCheck: 'id');
        }
    }

    void _pushSmartScaleData(Auth auth, bool isEdit, SmartScale? data) {
        isLoading.value = true;
        Service.push(
            apiKey: "smartScaleApi",
            service: isEdit ? ListApi.updateSmartScale : ListApi.saveSmartScale,
            context: context,
            body: [auth.token, auth.id, Mapper.asJsonString(data), isEdit ? ListApi.pathSmartScaleForDetailAndUpdate(smartScaleData.value!.id!) : null],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    _saveSmartScaleToDb(data, 1);
                    isLoading.value = false;
                    Get.off(SmartScaleDoneSummary(data: data!, coop: coop, startWeighingTime: startWeighingTime));
                },
                onResponseFail: (code, message, body, id, packet) {
                    _saveSmartScaleToDb(data, 0);
                    isLoading.value = false;
                    Get.off(SmartScaleDoneSummary(data: data!, coop: coop, startWeighingTime: startWeighingTime));
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    _saveSmartScaleToDb(data, 0);
                    isLoading.value = false;
                    Get.off(SmartScaleDoneSummary(data: data!, coop: coop, startWeighingTime: startWeighingTime));
                },
                onTokenInvalid: GlobalVar.invalidResponse()
            )
        );
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