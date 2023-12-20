
// ignore_for_file: must_be_immutable

import 'package:common_page/farm_performance/farm_performance_controller.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 18/12/2023

class FarmPerformanceActivity extends GetView<FarmPerformanceController> {
    const FarmPerformanceActivity({super.key});

    @override
    Widget build(BuildContext context) {
        final FarmPerformanceController controller = Get.put(FarmPerformanceController(context: context));

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
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(width: 1, color: GlobalVar.outlineColor),
                                            color: Colors.white
                                        ),
                                        child: Column(
                                            children: [
                                                Row(
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
                                                const SizedBox(height: 8),
                                                const Divider(height: 2, color: GlobalVar.gray),
                                                const SizedBox(height: 8),
                                                controller.isLoading.isTrue ? Image.asset("images/card_height_450_lazy.gif") : controller.isActual.isTrue ? Column(
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
                                                ) : const SizedBox()
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