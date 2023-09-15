// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import '../library/engine_library.dart';
import 'edit_field_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class EditField extends StatelessWidget {
    EditFieldController controller;
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
    Function(String, EditField) onTyping;
    CrossAxisAlignment crossAxisAlignment;

    EditField({super.key, required this.controller, required this.label, required this.hint, required this.alertText, required this.textUnit, required this.maxInput, this.inputType = TextInputType.text,
               this.action = TextInputAction.done, this.hideLabel = false, this.crossAxisAlignment = CrossAxisAlignment.start, required this.onTyping, this.width = double.infinity, this.textPrefix});

    late String data;
    final editFieldController = TextEditingController();

    EditFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    void setInput(String text) {
        editFieldController.text = text;
    }

    String getInput() {
        return editFieldController.text;
    }

    double? getInputNumber() {
        return Convert.toDouble(editFieldController.text);
    }
    @override
    Widget build(BuildContext context) {
        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(color: GlobalVar.black, fontSize: 14),
            ),
        );

        return Obx(
            () => controller.showField.isTrue
                ? Padding(
                    key: controller.formKey,
                    padding: controller.hideLabel.isFalse ? const EdgeInsets.only(top: 16) : EdgeInsets.zero,
                    child: Column(
                        children: <Widget>[
                            controller.hideLabel.isFalse ? labelField : const SizedBox(),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 8, top: 8),
                                child: Column(
                                    crossAxisAlignment: crossAxisAlignment,
                                    children: <Widget>[
                                        SizedBox(
                                            width: width,
                                            height: 50,
                                            child: TextFormField(
                                                // focusNode: controller.focusNode,
                                                controller: editFieldController,
                                                enabled: controller.activeField.isTrue,
                                                maxLength: maxInput,
                                                textInputAction: action,
                                                keyboardType: inputType,
                                                inputFormatters: inputType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))] :  [],
                                                onChanged: (text) {
                                                    controller.hideAlert();
                                                    onTyping(text, this);
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.only(left: 8),
                                                    counterText: "",
                                                    hintText: hint,
                                                    hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9D9D)),
                                                    prefixIcon: textPrefix != null ? Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Text(
                                                          "$textPrefix",
                                                          style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 14)),
                                                    ): null,
                                                    suffixIcon: Padding(
                                                        padding: const EdgeInsets.all(16),
                                                        child: Text(
                                                            textUnit,
                                                            style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 14)
                                                        ),
                                                    ),
                                                    fillColor: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: controller.activeField.isTrue && controller.showTooltip.isFalse ? GlobalVar.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white,
                                                            width: 2.0,
                                                        ),
                                                    ),
                                                    disabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        borderSide: BorderSide(color: GlobalVar.gray),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        borderSide: BorderSide(color: GlobalVar.primaryLight)
                                                    ),
                                                    filled: true,
                                                ),
                                            ),
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: controller.showTooltip.isTrue
                                                ? Container(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Row(
                                                    children: [
                                                        Padding(
                                                            padding: const EdgeInsets.only(right: 8),
                                                            child: SvgPicture.asset("images/error_icon.svg")
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              controller.alertText.value.isNotEmpty ? controller.alertText.value : alertText,
                                                              style: TextStyle(color: GlobalVar.red, fontSize: 12),
                                                              overflow: TextOverflow.clip,
                                                          ),
                                                        )
                                                    ],
                                                )
                                            )
                                            : Container(),
                                        )
                                    ],
                                )
                            )
                        ],
                    ),
                )
            : Container(),
        );
    }
}
