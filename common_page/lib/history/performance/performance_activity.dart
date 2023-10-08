
// ignore_for_file: must_be_immutable

import 'package:common_page/history/performance/performance_controller.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
                            // Padding(
                            //     padding: const EdgeInsets.only(left: 16, right: 16),
                            //     child: SizedBox(
                            //         width: 170,
                            //         child: controller.performSpField,
                            //     ),
                            // ),
                            Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: GestureDetector(
                                    onTap: () => controller.isTableShow.value = true,
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            color: GlobalVar.primaryLight2
                                        ),
                                        child: Row(
                                            children: [
                                                Text('Table', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                const SizedBox(width: 8),
                                                SvgPicture.asset('images/table_icon.svg')
                                            ],
                                        ),
                                    )
                                )
                            )
                        ]
                    ),
                    const SizedBox(height: 12),
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
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
                                    decoration: BoxDecoration(
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
                        thumbColor: GlobalVar.primaryOrange,
                        radius: const Radius.circular(8),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(),
                        )
                    ),
                    const SizedBox(height: 16),
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(width: 1, color: GlobalVar.outlineColor)
                            ),
                            child: Column(
                                children: [

                                ]
                            )
                        )
                    )
                ],
            )
        );
    }
}