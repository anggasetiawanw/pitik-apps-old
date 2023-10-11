
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderRequestController extends GetxController {
    BuildContext context;
    OrderRequestController({required this.context});

}

class OrderRequestBinding extends Bindings {
    BuildContext context;
    OrderRequestBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<OrderRequestController>(() => OrderRequestController(context: context));
    }
}