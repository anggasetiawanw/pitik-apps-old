
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class PerformanceController extends GetxController {
    BuildContext context;
    PerformanceController({required this.context});

    // final SpinnerField performSpField = SpinnerField(
    //     controller: GetXCreator.putSpinnerFieldController("historyPerformanceSpinner"),
    //     label: "",
    //     hideLabel: true,
    //     hint: "",
    //     alertText: "",
    //     items: const {
    //         "BW": true,
    //         "IP": false,
    //         "FCR": false,
    //         "Mortalitas": false
    //     },
    //     onSpinnerSelected: (text) {
    //
    //     }
    // );

    var isTableShow = false.obs;
    var isLoading = false.obs;

    void generateData(Coop coop) {

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