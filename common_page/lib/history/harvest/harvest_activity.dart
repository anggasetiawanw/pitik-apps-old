
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'harvest_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HarvestActivity extends GetView<HarvestController> {
    const HarvestActivity({super.key});

    @override
    Widget build(BuildContext context) => Obx(() => controller.tableLayout.value);
}