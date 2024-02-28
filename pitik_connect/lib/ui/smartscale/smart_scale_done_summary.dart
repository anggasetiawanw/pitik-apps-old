// ignore_for_file: must_be_immutable, slash_for_doc_comments

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

import 'list_smart_scale/list_smart_scale_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.idd>
/// @create date 11/09/2023

class SmartScaleDoneSummary extends StatelessWidget {
  SmartScale data;
  Coop coop;
  DateTime startWeighingTime;
  SmartScaleDoneSummary({super.key, required this.data, required this.coop, required this.startWeighingTime});

  int _getTotalChicken() {
    int count = 0;
    for (var element in data.records) {
      count += element!.count!;
    }
    return count;
  }

  double _getTonase() {
    double count = 0.0;
    for (var element in data.records) {
      count += element!.weight!;
    }
    return count;
  }

  double _getAverageWeight() {
    int i;
    double sumWeight = 0;
    int sumChicken = 0;
    for (i = 0; i < data.records.length; i++) {
      sumWeight = sumWeight + data.records[i]!.weight!;
      sumChicken = sumChicken + data.records[i]!.count!;
    }

    return sumWeight / sumChicken;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime endWeighingTime = Convert.getDatetime(data.executionDate!);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ListView(shrinkWrap: true, children: [
                Image.asset(
                  "images/check_orange_icon.gif",
                  height: 150,
                  width: 150,
                ),
                Text("Timbang ayam telah selesai, berikut adalah rangkumannya", textAlign: TextAlign.center, style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange)),
                const SizedBox(height: 24),
                Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: GlobalVar.grayBackground),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Hasil Penimbangan", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mulai Timbang", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                              Text("${Convert.getYear(startWeighingTime)}/${Convert.getMonthNumber(startWeighingTime)}/${Convert.getDay(startWeighingTime)} - ${Convert.getHour(startWeighingTime)}.${Convert.getMinute(startWeighingTime)}",
                                  style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Selesai Timbang", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                              Text("${Convert.getYear(endWeighingTime)}/${Convert.getMonthNumber(endWeighingTime)}/${Convert.getDay(endWeighingTime)} - ${Convert.getHour(endWeighingTime)}.${Convert.getMinute(endWeighingTime)}",
                                  style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Ayam", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                              Text("${_getTotalChicken()} Ekor", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Tonase", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                              Text("${_getTonase().toStringAsFixed(2)} kg", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Berat Rata-Rata", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                              Text("${_getAverageWeight().toStringAsFixed(2)} kg", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ButtonOutline(
                              controller: GetXCreator.putButtonOutlineController("copySmartScaleSummary"),
                              label: "Salin",
                              isHaveIcon: true,
                              imageAsset: 'images/copy_orange_icon.svg',
                              onClick: () => Clipboard.setData(ClipboardData(
                                      text: "Hasil Data timbang Kandang ${coop.coopName} _ Lantai ${coop.room!.level}\n"
                                          "Waktu Mulai\t ${Convert.getYear(startWeighingTime)}/${Convert.getMonthNumber(startWeighingTime)}/${Convert.getDay(startWeighingTime)} - ${Convert.getHour(startWeighingTime)}.${Convert.getMinute(startWeighingTime)}\n"
                                          "Waktu Selesai\t ${Convert.getYear(endWeighingTime)}/${Convert.getMonthNumber(endWeighingTime)}/${Convert.getDay(endWeighingTime)} - ${Convert.getHour(endWeighingTime)}.${Convert.getMinute(endWeighingTime)}\n"
                                          "Total Ayam\t ${_getTotalChicken()} Ekor\n"
                                          "Total Tonase\t ${_getTonase().toStringAsFixed(2)} kg\n"
                                          "Berat Rata-rata\t ${_getAverageWeight().toStringAsFixed(2)} kg"))
                                  .then((value) => Get.snackbar(
                                        "Pesan",
                                        "Berhasil menyalin..!",
                                        snackPosition: SnackPosition.TOP,
                                        colorText: Colors.white,
                                        backgroundColor: GlobalVar.primaryOrange,
                                      )))
                        ]))),
                const SizedBox(height: 32),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: ButtonFill(
                        controller: GetXCreator.putButtonFillController("btnSmartScaleSummaryClose"),
                        label: "Tutup",
                        onClick: () {
                          ListSmartScaleController controllerListSmartScale = Get.find<ListSmartScaleController>();
                          controllerListSmartScale.pageSmartScale.value = 1;
                          controllerListSmartScale.getSmartScaleListData(isPull: true);
                          Get.back();
                        }))
              ])
            ])));
  }
}
