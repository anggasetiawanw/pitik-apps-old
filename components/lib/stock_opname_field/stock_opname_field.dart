import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/stock_opname_field/stock_opname_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockOpnameField extends StatelessWidget {
  final StockOpnameFieldController controller;
  final String title;
  const StockOpnameField(
      {super.key, required this.title, required this.controller});

  StockOpnameFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        margin: EdgeInsets.only(top: 16),
      child: Expandable(
            controller: GetXCreator.putAccordionController(title),
            headerText: title,
            child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: controller.efSku.value,
                )),
          ),
    ));
  }
}
