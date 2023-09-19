// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';

import 'edit_field_two_row_controller.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

class EditFieldTwoRow extends StatelessWidget {
    EditFieldTwoRowController controller;
    String label;
    String hint;
    String alertText;
    String textUnit1;
    String textUnit2;
    String? textPrefix1;
    String? textPrefix2;
    int maxInput;
    bool hideLabel;
    double width;
    TextInputType inputType;
    TextInputAction action;
    Function(String, EditFieldTwoRow) onTyping1;
    Function(String, EditFieldTwoRow) onTyping2;

    EditFieldTwoRow({super.key, required this.controller, required this.label, required this.hint, required this.alertText, required this.textUnit1,required this.textUnit2, required this.maxInput, this.inputType = TextInputType.text,
               this.action = TextInputAction.done, this.hideLabel = false, required this.onTyping1, required this.onTyping2, this.width = double.infinity, this.textPrefix1, this.textPrefix2});

    late String data;
    final editFieldTwoRowController1 = TextEditingController();
    final editFieldTwoRowController2 = TextEditingController();

    EditFieldTwoRowController getController() {
        return Get.find(tag: controller.tag);
    }

    void setInput1(String text) {
        editFieldTwoRowController1.text = text;
    }

    String getInput1() {
        return editFieldTwoRowController1.text;
    }

    double? getInputNumber1() {
        return Convert.toDouble(editFieldTwoRowController1.text);
    }

    void setInput2(String text) {
        editFieldTwoRowController2.text = text;
    }

    String getInput2() {
        return editFieldTwoRowController2.text;
    }

    double? getInputNumber2() {
        return Convert.toDouble(editFieldTwoRowController2.text);
    }
    @override
    Widget build(BuildContext context) {
        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(color: AppColors.black, fontSize: 14),
            ),
        );

        return Obx(
            () => controller.showField.isTrue
                ? Padding(
                    key: controller.formKey,
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                        children: <Widget>[
                            controller.hideLabel.isFalse ? labelField : Container(),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 8, top: 8),
                                child: Column(
                                    children: <Widget>[
                                        Row(
                                            children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    //   width: width,
                                                      height: 50,
                                                      child: TextFormField(
                                                          focusNode: controller.focusNode1,
                                                          controller: editFieldTwoRowController1,
                                                          enabled: controller.activeField.isTrue,
                                                          maxLength: maxInput,
                                                          textInputAction: action,
                                                          keyboardType: inputType,
                                                          inputFormatters: inputType == TextInputType.number? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))] :  [],
                                                          onChanged: (text) {
                                                              controller.hideAlert();
                                                              onTyping1(text, this);
                                                          },
                                                          decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.only(left: 8),
                                                              counterText: "",
                                                              hintText: hint,
                                                              hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF9E9D9D)),
                                                              prefixIcon: textPrefix1 != null ? Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: Text("$textPrefix2",
                                                                      style: TextStyle(color: controller.activeField.isTrue ? AppColors.primaryOrange : AppColors.black, fontSize: 14)),
                                                              ): null,
                                                              suffixIcon: Padding(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: Text(textUnit1,
                                                                      style: TextStyle(color: controller.activeField.isTrue ? AppColors.primaryOrange : AppColors.black, fontSize: 14)),
                                                              ),
                                                              fillColor: controller.activeField.isTrue ? AppColors.primaryLight : AppColors.grey,
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  borderSide: BorderSide(
                                                                      color: controller.activeField.isTrue && controller.showTooltip.isFalse ? AppColors.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue ? AppColors.red : Colors.white,
                                                                      width: 2.0,
                                                                  ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  borderSide: const BorderSide(color: AppColors.grey),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  borderSide: const BorderSide(color: AppColors.primaryLight)
                                                              ),
                                                              filled: true,
                                                          ),
                                                      ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16,),
                                                Expanded(
                                                  child: SizedBox(
                                                    //   width: width,
                                                      height: 50,
                                                      child: TextFormField(
                                                          focusNode: controller.focusNode2,
                                                          controller: editFieldTwoRowController2,
                                                          enabled: controller.activeField.isTrue,
                                                          maxLength: maxInput,
                                                          textInputAction: action,
                                                          keyboardType: inputType,
                                                          inputFormatters: inputType == TextInputType.number? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))] :  [],
                                                          onChanged: (text) {
                                                              controller.hideAlert();
                                                              onTyping2(text, this);
                                                          },
                                                          decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.only(left: 8),
                                                              counterText: "",
                                                              hintText: hint,
                                                              hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF9E9D9D)),
                                                              prefixIcon: textPrefix2 != null ? Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: Text("$textPrefix2",
                                                                      style: TextStyle(color: controller.activeField.isTrue ? AppColors.primaryOrange : AppColors.black, fontSize: 14)),
                                                              ): null,
                                                              suffixIcon: Padding(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: Text(textUnit2,
                                                                      style: TextStyle(color: controller.activeField.isTrue ? AppColors.primaryOrange : AppColors.black, fontSize: 14)),
                                                              ),
                                                              fillColor: controller.activeField.isTrue ? AppColors.primaryLight : AppColors.grey,
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  borderSide: BorderSide(
                                                                      color: controller.activeField.isTrue && controller.showTooltip.isFalse ? AppColors.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue ? AppColors.red : Colors.white,
                                                                      width: 2.0,
                                                                  ),
                                                              ),
                                                              disabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  borderSide: const BorderSide(color: AppColors.grey),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  borderSide: const BorderSide(color: AppColors.primaryLight)
                                                              ),
                                                              filled: true,
                                                          ),
                                                      ),
                                                  ),
                                                ),
                                            ],
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
                                                              style: const TextStyle(color: AppColors.red, fontSize: 12),
                                                              overflow: TextOverflow.clip,
                                                          ),
                                                        )
                                                    ],
                                                )           )
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
