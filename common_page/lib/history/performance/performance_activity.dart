
// ignore_for_file: must_be_immutable

import 'package:common_page/history/performance/performance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class PerformanceActivity extends GetView<PerformanceController> {
    Coop coop;
    PerformanceActivity({super.key, required this.coop});

    @override
    Widget build(BuildContext context) {
        final PerformanceController controller = Get.put(PerformanceController(
            context: context,
            coop: coop
        ));

        return Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    ],
                )
            ],
        );
    }
}