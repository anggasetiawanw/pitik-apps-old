import 'package:flutter/material.dart';
import 'package:get/get.dart';
class JobController extends GetxController {
    BuildContext context;
    JobController({required this.context});
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
class JobBindings extends Bindings {
    BuildContext context;
    JobBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => JobController(context: context));
    }
}