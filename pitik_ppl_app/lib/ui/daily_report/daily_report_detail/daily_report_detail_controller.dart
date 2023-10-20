import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DailyReportDetailController extends GetxController {
    BuildContext context;
    DailyReportDetailController({required this.context});
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
class DailyReportDetailBindings extends Bindings {
    BuildContext context;
    DailyReportDetailBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DailyReportDetailController(context: context));
    }
}