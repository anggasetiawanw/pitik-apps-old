import 'package:components/stock_opname_two_field/stock_opname_two_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockOpnameTwoField extends StatelessWidget {
  final StockOpnameTwoFieldController controller;
  final String title;
  const StockOpnameTwoField({super.key, required this.title, required this.controller});

  StockOpnameTwoFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  @override
  Widget build(BuildContext context) {
    controller.title.value = title;
    return Obx(() => Container(
          margin: const EdgeInsets.only(top: 16),
          child: controller.exp,
        ));
  }
}
