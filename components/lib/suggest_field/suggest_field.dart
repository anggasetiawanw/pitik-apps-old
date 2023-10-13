// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, must_be_immutable, use_key_in_widget_constructors, annotate_overrides, overridden_fields

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
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
    GlobalKey<AutoCompleteTextFieldState<String>> key;

    int id;
    String label;
    String hint;
    String alertText;
    bool hideLabel = false;
    List<String> suggestList;
    Function(String) onTyping;

    SuggestField({required this.key, required this.controller, this.id = 1, required this.label, required this.hint, required this.alertText, required this.suggestList, required this.onTyping});

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
                                        child: SimpleAutoCompleteTextField(
                                            key: key,
                                            controller: suggestFieldController,
                                            suggestions: controller.suggestList,
                                            textChanged: (text) => onTyping(text),
                                            textSubmitted: (text) {
                                                onTyping(text);

                                                // for selected object
                                                if (controller.listObject.isNotEmpty) {
                                                    for (int i = 0; i < controller.suggestList.length; i++) {
                                                        if (text == controller.suggestList[i]) {
                                                            controller.selectedObject = controller.listObject[i];
                                                            break;
                                                        }
                                                    }
                                                }
                                            },
                                            clearOnSubmit: false,
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(left: 8),
                                                counterText: "",
                                                hintText: hint,
                                                fillColor: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
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
                                                        child: Image.asset('images/error_icon.png')
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