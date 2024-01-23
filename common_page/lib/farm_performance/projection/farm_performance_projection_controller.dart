
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 18/12/2023

class FarmPerformanceProjectionController extends GetxController {
    BuildContext context;
    FarmPerformanceProjectionController({required this.context});
}

class FarmPerformanceProjectionBinding extends Bindings {
    BuildContext context;
    FarmPerformanceProjectionBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<FarmPerformanceProjectionController>(() => FarmPerformanceProjectionController(context: context));
}