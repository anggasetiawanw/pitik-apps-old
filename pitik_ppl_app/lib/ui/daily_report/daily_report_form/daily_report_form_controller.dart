import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DailyReportFormController extends GetxController {
    BuildContext context;
    DailyReportFormController({required this.context});
    @override
    void onInit() {
        super.onInit();
    }
    @override
    void onReady() {
        super.onReady();
    }
    @override
    void onClose() {
        super.onClose();
    }
}
class DailyReportFormBindings extends Bindings {
    BuildContext context;
    DailyReportFormBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DailyReportFormController(context: context));
    }
}