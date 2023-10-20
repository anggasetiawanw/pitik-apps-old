import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DailyReportHomeController extends GetxController {
    BuildContext context;
    DailyReportHomeController({required this.context});

    var isLoadingList = false.obs;
    ScrollController scrollController= ScrollController();

    // @override
    // void onInit() {
    //     super.onInit();
    // }
    // @override
    // void onReady() {
    //     super.onReady();
    // }
    // @override
    // void onClose() {
    //     super.onClose();
    // }
}
class DailyReportHomeBindings extends Bindings {
    BuildContext context;
    DailyReportHomeBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DailyReportHomeController(context: context));
    }
}