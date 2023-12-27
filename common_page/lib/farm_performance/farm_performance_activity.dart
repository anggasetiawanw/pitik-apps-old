
// ignore_for_file: must_be_immutable

import 'package:common_page/farm_performance/farm_performance_controller.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/farm_projection/farm_projection_detail_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 18/12/2023

class FarmPerformanceActivity extends StatelessWidget {
    FarmPerformanceController controller;
    FarmPerformanceActivity({super.key, required this.controller});
    FarmPerformanceController getController() => Get.find(tag: controller.tag);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Obx(() =>
                    RefreshIndicator(
                        color: GlobalVar.primaryOrange,
                        onRefresh: () => Future.delayed(
                            const Duration(milliseconds: 200), () => controller.refreshData()
                        ),
                        child: NotificationListener<ScrollEndNotification>(
                            onNotification: (scrollEnd) {
                                if (controller.isActual.isTrue) {
                                    final metrics = scrollEnd.metrics;
                                    if (metrics.atEdge && metrics.pixels != 0) {
                                        controller.isLoadMore.value = true;
                                        controller.page.value++;
                                        controller.getPerformHistory(page: controller.page.value);
                                    }
                                }

                                return true;
                            },
                            child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(width: 1, color: GlobalVar.outlineColor),
                                            color: Colors.white
                                        ),
                                        child: Column(
                                            children: [
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                            GestureDetector(
                                                                onTap: () => controller.toActual(),
                                                                child: Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                        color: controller.isActual.isTrue ? GlobalVar.primaryLight2 : Colors.white,
                                                                    ),
                                                                    child: Text('Aktual', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                                )
                                                            ),
                                                            GestureDetector(
                                                                onTap: () => controller.toProjection(),
                                                                child: Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                        color: controller.isActual.isFalse ? GlobalVar.primaryLight2 : Colors.white,
                                                                    ),
                                                                    child: Text('Proyeksi', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                                )
                                                            )
                                                        ]
                                                    ),
                                                ),
                                                const SizedBox(height: 8),
                                                const Divider(height: 2, color: GlobalVar.gray),
                                                const SizedBox(height: 8),
                                                controller.isLoading.isTrue ? Image.asset("images/card_height_450_lazy.gif") : controller.isActual.isTrue ? Padding(
                                                    padding: const EdgeInsets.all(16),
                                                    child: Column(
                                                        children: [
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Text('Data Penting', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                    const SizedBox(width: 8),
                                                                    Text('Angka Saat Ini', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                    const SizedBox(width: 8),
                                                                    Text('Target', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                ]
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Text('Berat rata-rata', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(width: 8),
                                                                    Text(controller.actualAverageWeight.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(width: 8),
                                                                    Text(controller.targetAverageWeight.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                ]
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Text('Mortalitas', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(width: 8),
                                                                    Text(controller.actualMortality.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(width: 8),
                                                                    Text(controller.targetMortality.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                ]
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Text('Konsumsi Pakan\nPer Ayam', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(width: 8),
                                                                    Text(controller.actualConsumption.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(width: 8),
                                                                    Text(controller.targetConsumption.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                ]
                                                            )
                                                        ],
                                                    ),
                                                ) : Column(
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                                GestureDetector(
                                                                    onTap: () => controller.tabProjectionSelected.value = 0,
                                                                    child: Column(
                                                                        children: [
                                                                            Text('Berat', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.tabProjectionSelected.value == 0 ? GlobalVar.primaryOrange : GlobalVar.grayText)),
                                                                            const SizedBox(height: 4),
                                                                            Container(width: (MediaQuery.of(context).size.width - 64) / 6, height: 3, color: controller.tabProjectionSelected.value == 0 ? GlobalVar.primaryOrange : Colors.white)
                                                                        ]
                                                                    )
                                                                ),
                                                                GestureDetector(
                                                                    onTap: () => controller.tabProjectionSelected.value = 1,
                                                                    child: Column(
                                                                        children: [
                                                                            Text('FCR', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.tabProjectionSelected.value == 1 ? GlobalVar.primaryOrange : GlobalVar.grayText)),
                                                                            const SizedBox(height: 4),
                                                                            Container(width: (MediaQuery.of(context).size.width - 64) / 6, height: 3, color: controller.tabProjectionSelected.value == 1 ? GlobalVar.primaryOrange : Colors.white)
                                                                        ]
                                                                    )
                                                                ),
                                                                GestureDetector(
                                                                    onTap: () => controller.tabProjectionSelected.value = 2,
                                                                    child: Column(
                                                                        children: [
                                                                            Text('Mortalitas', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: controller.tabProjectionSelected.value == 2 ? GlobalVar.primaryOrange : GlobalVar.grayText)),
                                                                            const SizedBox(height: 4),
                                                                            Container(width: (MediaQuery.of(context).size.width - 64) / 6, height: 3, color: controller.tabProjectionSelected.value == 2 ? GlobalVar.primaryOrange : Colors.white)
                                                                        ]
                                                                    ),
                                                                )
                                                            ]
                                                        ),
                                                        const SizedBox(height: 8),
                                                        const Divider(height: 2, color: GlobalVar.gray),
                                                        const SizedBox(height: 8),
                                                        Padding(
                                                            padding: const EdgeInsets.all(16),
                                                            child: Column(
                                                                children: [
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                            Text('Proyeksi Sekarang\n(Hari ke ${
                                                                                controller.tabProjectionSelected.value == 0 ? controller.getDayNum(data: controller.projectionData.value!.weight) :
                                                                                controller.tabProjectionSelected.value == 1 ? controller.getDayNum(data: controller.projectionData.value!.fcr) :
                                                                                controller.getDayNum(data: controller.projectionData.value!.mortality)
                                                                            })', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center),
                                                                            const SizedBox(width: 16),
                                                                            Text('Proyeksi Sekarang\n(Hari ke ${
                                                                                controller.tabProjectionSelected.value == 0 ? controller.getDayNum(data: controller.projectionData.value!.weight, isCurrent: false) :
                                                                                controller.tabProjectionSelected.value == 1 ? controller.getDayNum(data: controller.projectionData.value!.fcr, isCurrent: false) :
                                                                                controller.getDayNum(data: controller.projectionData.value!.mortality)
                                                                            })', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center)
                                                                        ]
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            SizedBox(
                                                                                width: (MediaQuery.of(context).size.width - 72) / 2,
                                                                                child: SfCartesianChart(
                                                                                    isTransposed: true,
                                                                                    enableAxisAnimation: true,
                                                                                    primaryXAxis: NumericAxis(isVisible: false),
                                                                                    series: <BarSeries<FarmProjectionDetail?, dynamic>>[
                                                                                        BarSeries<FarmProjectionDetail?, dynamic>(
                                                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                                                                            color: GlobalVar.primaryOrange,
                                                                                            animationDuration: 400,
                                                                                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                                                            dataSource: [
                                                                                                controller.tabProjectionSelected.value == 0 ? controller.projectionData.value!.weight :
                                                                                                controller.tabProjectionSelected.value == 1 ? controller.projectionData.value!.fcr :
                                                                                                controller.projectionData.value!.mortality
                                                                                            ],
                                                                                            xValueMapper: (FarmProjectionDetail? data, _) => 1,
                                                                                            yValueMapper: (FarmProjectionDetail? data, _) => data == null ? 0 : data.topGraph!.current!.current,
                                                                                        ),
                                                                                        BarSeries<FarmProjectionDetail?, dynamic>(
                                                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                                                                            color: GlobalVar.primaryLight2,
                                                                                            animationDuration: 400,
                                                                                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                                                            dataSource: [
                                                                                                controller.tabProjectionSelected.value == 0 ? controller.projectionData.value!.weight :
                                                                                                controller.tabProjectionSelected.value == 1 ? controller.projectionData.value!.fcr :
                                                                                                controller.projectionData.value!.mortality
                                                                                            ],
                                                                                            xValueMapper: (FarmProjectionDetail? data, _) => 2,
                                                                                            yValueMapper: (FarmProjectionDetail? data, _) => data == null ? 0 : data.topGraph!.current!.benchmark,
                                                                                        )
                                                                                    ]
                                                                                ),
                                                                            ),
                                                                            SizedBox(
                                                                                width: (MediaQuery.of(context).size.width - 72) / 2,
                                                                                child: SfCartesianChart(
                                                                                    isTransposed: true,
                                                                                    enableAxisAnimation: true,
                                                                                    primaryXAxis: NumericAxis(isVisible: false),
                                                                                    series: <BarSeries<FarmProjectionDetail?, dynamic>>[
                                                                                        BarSeries<FarmProjectionDetail?, dynamic>(
                                                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                                                                            color: GlobalVar.primaryOrange,
                                                                                            animationDuration: 400,
                                                                                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                                                            dataSource: [
                                                                                                controller.tabProjectionSelected.value == 0 ? controller.projectionData.value!.weight :
                                                                                                controller.tabProjectionSelected.value == 1 ? controller.projectionData.value!.fcr :
                                                                                                controller.projectionData.value!.mortality
                                                                                            ],
                                                                                            xValueMapper: (FarmProjectionDetail? data, _) => 1,
                                                                                            yValueMapper: (FarmProjectionDetail? data, _) => data == null ? 0 : data.topGraph!.projected!.current,
                                                                                        ),
                                                                                        BarSeries<FarmProjectionDetail?, dynamic>(
                                                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                                                                            color: GlobalVar.primaryLight2,
                                                                                            animationDuration: 400,
                                                                                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                                                            dataSource: [
                                                                                                controller.tabProjectionSelected.value == 0 ? controller.projectionData.value!.weight :
                                                                                                controller.tabProjectionSelected.value == 1 ? controller.projectionData.value!.fcr :
                                                                                                controller.projectionData.value!.mortality
                                                                                            ],
                                                                                            xValueMapper: (FarmProjectionDetail? data, _) => 2,
                                                                                            yValueMapper: (FarmProjectionDetail? data, _) => data == null ? 0 : data.topGraph!.projected!.benchmark,
                                                                                        )
                                                                                    ]
                                                                                ),
                                                                            )
                                                                        ]
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                            Text(
                                                                                controller.tabProjectionSelected.value == 0 ? controller.getWeek(controller.projectionData.value!.weight) :
                                                                                controller.tabProjectionSelected.value == 1 ? controller.getWeek(controller.projectionData.value!.fcr) :
                                                                                controller.getWeek(controller.projectionData.value!.mortality),
                                                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center
                                                                            ),
                                                                            const SizedBox(width: 16),
                                                                            Text('Panen', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center)
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                            Column(
                                                                                children: [
                                                                                    Row(
                                                                                        children: [
                                                                                            Container(
                                                                                                width: 20,
                                                                                                height: 8,
                                                                                                decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                                                    color: GlobalVar.primaryOrange
                                                                                                )
                                                                                            ),
                                                                                            const SizedBox(width: 8),
                                                                                            Text('Aktual (gram)', style: GlobalVar.subTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText))
                                                                                        ]
                                                                                    ),
                                                                                    const SizedBox(height: 4),
                                                                                    Row(
                                                                                        children: [
                                                                                            Container(
                                                                                                width: 20,
                                                                                                height: 8,
                                                                                                decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                                                    color: GlobalVar.primaryLight2
                                                                                                )
                                                                                            ),
                                                                                            const SizedBox(width: 8),
                                                                                            Text('Target (gram)', style: GlobalVar.subTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText))
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            ),
                                                                            const SizedBox(width: 16),
                                                                            Column(
                                                                                children: [
                                                                                    Row(
                                                                                        children: [
                                                                                            Container(
                                                                                                width: 20,
                                                                                                height: 8,
                                                                                                decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                                                    color: GlobalVar.primaryOrange
                                                                                                )
                                                                                            ),
                                                                                            const SizedBox(width: 8),
                                                                                            Text('Aktual (gram)', style: GlobalVar.subTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText))
                                                                                        ]
                                                                                    ),
                                                                                    const SizedBox(height: 4),
                                                                                    Row(
                                                                                        children: [
                                                                                            Container(
                                                                                                width: 20,
                                                                                                height: 8,
                                                                                                decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                                                    color: GlobalVar.primaryLight2
                                                                                                )
                                                                                            ),
                                                                                            const SizedBox(width: 8),
                                                                                            Text('Target (gram)', style: GlobalVar.subTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.grayText))
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    ]
                                                )
                                            ]
                                        )
                                    ),
                                    const SizedBox(height: 16),
                                    controller.isActual.isTrue && controller.isLoading.isFalse ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    border: Border.all(width: 1, color: GlobalVar.outlineColor),
                                                    color: Colors.white
                                                ),
                                                child: Column(
                                                    children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('Siklus', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                                const SizedBox(width: 8),
                                                                Text(controller.cycleDate.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            ]
                                                        ),
                                                        const SizedBox(height: 16),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('FCR', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                const SizedBox(width: 8),
                                                                Text(controller.fcr.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            ]
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('Mortalitas ', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                const SizedBox(width: 8),
                                                                Text(controller.mortality.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            ]
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('Proyeksi IP  ', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                const SizedBox(width: 8),
                                                                Text(controller.ipProjection.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                            ]
                                                        )
                                                    ]
                                                )
                                            ),
                                            const SizedBox(height: 16),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text('Performa Hasi Sebelumnya', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                    const SizedBox(width: 8),
                                                    Text('Tanggal Chickin ${controller.coop.value == null ? '-' : controller.coop.value!.startDate ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                ],
                                            ),
                                            const SizedBox(height: 16),
                                            Column(
                                                children: List.generate(controller.farmPerformanceHistory.length, (index) => Padding(
                                                    padding: const EdgeInsets.only(bottom: 16),
                                                    child: Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                            border: Border.all(width: 1, color: GlobalVar.outlineColor),
                                                            color: Colors.white
                                                        ),
                                                        child: Column(
                                                            children: [
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Text('Hari ke ${controller.farmPerformanceHistory[index]!.day ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                                        const SizedBox(width: 8),
                                                                        Text(controller.farmPerformanceHistory[index]!.date ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                                    ]
                                                                ),
                                                                const SizedBox(height: 16),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Text('Perkiraan populasi', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(width: 8),
                                                                        Text(controller.farmPerformanceHistory[index]!.estimatedPopulation == null ? '-' : controller.farmPerformanceHistory[index]!.estimatedPopulation!.toStringAsFixed(0), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    ]
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Text('FCR s/d hari ${controller.farmPerformanceHistory[index]!.day ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(width: 8),
                                                                        Text(controller.farmPerformanceHistory[index]!.fcr == null ? '-' : controller.farmPerformanceHistory[index]!.fcr!.toStringAsFixed(1), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    ]
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Text('Berat rata-rata', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(width: 8),
                                                                        Text(controller.farmPerformanceHistory[index]!.abw == null ? '-' : controller.farmPerformanceHistory[index]!.abw!.toStringAsFixed(1), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    ]
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Text('Jumlah ayam mati', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(width: 8),
                                                                        Text(controller.farmPerformanceHistory[index]!.mortality == null ? '-' : controller.farmPerformanceHistory[index]!.mortality!.toStringAsFixed(0), style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    ]
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Text('Jumlah konsumsi pakan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                        const SizedBox(width: 8),
                                                                        Text(controller.farmPerformanceHistory[index]!.feedConsumption == null ? '-' : '${controller.farmPerformanceHistory[index]!.feedConsumption!.toStringAsFixed(0)} Karung', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                    )
                                                ))
                                            )
                                        ],
                                    ) : const SizedBox(),
                                    controller.isLoadMore.isTrue ? const Center(child: CircularProgressIndicator(color: GlobalVar.primaryOrange)) : const SizedBox(),
                                    const SizedBox(height: 60)
                                ]
                            )
                        )
                    )
                )
            )
        );
    }
}