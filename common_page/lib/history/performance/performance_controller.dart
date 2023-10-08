import 'package:common_page/library/component_library.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class PerformanceController extends GetxController {
    BuildContext context;
    Coop? coop;
    PerformanceController({required this.context, this.coop});

    late SpinnerField performSpField = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("performSpField"),
        label: "",
        hideLabel: true,
        hint: "",
        alertText: "",
        items: [],
        onSpinnerSelected: (text) {

        }
    );

    void generateData() {

    }
}

class PerformanceBinding extends Bindings {
    BuildContext context;
    PerformanceBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<PerformanceController>(() => PerformanceController(context: context));
    }
}