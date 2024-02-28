import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_summary_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 03/11/2023

class SmartMonitorController extends GetxController {
  BuildContext context;
  SmartMonitorController({required this.context});

  late Coop coop;
  late DeviceSummary deviceSummary;
  late String deviceIdForController;
  late String coopIdForController;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    deviceSummary = Get.arguments[1];
    deviceIdForController = Get.arguments[2];
    coopIdForController = Get.arguments[3];
  }
}

class SmartMonitorControllerBinding extends Bindings {
  BuildContext context;
  SmartMonitorControllerBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<SmartMonitorController>(() => SmartMonitorController(context: context));
}
