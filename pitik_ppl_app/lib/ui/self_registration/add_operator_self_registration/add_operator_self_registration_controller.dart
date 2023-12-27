import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AddOperatorSelfRegistrationController extends GetxController {
    BuildContext context;
    AddOperatorSelfRegistrationController({required this.context});
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
class AddOperatorSelfRegistrationBindings extends Bindings {
    BuildContext context;
    AddOperatorSelfRegistrationBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => AddOperatorSelfRegistrationController(context: context));
    }
}