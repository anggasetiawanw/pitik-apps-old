
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'harvest_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HarvestActivity extends GetView<HarvestController> {
    Coop coop;
    HarvestActivity({super.key, required this.coop});

    @override
    Widget build(BuildContext context) {
        final HarvestController controller = Get.put(HarvestController(
            context: context,
            coop: coop
        ));

        return Column(
            children: [

            ],
        );
    }
}