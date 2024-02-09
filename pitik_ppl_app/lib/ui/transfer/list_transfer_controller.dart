
// ignore_for_file: constant_identifier_names

import 'package:components/button_fill/button_fill.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/procurement_model.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ListTransferController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    ListTransferController({required this.context});

    late TabController tabController;
    late Coop coop;

    var isLoading = false.obs;
    RxList<Procurement?> transferList = <Procurement?>[].obs;

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_panen_page_transfer');
        coop = Get.arguments;

        tabController = TabController(vsync: this, length: 2);
        tabController.addListener(() {
            if (tabController.index == 0) {
                TransferCommon.getListSend(coop: coop, isLoading: isLoading, destinationTransferList: transferList);
            } else {
                TransferCommon.getListReceived(coop: coop, isLoading: isLoading, destinationTransferList: transferList);
            }
        });

        TransferCommon.getListSend(coop: coop, isLoading: isLoading, destinationTransferList: transferList);
    }

    void refreshTransferList() {
        if (tabController.index == 0) {
            TransferCommon.getListSend(coop: coop, isLoading: isLoading, destinationTransferList: transferList);
        } else {
            TransferCommon.getListReceived(coop: coop, isLoading: isLoading, destinationTransferList: transferList);
        }
    }

    void showMenuBottomSheet() {
        DateTimeField fromDateField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("filterTransferFromDateField"), label: "Tanggal Dari", hint: "Pilih tanggal", alertText: "Tanggal harus dipilih..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        DateTimeField untilDateField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("filterTransferUntilDateField"), label: "Tanggal Sampai", hint: "Pilih tanggal", alertText: "Tanggal harus dipilih..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        SpinnerField typeField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("filterTransferTypeField"), label: "Jenis Transfer", hint: "Pilih salah satu", alertText: "Harus pilih jenis..!", items: const {"Pakan": false, "OVK": false},
            onSpinnerSelected: (textSelected) {}
        );

        showModalBottomSheet(
            backgroundColor: Colors.white,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                )
            ),
            isScrollControlled: true,
            context: Get.context!,
            builder: (context) => Container(
                color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            children: [
                                Center(
                                    child: Container(
                                        width: 60,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: GlobalVar.outlineColor
                                        )
                                    )
                                ),
                                const SizedBox(height: 16),
                                fromDateField,
                                untilDateField,
                                typeField,
                                const SizedBox(height: 50),
                                ButtonFill(controller: GetXCreator.putButtonFillController("btnFilterTransferList"), label: "Konfirmasi Filter", onClick: () {
                                    bool isPass = true;

                                    if (fromDateField.getController().textSelected.isEmpty) {
                                        fromDateField.getController().showAlert();
                                        isPass = false;
                                    }
                                    if (untilDateField.getController().textSelected.isEmpty) {
                                        untilDateField.getController().showAlert();
                                        isPass = false;
                                    }
                                    if (typeField.getController().textSelected.isEmpty) {
                                        typeField.getController().showAlert();
                                        isPass = false;
                                    }

                                    if (isPass) {
                                        Navigator.pop(Get.context!);
                                        if (tabController.index == 0) {
                                            TransferCommon.getListSend(
                                                coop: coop,
                                                isLoading: isLoading,
                                                destinationTransferList: transferList,
                                                type: typeField.getController().textSelected.value.toLowerCase(),
                                                fromDate: fromDateField.getLastTimeSelectedText(),
                                                untilDate: untilDateField.getLastTimeSelectedText()
                                            );
                                        } else {
                                            TransferCommon.getListReceived(
                                                coop: coop,
                                                isLoading: isLoading,
                                                destinationTransferList: transferList,
                                                type: typeField.getController().textSelected.value.toLowerCase(),
                                                fromDate: fromDateField.getLastTimeSelectedText(),
                                                untilDate: untilDateField.getLastTimeSelectedText()
                                            );
                                        }
                                    }
                                }),
                                const SizedBox(height: 32),
                            ]
                        )
                    )
                )
            )
        );
    }
}

class ListTransferBinding extends Bindings {
    BuildContext context;
    ListTransferBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ListTransferController>(() => ListTransferController(context: context));
    }
}