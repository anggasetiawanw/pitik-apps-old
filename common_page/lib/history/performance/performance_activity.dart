
// ignore_for_file: must_be_immutable

import 'package:common_page/history/performance/performance_controller.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_active_standard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class PerformanceActivity extends GetView<PerformanceController> {
    const PerformanceActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Column(
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            controller.isTableShow.isFalse ? Padding(
                                padding: const EdgeInsets.only(left: 16, top: 16),
                                child: SizedBox(
                                    width: 170,
                                    child: controller.performSpField,
                                ),
                            ) : const SizedBox(),
                            Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                child: GestureDetector(
                                    onTap: () {
                                        if (controller.isTableShow.isTrue) {
                                            controller.isTableShow.value = false;
                                        } else {
                                            controller.isTableShow.value = true;
                                        }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: GlobalVar.primaryLight2
                                        ),
                                        child: Row(
                                            children: [
                                                Text(controller.isTableShow.isFalse ? 'Table' : 'Grafik', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                const SizedBox(width: 8),
                                                controller.isTableShow.isFalse ? SvgPicture.asset('images/table_icon.svg') : SvgPicture.asset('images/graph_icon.svg')
                                            ],
                                        ),
                                    )
                                )
                            )
                        ]
                    ),
                    const SizedBox(height: 12),
                    controller.isTableShow.isFalse ? Column(
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                                color: GlobalVar.primaryOrange,
                                                shape: BoxShape.circle
                                            ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text('Aktual', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                        const SizedBox(width: 16),
                                        Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                                color: GlobalVar.headerSku,
                                                shape: BoxShape.circle
                                            ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text('Standar', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                    ]
                                )
                            ),
                            const SizedBox(height: 16),
                            RawScrollbar(
                                thumbVisibility: true,
                                thumbColor: GlobalVar.primaryOrange,
                                radius: const Radius.circular(8),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                        width: controller.getBarWidth(MediaQuery.of(context).size.width),
                                        height: 220,
                                        child: SfCartesianChart(
                                            isTransposed: true,
                                            enableAxisAnimation: true,
                                            primaryXAxis: CategoryAxis(
                                                axisLabelFormatter: (AxisLabelRenderDetails args) {
                                                    int index = (args.value).toInt();
                                                    String label = controller.barData[index]!.actual == 0 && controller.barData[index]!.standard == 0 ? '' : '${controller.barData[index]!.day}';
                                                    return ChartAxisLabel(label, GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black));
                                                },
                                                labelStyle: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                            ),
                                            series: <BarSeries<CoopActiveStandard?, dynamic>>[
                                                BarSeries<CoopActiveStandard?, dynamic>(
                                                    width: 0.5,
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                                                    color: GlobalVar.primaryOrange,
                                                    dataSource: controller.barData,
                                                    xValueMapper: (CoopActiveStandard? data, _) => data!.day,
                                                    yValueMapper: (CoopActiveStandard? data, _) => data!.actual,
                                                ),
                                                BarSeries<CoopActiveStandard?, dynamic>(
                                                    width: 0.5,
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                                                    color: Colors.transparent,
                                                    dataSource: controller.barData,
                                                    xValueMapper: (CoopActiveStandard? data, _) => data!.day,
                                                    yValueMapper: (CoopActiveStandard? data, _) => data!.standard,
                                                ),
                                                BarSeries<CoopActiveStandard?, dynamic>(
                                                    width: 0.5,
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                                                    color: GlobalVar.primaryLight4,
                                                    dataSource: controller.barData,
                                                    xValueMapper: (CoopActiveStandard? data, _) => data!.day,
                                                    yValueMapper: (CoopActiveStandard? data, _) => data!.standard,
                                                ),
                                            ],
                                        ),
                                    ),
                                )
                            ),
                            const SizedBox(height: 16),
                            Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                                child: Container(
                                    width: MediaQuery.of(context).size.width - 32,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        border: Border.all(width: 1, color: GlobalVar.outlineColor)
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Performa Setiap Hari', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                    controller.datePerformanceField.value
                                                ],
                                            ),
                                            Text(
                                                'Hari ${controller.detailPerformance.value == null || controller.detailPerformance.value!.day == null ? '-' : controller.detailPerformance.value!.day}',
                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                            ),
                                            const SizedBox(height : 16),
                                            Row(    // CREATE HEADER
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    SizedBox(
                                                        width: (MediaQuery.of(Get.context!).size.width / 2) * 0.3,
                                                        child: Text('Variabel', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                                    ),
                                                    SizedBox(
                                                        width: (MediaQuery.of(Get.context!).size.width / 2) * 0.3,
                                                        child: Text('Saat Ini', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                                    ),
                                                    SizedBox(
                                                        width: (MediaQuery.of(Get.context!).size.width / 2) * 0.3,
                                                        child: Text('Standar', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                                    )
                                                ],
                                            ),
                                            _createAttributeDetail(
                                                variable: 'BW',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.bw == null ? null : controller.detailPerformance.value!.bw!.actual,
                                                standard: controller.detailPerformance.value == null || controller.detailPerformance.value!.bw == null ? null : controller.detailPerformance.value!.bw!.standard
                                            ),
                                            _createAttributeDetail(
                                                variable: 'ADG',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.adg == null ? null : controller.detailPerformance.value!.adg!.actual,
                                                standard: controller.detailPerformance.value == null || controller.detailPerformance.value!.adg == null ? null : controller.detailPerformance.value!.adg!.standard,
                                                isSub: true
                                            ),
                                            _createAttributeDetail(
                                                variable: 'IP',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.ip == null ? null : controller.detailPerformance.value!.ip!.actual,
                                                standard: controller.detailPerformance.value == null || controller.detailPerformance.value!.ip == null ? null : controller.detailPerformance.value!.ip!.standard
                                            ),
                                            _createAttributeDetail(
                                                variable: 'FCR',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.fcr == null ? null : controller.detailPerformance.value!.fcr!.actual,
                                                standard: controller.detailPerformance.value == null || controller.detailPerformance.value!.fcr == null ? null : controller.detailPerformance.value!.fcr!.standard
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Feed Intake',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.feedIntake == null ? null : controller.detailPerformance.value!.feedIntake!.actual,
                                                standard: controller.detailPerformance.value == null || controller.detailPerformance.value!.feedIntake == null ? null : controller.detailPerformance.value!.feedIntake!.standard,
                                                isSub: true
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Mortality',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.mortality == null ? null : controller.detailPerformance.value!.mortality!.actual,
                                                standard: controller.detailPerformance.value == null || controller.detailPerformance.value!.mortality == null ? null : controller.detailPerformance.value!.mortality!.standard
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Total Populasi',
                                                current: controller.detailPerformance.value == null ||
                                                    controller.detailPerformance.value!.population == null ||
                                                    controller.detailPerformance.value!.population!.total == null ? null :
                                                controller.detailPerformance.value!.population!.total!.toDouble(),
                                                standard: null
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Sisa Populasi',
                                                current: controller.detailPerformance.value == null ||
                                                    controller.detailPerformance.value!.population == null ||
                                                    controller.detailPerformance.value!.population!.remaining == null ? null :
                                                controller.detailPerformance.value!.population!.remaining!.toDouble(),
                                                standard: null,
                                                isSub: true
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Total Panen',
                                                current: controller.detailPerformance.value == null ||
                                                    controller.detailPerformance.value!.population == null ||
                                                    controller.detailPerformance.value!.population!.harvested == null ? null :
                                                controller.detailPerformance.value!.population!.harvested!.toDouble(),
                                                standard: null,
                                                isSub: true
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Total Kematian',
                                                current: controller.detailPerformance.value == null ||
                                                    controller.detailPerformance.value!.population == null ||
                                                    controller.detailPerformance.value!.population!.mortality == null ? null :
                                                controller.detailPerformance.value!.population!.mortality!.toDouble(),
                                                standard: null,
                                                isSub: true
                                            ),
                                            _createAttributeDetail(
                                                variable: 'Sisa Pakan',
                                                current: controller.detailPerformance.value == null || controller.detailPerformance.value!.feed == null ? null : controller.detailPerformance.value!.feed!.remaining,
                                                standard: null,
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(
                                                        child: Row(
                                                            children: [
                                                                const SizedBox(width: 4),
                                                                Container(
                                                                    width: 2,
                                                                    height: 2,
                                                                    decoration: const BoxDecoration(
                                                                        color: GlobalVar.black,
                                                                        shape: BoxShape.circle
                                                                    ),
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Text('Perkiraan Habis', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                            ],
                                                        )
                                                    ),
                                                    Expanded(
                                                        child: Text(controller.getFeedDatePrediction(), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black), textAlign: TextAlign.center,)
                                                    ),
                                                    Expanded(
                                                        child: Text('-', textAlign: TextAlign.end, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black))
                                                    )
                                                ],
                                            )
                                        ]
                                    )
                                )
                            )
                        ],
                    ) : Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: controller.tableLayout.value,
                    )
                ],
            )
        );
    }

    Widget _createAttributeDetail({String? variable, double? current, double? standard, bool isSub = false}) {
        return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(
                        child: isSub ? Row(
                            children: [
                                const SizedBox(width: 4),
                                Container(
                                    width: 2,
                                    height: 2,
                                    decoration: const BoxDecoration(
                                        color: GlobalVar.black,
                                        shape: BoxShape.circle
                                    ),
                                ),
                                const SizedBox(width: 4),
                                Text(variable ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                            ],
                        ) : Text(variable ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                    ),
                    Expanded(
                        child: Text(
                            current == null ? '-' : Convert.toCurrencyWithoutDecimal(current.toStringAsFixed(0), '', '.'),
                            textAlign: TextAlign.center,
                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black),
                        ),
                    ),
                    Expanded(
                        child: Text(
                            standard == null ? '-' : Convert.toCurrencyWithoutDecimal(standard.toStringAsFixed(0), '', '.'),
                            textAlign: TextAlign.end,
                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                        )
                    )
                ],
            ),
        );
    }
}