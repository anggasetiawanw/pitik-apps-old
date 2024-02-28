// ignore_for_file: must_be_immutable, slash_for_doc_comments

import 'package:components/check_box/check_box_controller.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class CheckBoxField extends StatelessWidget {
  CheckBoxController controller;
  String title;
  Function(CheckBoxController) onTap;
  CheckBoxField({super.key, required this.controller, required this.title, required this.onTap});

  CheckBoxController getController() => Get.find(tag: controller.tag);

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
        onTap: () {
          if (onTap(controller) == null) {
            if (controller.isChecked.isTrue) {
              controller.unchecked();
              onTap(controller);
            } else {
              controller.checked();
              onTap(controller);
            }
          } else {
            controller.isChecked.value = onTap(controller);
          }
        },
        child: Row(children: [
          Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration:
                BoxDecoration(border: Border.fromBorderSide(BorderSide(color: controller.isChecked.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray, width: 2)), color: controller.isChecked.isTrue ? GlobalVar.primaryOrange : Colors.transparent),
            child: controller.isChecked.isTrue ? const Icon(Icons.check, color: Colors.white, size: 17) : const SizedBox(),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)))
        ])));
  }
}
