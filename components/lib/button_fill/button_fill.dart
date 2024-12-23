// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'button_fill_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ButtonFill extends StatelessWidget {
  ButtonFillController controller;
  String label;
  double width;
  bool isHaveIcon;
  Widget imageAsset;
  Function() onClick;

  ButtonFill({super.key, this.width = double.infinity, required this.controller, required this.label, this.isHaveIcon = false, this.imageAsset = const SizedBox(), required this.onClick});

  ButtonFillController getController() {
    return Get.find(tag: controller.tag);
  }

  bool onInit = true;

  @override
  Widget build(BuildContext context) {
    if (onInit) {
      onInit = false;
      controller.changeLabel(label);
    }
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          width: width,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.activeField.isTrue ? onClick : () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray,
              foregroundColor: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.gray,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isHaveIcon
                ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 11),
                    imageAsset
                  ])
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Obx(
                        () => Text(
                          controller.label.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
