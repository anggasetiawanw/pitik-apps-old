import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
class DailyReportHomeController extends GetxController {
    BuildContext context;
    DailyReportHomeController({required this.context});

    var isLoadingList = false.obs;
    ScrollController scrollController= ScrollController();

    late Coop coop;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments;
    }
}
class DailyReportHomeBindings extends Bindings {
    BuildContext context;
    DailyReportHomeBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DailyReportHomeController(context: context));
    }
}