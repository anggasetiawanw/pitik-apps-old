// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages

import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';

import '../global_var.dart';
import 'edit_field_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class EditField extends StatelessWidget {
  EditFieldController controller;
  String label;
  String hint;
  String alertText;
  String textUnit;
  String? textPrefix;
  Widget? childPrefix;
  int maxInput;
  bool hideLabel;
  double width;
  TextInputType inputType;
  TextInputAction action;
  double height;
  bool isNumberFormatter;
  Function(String, EditField) onTyping;
  CrossAxisAlignment crossAxisAlignment;

  EditField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.alertText,
      required this.textUnit,
      required this.maxInput,
      this.inputType = TextInputType.text,
      this.action = TextInputAction.done,
      this.hideLabel = false,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      required this.onTyping,
      this.width = double.infinity,
      this.textPrefix,
      this.childPrefix,
      this.height = 50,
      this.isNumberFormatter = false});

  late String data;
  bool onInit = true;

  final editFieldController = TextEditingController();
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter(
    enableNegative: false,
    locale: 'id',
    decimalDigits: 0,
    symbol: '',
  );
  EditFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  void setInput(String text) {
    if (textPrefix == AppStrings.PREFIX_CURRENCY_IDR) {
      var split = text.split(".");
      editFieldController.text = _formatter.format(split[0]);
    } else if (isNumberFormatter) {
      editFieldController.text = _formatter.format(text);
    } else {
      editFieldController.text = text;
    }
  }

  String getInput() {
    return editFieldController.text;
  }

  double? getInputNumber() {
    if (textPrefix == AppStrings.PREFIX_CURRENCY_IDR || isNumberFormatter) {
      return Convert.toDouble(editFieldController.text.replaceAll(AppStrings.PREFIX_CURRENCY_IDR, "").replaceAll(".", ""));
    }
    return Convert.toDouble(editFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      if (inputType == TextInputType.number) {
        inputType = const TextInputType.numberWithOptions(decimal: true);
      }
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      if (onInit) {
        controller.textUnit.value = textUnit;
        controller.hideLabel.value = hideLabel;
        onInit = false;
      }
    });

    final labelField = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(color: GlobalVar.black, fontSize: 14),
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
                            height: height,
                            child: TextFormField(
                              expands: inputType == TextInputType.multiline ? false : false,
                              maxLines: inputType == TextInputType.multiline ? 5 : 1,
                              // focusNode: controller.focusNode,
                              controller: editFieldController,
                              enabled: controller.activeField.isTrue,
                              maxLength: maxInput,
                              textInputAction: action,
                              keyboardType: inputType,
                              inputFormatters: textPrefix == AppStrings.PREFIX_CURRENCY_IDR || isNumberFormatter
                                  ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9.,]')), _formatter]
                                  : inputType == TextInputType.number
                                      ? [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))]
                                      : [],
                              onChanged: (text) {
                                controller.hideAlert();
                                onTyping(text, this);
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                counterText: "",
                                hintText: hint,
                                hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9D9D)),
                                prefixIcon: childPrefix ??
                                    (textPrefix != null
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Center(
                                              child: Text("$textPrefix", style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 14)),
                                            ),
                                          )
                                        : null),
                                suffixIcon: Container(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: Text(controller.textUnit.value, style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 14)),
                                ),
                                fillColor: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: controller.activeField.isTrue && controller.showTooltip.isFalse
                                        ? GlobalVar.primaryOrange
                                        : controller.activeField.isTrue && controller.showTooltip.isTrue
                                            ? GlobalVar.red
                                            : Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: GlobalVar.gray),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: controller.activeField.isTrue && controller.showTooltip.isFalse
                                          ? GlobalVar.primaryLight
                                          : controller.activeField.isTrue && controller.showTooltip.isTrue
                                              ? GlobalVar.red
                                              : Colors.white,
                                      width: 2.0,
                                    )),
                                filled: true,
                              ),
                            ),
                          ),
                          controller.showTooltip.isTrue
                              ? Container(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset("images/error_icon.svg")),
                                      Expanded(
                                        child: Text(
                                          controller.alertText.value.isNotEmpty ? controller.alertText.value : alertText,
                                          style: const TextStyle(color: GlobalVar.red, fontSize: 12),
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ],
                                  ))
                              : Container()
                        ],
                      ))
                ],
              ),
            )
          : Container(),
    );
  }
}
