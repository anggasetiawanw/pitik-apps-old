import 'package:flutter/material.dart';
import 'package:get/get.dart';
class NotificationController extends GetxController {
    BuildContext context;
    NotificationController({required this.context});
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

class NotificationBindings extends Bindings {
    BuildContext context;
    NotificationBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => NotificationController(context: context));
    }
}