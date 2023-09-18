import 'package:components/edit_field_two_row/edit_field_two_row.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/stock_opname_two_field/stock_opname_two_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';


class StockOpnameTwoField extends StatelessWidget {
  final StockOpnameTwoFieldController controller;
  final String title;
  const StockOpnameTwoField(
      {super.key, required this.title, required this.controller});

  StockOpnameTwoFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  @override
  Widget build(BuildContext context) {
     Widget buildWidget(EditFieldTwoRow edit){
        return Column(
            children: [
                edit,
                const SizedBox(height: 12,),
                const Divider(height: 1,color: AppColors.outlineColor,),
                const SizedBox(height: 8,),
            ],
        );
    }
    return Obx(() => Container(
        margin: const EdgeInsets.only(top: 16),
      child: Expandable(
            controller: GetXCreator.putAccordionController(title),
            headerText: title,
            child: Column(
              children: controller.efSku.value.map((element) { return buildWidget(element);}).toList(),
            ),
          ),
    ));
  }
}
