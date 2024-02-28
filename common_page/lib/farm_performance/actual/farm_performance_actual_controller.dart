import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 18/12/2023

class FarmPerformanceActualController extends GetxController {
  BuildContext context;
  FarmPerformanceActualController({required this.context});
}

class FarmPerformanceActualBinding extends Bindings {
  BuildContext context;
  FarmPerformanceActualBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<FarmPerformanceActualController>(() => FarmPerformanceActualController(context: context));
}
