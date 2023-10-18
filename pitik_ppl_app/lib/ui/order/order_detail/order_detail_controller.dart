
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderDetailController extends GetxController {
    BuildContext context;
    OrderDetailController({required this.context});


}

class OrderDetailBinding extends Bindings {
    BuildContext context;
    OrderDetailBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<OrderDetailController>(() => OrderDetailController(context: context));
    }
}