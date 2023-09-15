// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import '../library/engine_library.dart';
import 'switch_button_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SwitchButton extends StatelessWidget {
    SwitchButtonController controller;
    String label;
    String hint;
    String alertText;
    String textUnit;
    String? textPrefix;
    int maxInput;
    bool hideLabel;
    double width;
    TextInputType inputType;
    TextInputAction action;
    Function(bool, SwitchButton) onChanged;

    SwitchButton({super.key, required this.controller, required this.label, required this.hint, required this.alertText, required this.textUnit, required this.maxInput, this.inputType = TextInputType.text,
                  this.action = TextInputAction.done, this.hideLabel = false, required this.onChanged, this.width = double.infinity, this.textPrefix});

    late String data;
    final editFieldController = TextEditingController();

    SwitchButtonController getController() {
        return Get.find(tag: controller.tag);
    }

    void setInput(String text) {
        editFieldController.text = text;
    }

    String getInput() {
        return editFieldController.text;
    }

    bool getValue() {
        return controller.light.value;
    }

    double? getInputNumber() {
        return Convert.toDouble(editFieldController.text);
    }
    @override
    Widget build(BuildContext context) {
        final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            // Track color when the switch is selected.
            if (states.contains(MaterialState.selected)) {
                return Colors.amber;
            }
            // Otherwise return null to set default track color
            // for remaining states such as when the switch is
            // hovered, focused, or disabled.
            return null;
        });

        final MaterialStateProperty<Color?> overlayColor =
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            // Material color when switch is selected.
            if (states.contains(MaterialState.selected)) {
                return Colors.amber.withOpacity(0.54);
            }
            // Material color when switch is disabled.
            if (states.contains(MaterialState.disabled)) {
                return Colors.grey.shade400;
            }
            // Otherwise return null to set default material color
            // for remaining states such as when the switch is
            // hovered, or focused.
            return null;
        });

        return Obx(() =>
            controller.showField.isTrue ?
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                    height: 48,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: const BoxDecoration(
                        color:Color(0xFFFEEFD2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Row(
                                children: [
                                    Text(
                                        label,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: GlobalVar.black, fontSize: 14),),
                                    controller.activeField.isTrue ?
                                    Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                            controller.light.value == true ? "Aktif" : "Non-Aktif",
                                            textAlign : controller.activeField.isFalse ? TextAlign.right : TextAlign.left,
                                            style: TextStyle(color: controller.light.value == true ? const Color(0xFF14CB82) : GlobalVar.red, fontSize: 14),),
                                    ) : Container()
                                ],
                            ),
                            controller.activeField.isTrue ?
                            Switch(
                                value: controller.light.value,
                                overlayColor: overlayColor,
                                trackColor: trackColor,
                                thumbColor: const MaterialStatePropertyAll<Color>(Color(0xFFF47B20)),

                                onChanged: (bool value) {
                                // controller.hideAlert();
                                controller.light.value = value;
                                controller.switchValue.value = value == true ? "Aktif" : "Non-Aktif";
                                },
                            ) : Text(
                                controller.light.value == true ? "Aktif" : "Non-Aktif",
                                textAlign : controller.activeField.isFalse ? TextAlign.right : TextAlign.left,
                                style: TextStyle(color: controller.light.value == true ? const Color(0xFF14CB82) : GlobalVar.red, fontSize: 14)
                            ),
                        ]
                    )
              )
            ) : Container()
        );
    }
}
