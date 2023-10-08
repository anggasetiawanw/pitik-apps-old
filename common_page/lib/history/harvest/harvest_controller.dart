import 'dart:async';

import 'package:common_page/library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:components/table_field/table_field.dart';
import 'package:engine/util/array_util.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HarvestController extends GetxController {
    BuildContext context;
    Coop? coop;
    HarvestController({required this.context, this.coop});

    var isLoading = false.obs;
    Rx<TableField> tableLayout = (TableField(controller: GetXCreator.putTableFieldController("harvestTable"))).obs;

    void generateData() {
        isLoading.value = true;
        Timer(const Duration(seconds: 5), () {
            List<List<String>> data = [
                ["Tanggal Realisasi", "No DO", "Bakul", "No Timbang", "Total Ayam", "Total Tonase", "Rata-rata"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
                ["1", "2", "3", "4", "5", "6", "7"],
            ];

            tableLayout.value.controller.generateData(data: ArrayUtil().transpose<String>(data), useSticky: true, heightData: 45);
            isLoading.value = false;
        });
    }
}

class HarvestBinding extends Bindings {
    BuildContext context;
    HarvestBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<HarvestController>(() => HarvestController(context: context));
    }
}