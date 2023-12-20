import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TaskSelfRegistrationController extends GetxController {
    BuildContext context;
    TaskSelfRegistrationController({required this.context});
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
class TaskSelfRegistrationBindings extends Bindings {
    BuildContext context;
    TaskSelfRegistrationBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => TaskSelfRegistrationController(context: context));
    }
}