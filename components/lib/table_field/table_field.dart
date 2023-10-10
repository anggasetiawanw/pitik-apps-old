
// ignore_for_file: must_be_immutable

import 'package:components/table_field/table_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class TableField extends StatelessWidget {
    TableFieldController controller;
    TableField({super.key, required this.controller});

    TableFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        return Obx(() => controller.layout.value);
    }
}