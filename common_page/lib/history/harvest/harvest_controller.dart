import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class HarvestController extends GetxController {
    BuildContext context;
    Coop? coop;
    HarvestController({required this.context, this.coop});

    void generateData() {

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