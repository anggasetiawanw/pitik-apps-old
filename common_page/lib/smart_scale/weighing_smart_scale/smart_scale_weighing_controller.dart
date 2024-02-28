// ignore_for_file: slash_for_doc_comments, empty_catches, unused_import, depend_on_referenced_packages

import 'package:app_settings/app_settings.dart';
import 'package:common_page/smart_scale/bundle/smart_scale_weighing_bundle.dart';
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
    late SmartScaleWeighingBundle bundle;

    var isLoading = false.obs;
    var weighingValue = "".obs;
    var batteryStatus = "".obs;
    var isTimeout = true.obs;
    var numberList = 0.obs;
    var pageSelected = 1.obs;

    RxList<int> index = RxList<int>([]);
    RxList<int> numberLabel = RxList<int>([]);
    Rx<SmartScale?> smartScaleData = (SmartScale()).obs;
    RxMap<int, SmartScaleRecord> smartScaleRecords = <int, SmartScaleRecord>{}.obs;
    RxMap<int, Widget> smartScaleDataWidget = <int, Widget>{}.obs;
    RxMap<int, Widget> smartScaleDataWidgetNumber = <int, Widget>{}.obs;
    Rx<Row> paginationNumber = (const Row()).obs;
    RxList<List<Row>> paginationWidget = <List<Row>>[].obs;
    BluetoothLeService? bluetoothLeService;

    final EditField totalWeighingField = EditField(controller: GetXCreator.putEditFieldController("totalWeighingFieldSmartScale"), label: "Jumlah Ditimbang", hint: "Ketik disini..!", alertText: "Harus isi jumlah ditimbang..!",
        textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
        onTyping: (text, editField) {}
    );

    final EditField outstandingTotalWeighingField = EditField(controller: GetXCreator.putEditFieldController("outstandingTotalWeighingFieldSmartScale"), label: "Sisa Belum Ditimbang", hint: "", alertText: "",
        textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
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
                count -= value.count ?? 0;
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
        smartScaleRecords.refresh();
        _generateNumberList();
        generatePaginationNumber();
        getSmartScaleDataWidget();
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
                    section: idx,
                    count: totalChicken.getInputNumber()!.toInt(),
                    weight: totalWeighing.getInputNumber(),
                    totalCount: totalChicken.getInputNumber()!.toInt(),
                    totalWeight: totalWeighing.getInputNumber()
                );
            }
            smartScaleRecords.putIfAbsent(idx, () => smartScaleRecord);

            final EditField totalChick = EditField(controller: GetXCreator.putEditFieldController("totalChickenAdd$idx"), label: "", hint: "", alertText: "", hideLabel: true,
                textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
                onTyping: (text, editField) {}
            );

            final EditField totalWeight = EditField(controller: GetXCreator.putEditFieldController("totalWeighingAdd$idx"), label: "", hint: "", alertText: "", hideLabel: true,
                textUnit: "kg", inputType: TextInputType.number, maxInput: 10,
                onTyping: (text, editField) {}
            );

            totalChick.setInput('${smartScaleRecord.count ?? smartScaleRecord.totalCount ?? ''}');
            totalWeight.setInput('${smartScaleRecord.weight ?? smartScaleRecord.totalWeight ?? ''}');

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
            smartScaleRecords.refresh();
            _generateNumberList();
            generatePaginationNumber();
            getSmartScaleDataWidget();
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
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
            smartScaleData.value = Get.arguments[2];
            isLoading.value = true;
            getSmartScaleWeighingDetail();
        } catch (exception) {}

        coop = Get.arguments[0];
        bundle = Get.arguments[1];
        outstandingTotalWeighingField.controller.disable();
        totalWeighing.controller.disable();

        bluetoothLeService = BluetoothLeService().timeout(true, 5).start(BluetoothLeConstant.TEXT_RESULT, ['PTK-SCL'], BluetoothLeCallback(
            onLeReceived: (data) {
                isTimeout.value = false;
                weighingValue.value = data.substring(0, data.lastIndexOf('-'));
                batteryStatus.value = data.substring(data.lastIndexOf('-') + 1, data.length - 1);

                totalWeighing.setInput(weighingValue.value);
            },
            onDisabled: () => AppSettings.openAppSettings(type: AppSettingsType.bluetooth),
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
        } else if (smartScaleData.value != null && smartScaleData.value!.details.isNotEmpty) {
            for (var element in smartScaleData.value!.details) {
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
                    // count tonnage & quantity
                    double tonnage  = 0;
                    int quantity = 0;

                    smartScaleRecords.forEach((key, value) {
                        tonnage += value.weight ?? 0;
                        quantity += value.count ?? 0;
                    });

                    showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Container(
                                                width: 60,
                                                height: 4,
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
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
                                        const SizedBox(height: 8),
                                        Text("Timbang Ayam", style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Jumlah Ditimbang", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                const SizedBox(width: 8),
                                                Text('$quantity Ekor', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Tonase", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                const SizedBox(width: 8),
                                                Text('${tonnage.toStringAsFixed(2)} Kg', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(color: GlobalVar.outlineColor),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Kolom", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                const SizedBox(width: 8),
                                                Text("Jumlah Ayam", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                const SizedBox(width: 8),
                                                Text("Tonase", style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Expanded(
                                            child: RawScrollbar(
                                                thumbVisibility: true,
                                                thumbColor: GlobalVar.primaryOrange,
                                                radius: const Radius.circular(8),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(right: 12),
                                                    child: ListView(
                                                        children: smartScaleRecords.entries.map((e) => Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('${e.key}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                                const SizedBox(width: 8),
                                                                Text('${e.value.count ?? e.value.totalCount}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                                const SizedBox(width: 8),
                                                                Text('${e.value.weight ?? e.value.totalWeight}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                            ]
                                                        )).toList()
                                                    ),
                                                )
                                            )
                                        ),
                                        const SizedBox(height: 16),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 24, bottom: 32),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(
                                                        child: ButtonFill(
                                                            controller: GetXCreator.putButtonFillController("bfYesSaveSmartScaleWeighing"),
                                                            label: "Ya",
                                                            onClick: () => _pushSmartScaleData()
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

    void _saveSmartScaleToDb(int flag) {
        if (smartScaleData.value != null) {
            smartScaleData.value!.flag = flag;
            SmartScaleImpl().save(smartScaleData.value!, keyForCheck: 'id');
        }
    }

    void _pushSmartScaleData() => AuthImpl().get().then((auth) async {
        Navigator.pop(context);
        if (auth != null) {
            isLoading.value = true;
            bool isEdit = smartScaleData.value!.id != null;

            Service.push(
                apiKey: "smartScaleApi",
                service: isEdit ? bundle.routeEdit() : bundle.routeSave(),
                context: Get.context!,
                body: await bundle.getBodyRequest(this, auth, isEdit),
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if (bundle.saveToDb) {
                            _saveSmartScaleToDb(1);
                        }
                        isLoading.value = false;

                        if (bundle.onGetSubmitResponse != null) {
                            bundle.onGetSubmitResponse!(body);
                        }
                        Get.off(SmartScaleDoneSummary(data: smartScaleData.value!, coop: coop, startWeighingTime: startWeighingTime));
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                            "Pesan", "Koneksi terputus. Data akan terupdate jika koneksi kembali.",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                        );

                        if (bundle.saveToDb) {
                            _saveSmartScaleToDb(0);
                        }
                        isLoading.value = false;

                        if (bundle.onGetSubmitResponse != null) {
                            bundle.onGetSubmitResponse!(body);
                        }
                        Get.off(SmartScaleDoneSummary(data: smartScaleData.value!, coop: coop, startWeighingTime: startWeighingTime));
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        _saveSmartScaleToDb(0);
                        Get.snackbar(
                            "Pesan", "Koneksi terputus. Data akan terupdate jika koneksi kembali.",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                        );

                        if (bundle.saveToDb) {
                            _saveSmartScaleToDb(0);
                        }
                        isLoading.value = false;

                        if (bundle.onGetSubmitResponse != null) {
                            bundle.onGetSubmitResponse!([exception, stacktrace]);
                        }
                        Get.off(SmartScaleDoneSummary(data: smartScaleData.value!, coop: coop, startWeighingTime: startWeighingTime));
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void generatePaginationNumber() {
        if (smartScaleRecords.isNotEmpty) {
            paginationNumber.value = Row(
                children: List.generate((smartScaleRecords.length / 10).ceil(), (index) {
                    return GestureDetector(
                        onTap: () {
                            pageSelected.value = index + 1;
                            generatePaginationNumber();
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('${index + 1}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: pageSelected.value == index + 1 ? GlobalVar.primaryOrange : GlobalVar.gray))
                        ),
                    );
                }),
            );
        }
    }

    void getSmartScaleDataWidget() {
        if (smartScaleDataWidget.isNotEmpty) {
            paginationWidget.clear();

            int idx = 0;
            int page = 0;
            List<Row> data = [];
            smartScaleDataWidget.forEach((key, value) {
                if (idx == 10) {
                    page++;
                    paginationWidget.add([]);
                    data = [];

                    data.add(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                smartScaleDataWidgetNumber[key]!,
                                Expanded(child: smartScaleDataWidget[key]!)
                            ],
                        )
                    );

                    paginationWidget.insert(page, data);
                    idx = 1;
                } else {
                    data.add(
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                smartScaleDataWidgetNumber[key]!,
                                Expanded(child: smartScaleDataWidget[key]!)
                            ],
                        )
                    );

                    paginationWidget.insert(page, data);
                    idx++;
                }
            });
        }
    }
}

class SmartScaleWeighingBinding extends Bindings {

    BuildContext context;
    SmartScaleWeighingBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartScaleWeighingController>(() => SmartScaleWeighingController(context: context));
}