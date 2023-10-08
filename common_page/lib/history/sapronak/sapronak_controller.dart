import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class SapronakController extends GetxController {
    BuildContext context;
    Coop? coop;
    SapronakController({required this.context, this.coop});

    void generateData() {

    }
}

class SapronakBinding extends Bindings {
    BuildContext context;
    SapronakBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SapronakController>(() => SapronakController(context: context));
    }
}