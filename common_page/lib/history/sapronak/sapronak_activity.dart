
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'sapronak_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class SapronakActivity extends GetView<SapronakController> {
    Coop coop;
    SapronakActivity({super.key, required this.coop});

    @override
    Widget build(BuildContext context) {
        final SapronakController controller = Get.put(SapronakController(
            context: context,
            coop: coop
        ));

        return Column(
            children: [

            ],
        );
    }
}