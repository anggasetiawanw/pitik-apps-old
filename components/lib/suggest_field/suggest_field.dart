// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, must_be_immutable, use_key_in_widget_constructors, annotate_overrides, overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'suggest_field_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SuggestField extends StatelessWidget {

    SuggestFieldController controller;

    int id;
    String label;
    String hint;
    String alertText;
    bool hideLabel = false;
    Widget? childPrefix;
    List<String> suggestList;
    Function(String) onTyping;
    Function(String) onSubmitted;

    SuggestField({required this.controller, this.id = 1, required this.label, required this.hint, required this.alertText, this.childPrefix, required this.suggestList,
                  required this.onTyping, required this.onSubmitted});

    SuggestFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    var suggestFieldController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        controller.generateItems(suggestList);

        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: const TextStyle(color: GlobalVar.black, fontSize: 14),
            ),
        );

        return Obx(() =>
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse ? labelField : Container(),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: Autocomplete<String>(
                                            optionsBuilder: (TextEditingValue textEditingValue) async {
                                                controller.hideAlert();
                                                List<String> result = [];
                                                for (var value in controller.suggestList) {
                                                    if (value.contains(textEditingValue.text)) {
                                                        result.add(value);
                                                    }
                                                }

                                                controller.selectedObject = null;
                                                onTyping(textEditingValue.text);
                                                return result;
                                            },
                                            onSelected: (text) {
                                                // for selected object
                                                if (controller.listObject.isNotEmpty) {
                                                    for (int i = 0; i < controller.suggestList.length; i++) {
                                                        if (text == controller.suggestList[i]) {
                                                            controller.selectedObject = controller.listObject[i];
                                                            break;
                                                        }
                                                    }
                                                }

                                                onTyping(text);
                                                onSubmitted(text);
                                            },
                                            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                                controller.textEditingController.value = textEditingController;
                                                return TextFormField(
                                                    controller: controller.textEditingController.value,
                                                    focusNode: focusNode,
                                                    onFieldSubmitted: (str) => onFieldSubmitted(),
                                                    decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.only(left: 8),
                                                        counterText: "",
                                                        hintText: hint,
                                                        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9E9D9D)),
                                                        fillColor: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                                        prefixIcon: childPrefix,
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            borderSide: BorderSide(
                                                                color: controller.activeField.isTrue && controller.showTooltip.isFalse ? GlobalVar.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white, width: 2.0,
                                                            )
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            borderSide: const BorderSide(color:GlobalVar.primaryLight)
                                                        ),
                                                        filled: true,
                                                    )
                                                );
                                            },
                                        )
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
                                                    Text(
                                                        alertText,
                                                        style: const TextStyle(color: GlobalVar.red, fontSize: 12)
                                                    )
                                                ]
                                            )
                                        ) : Container()
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}