import 'dart:convert';
import 'dart:math';

import 'package:common_page/library/component_library.dart';
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/harvest_model.dart';
import 'package:components/multiple_dynamic_form_field/multiple_dynamic_form_field.dart';
import 'package:model/response/left_over_response.dart';

class HarvestSubmittedFormController extends GetxController {
    BuildContext context;
    HarvestSubmittedFormController({required this.context});

    late Coop coop;
    late Harvest harvest;
    late DateTimeField submittedDateField;
    late MultipleDynamicFormField<Harvest> submissionField;

    RxList<EditField> minWeightFieldList = <EditField>[].obs;
    RxList<EditField> maxWeightFieldList = <EditField>[].obs;
    RxList<EditField> totalChickenFieldList = <EditField>[].obs;
    RxList<SpinnerField> reasonFieldList = <SpinnerField>[].obs;

    var isLoading = false.obs;
    var populationPrediction = '- Ekor'.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

        submittedDateField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("harvestSubmissionDateField"),
            flag: DateTimeField.DATE_FLAG,
            label: "Tanggal Pengajuan",
            hint: "20/03/2022",
            alertText: "Oops tanggal pengajuan belum dipilih",
            onDateTimeSelected: (dateTime, field) => field.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        submissionField = MultipleDynamicFormField<Harvest>(
            controller: GetXCreator.putMultipleDynamicFormFieldController<Harvest>("harvestSubmissionField"),
            title: (index) => 'Pengajuan ${index + 1}',
            iconIncrease: const Icon(Icons.add, size: 24, color: GlobalVar.primaryOrange),
            iconDecease: const Icon(Icons.close, size: 24, color: GlobalVar.primaryOrange),
            child: (key) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(child: minWeightFieldList[key]),
                            Text('\ts/d\t', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            Expanded(child: maxWeightFieldList[key])
                        ]
                    ),
                    totalChickenFieldList[key],
                    reasonFieldList[key]
                ],
            ),
            initInstance: Harvest(),
            onIncrease: (controller, index) {
                _increaseCard(index: index);
                return true;
            },
            onDecease: (controller, index) {
                minWeightFieldList.removeAt(index);
                maxWeightFieldList.removeAt(index);
                totalChickenFieldList.removeAt(index);
                reasonFieldList.removeAt(index);

                return true;
            },
            selectedObject: (index) => _getSelectedObject(index)
        );

        _getInitialPopulation();
        Future.delayed(const Duration(milliseconds: 300), () {
            if (Get.arguments.length > 2) {
                harvest = Get.arguments[1];
                _fillData();
            }
        });
    }

    void _fillData() {
        _increaseCard(index: 0, harvest: harvest);
        submittedDateField.controller.setTextSelected(harvest.datePlanned ?? '');
        submissionField.controller.addData(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(child: minWeightFieldList[0]),
                            Text('\ts/d\t', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            Expanded(child: maxWeightFieldList[0])
                        ]
                    ),
                    totalChickenFieldList[0],
                    reasonFieldList[0]
                ],
            ),
            object: harvest,
            index: 0
        );
    }

    void _increaseCard({required int index, Harvest? harvest}) {
        int randomIndex = Random().nextInt(1000000);
        EditField minWeightField = EditField(
            controller: GetXCreator.putEditFieldController("harvestSubmittedMinWeight$randomIndex"),
            label: "",
            hideLabel: true,
            hint: "Ketik di sini",
            alertText: "Oops BW bellum di isi",
            textUnit: "Kg",
            maxInput: 10,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        EditField maxWeightField = EditField(
            controller: GetXCreator.putEditFieldController("harvestSubmittedMaxWeight$randomIndex"),
            label: "",
            hideLabel: true,
            hint: "Ketik di sini",
            alertText: "Harap mengisi jumlah ayam!",
            textUnit: "",
            maxInput: 10,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        EditField totalChickenField = EditField(
            controller: GetXCreator.putEditFieldController("harvestSubmittedTotalChicken$randomIndex"),
            label: "Jumlah Ayam",
            hint: "Ketik di sini",
            alertText: "Oops BW bellum di isi",
            textUnit: "Kg",
            maxInput: 10,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        SpinnerField reasonField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("harvestSubmittedReason$randomIndex"),
            label: "Alasan Panen",
            hint: "Alasan Panen",
            alertText: "Oops alasan panen belum dipilih",
            items: const {"Penjarangan": false, "Panen Normal/Panen Raya": false, "Panen Sakit": false, "Panen Penghabisan Kandang": false, "Afkir": false, "Mendesak": false, "Panen Bertahap": false},
            onSpinnerSelected: (text) {}
        );

        if (harvest != null) {
            minWeightField.setInput('${harvest.minWeight ?? ''}');
            maxWeightField.setInput('${harvest.maxWeight ?? ''}');
            totalChickenField.setInput('${harvest.quantity ?? ''}');
            reasonField.controller.setSelected(harvest.reason ?? '');
        }

        minWeightFieldList.insert(index, minWeightField);
        maxWeightFieldList.insert(index, maxWeightField);
        totalChickenFieldList.insert(index, totalChickenField);
        reasonFieldList.insert(index, reasonField);
    }

    void _getInitialPopulation() => AuthImpl().get().then((auth) {
        if (auth != null) {
            Service.push(
                apiKey: 'farmMonitoringApi',
                service: ListApi.getLeftOver,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop.farmingCycleId}/closing/remaining-population'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as LeftOverResponse).data != null) {
                            populationPrediction.value = '${body.data!.remainingPopulation == null ? '-' : Convert.toCurrencyWithoutDecimal(body.data!.remainingPopulation.toString(), '', '.')} Ekor';
                        }
                    },
                    onResponseFail: (code, message, body, id, packet) {},
                    onResponseError: (exception, stacktrace, id, packet) {},
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    Harvest _getSelectedObject(int index) {
        return Harvest(
            farmingCycleId: coop.farmingCycleId,
            minWeight: minWeightFieldList[index].getInputNumber(),
            maxWeight: maxWeightFieldList[index].getInputNumber(),
            quantity: totalChickenFieldList[index].getInputNumber() != null ? totalChickenFieldList[index].getInputNumber()!.toInt() : null,
            reason: reasonFieldList[index].getController().textSelected.value
        );
    }

    void sendHarvestSubmitted() => AuthImpl().get().then((auth) {
        if (auth != null) {
            if (submissionField.controller.listData.length > 1) {
                _showBottomDialog(auth);
            } else {
                Get.snackbar(
                    "Pesan", "Pengajuan masih kosong, silahkan isi minimal satu pengajuan..!",
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

    _showBottomDialog(Auth auth) {
        return showModalBottomSheet(
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                )
            ),
            isScrollControlled: true,
            context: Get.context!,
            builder: (context) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                            ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                            child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold)),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                children: List.generate(submissionField.controller.listData.length - 1, (index) {
                                    Harvest harvest = submissionField.controller.listData[index];
                                    return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text("Pengajuan ${index + 1}", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, color: GlobalVar.black, fontWeight: GlobalVar.bold)),
                                            const SizedBox(height: 8),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Rentang BW', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    Text(
                                                        '${harvest.minWeight == null ? '-' : harvest.minWeight!.toStringAsFixed(1)} Kg s.d ${harvest.maxWeight == null ? '-' : harvest.maxWeight!.toStringAsFixed(1)} Kg',
                                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                    )
                                                ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Jumlah Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    Text(
                                                        '${harvest.quantity != null ? Convert.toCurrencyWithoutDecimal(harvest.quantity.toString(), '', '.') : '-'} Ekor',
                                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                    )
                                                ],
                                            ),
                                            const SizedBox(height: 16)
                                        ]
                                    );
                                })
                            ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(child: ButtonFill(controller: GetXCreator.putButtonFillController("byHarvestSubmittedYakin"), label: "Yakin", onClick: () {
                                        Get.back();
                                        isLoading.value = true;

                                        List<Harvest> harvestList = [];
                                        for (int i = 0; i < submissionField.controller.listData.length - 1; i++) {
                                            harvestList.add(submissionField.controller.listData[i]);
                                        }

                                        Map<String, dynamic> bodyRequest = {
                                            "datePlanned": submittedDateField.controller.textSelected.value,
                                            "harvestRequests": json.decode(Mapper.asJsonString(harvestList)!)
                                        };

                                        Service.push(
                                            apiKey: 'harvestApi',
                                            service: ListApi.addHarvestRequest,
                                            context: context,
                                            body: ['Bearer ${auth.token}', auth.id, json.encode(bodyRequest)],
                                            listener: ResponseListener(
                                                onResponseDone: (code, message, body, id, packet) {
                                                    isLoading.value = false;
                                                    Get.off(TransactionSuccessActivity(
                                                        keyPage: "harvestSubmitted",
                                                        message: "Pengajuan panen sudah terkirim\nSelanjutnya akan segera diproses",
                                                        showButtonHome: false,
                                                        onTapClose: () => Get.back(),
                                                        onTapHome: () {}
                                                    ));
                                                },
                                                onResponseFail: (code, message, body, id, packet) {
                                                    Get.snackbar("Pesan", '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                                                    isLoading.value = false;
                                                },
                                                onResponseError: (exception, stacktrace, id, packet) {
                                                    Get.snackbar("Pesan", exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                                                    isLoading.value = false;
                                                },
                                                onTokenInvalid: () => GlobalVar.invalidResponse()
                                            )
                                        );
                                    })),
                                    const SizedBox(width: 16),
                                    Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btHarvestSubmittedTidakYakin"), label: "Tidak Yakin", onClick: () => Get.back()))
                                ]
                            )
                        ),
                        const SizedBox(height: GlobalVar.bottomSheetMargin)
                    ]
                )
            )
        );
    }
}

class HarvestSubmittedFormBinding extends Bindings {
    BuildContext context;
    HarvestSubmittedFormBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestSubmittedFormController>(() => HarvestSubmittedFormController(context: context));
}