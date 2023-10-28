import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/stock_opname_field/stock_opname_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockOpnameField extends StatelessWidget {
  final StockOpnameFieldController controller;
  final String title;
  const StockOpnameField({super.key, required this.title, required this.controller});

  StockOpnameFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  @override
  Widget build(BuildContext context) {
    controller.title.value = title;
    return Obx(() => Container(
          margin: const EdgeInsets.only(top: 16),
          child: Expandable(
            controller: GetXCreator.putAccordionController(controller.title.value),
            headerText: controller.title.value,
            child: Column(
              children: controller.efSku.value,
            ),
          ),
        ));
  }
}
