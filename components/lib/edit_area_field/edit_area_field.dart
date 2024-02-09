// ignore_for_file: must_be_immutable, slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'edit_area_field_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 21/10/2023
 */

class EditAreaField extends StatelessWidget {

    EditAreaFieldController controller;
    String? label;
    Color? labelColor;
    Color background;
    Widget? prefixIcon;
    String hint;
    String alertText;
    String textUnit;
    Color? textColor;
    int maxInput;
    bool hideLabel;
    TextInputAction action;
    Function(String, EditAreaField) onTyping;

    EditAreaField({super.key, required this.controller, this.label, this.labelColor, this.textColor = GlobalVar.black, this.background = GlobalVar.primaryLight, this.prefixIcon, required this.hint,
        required this.alertText, this.textUnit = "", required this.maxInput, this.action = TextInputAction.done, this.hideLabel = false, required this.onTyping});

    late String data;
    final _editFieldController = TextEditingController();

    EditAreaFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    void setValue(String text) {
        _editFieldController.text = text;
    }

    String getInput() {
        return _editFieldController.text;
    }

    @override
    Widget build(BuildContext context) {
        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label != null ? label! : "",
                textAlign: TextAlign.left,
                style: TextStyle(color: labelColor ?? GlobalVar.black, fontSize: 14),
            ),
        );

        return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Obx(() =>
                Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse && label != null ? labelField : Container(),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: TextFormField(
                                            key: controller.formStateKey,
                                            controller: _editFieldController,
                                            enabled: controller.activeField.isTrue,
                                            maxLength: maxInput,
                                            maxLines: 6,
                                            textInputAction: action,
                                            keyboardType: TextInputType.multiline,
                                            onChanged: (text) {
                                                controller.hideAlert();
                                                onTyping(text, this);
                                            },
                                            style: TextStyle(color: textColor),
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(8),
                                                counterText: "",
                                                hintText: hint,
                                                hintStyle: const TextStyle(color: Color(0xFF9E9D9D)),
                                                prefixIcon: prefixIcon,
                                                suffixIcon: Padding(
                                                    padding: const EdgeInsets.all(16),
                                                    child: Text(
                                                        textUnit,
                                                        style: TextStyle(color: controller.activeField.isTrue ? GlobalVar.primaryOrange : GlobalVar.black, fontSize: 12)
                                                    ),
                                                ),
                                                fillColor: controller.activeField.isTrue ? background : GlobalVar.gray,
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: BorderSide(
                                                        color: controller.activeField.isTrue && controller.showTooltip.isFalse ? GlobalVar.primaryOrange : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white,
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
                                                        color: controller.activeField.isTrue && controller.showTooltip.isFalse ? GlobalVar.primaryLight : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white,
                                                        width: 2.0,
                                                    ),
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
                                                                alertText,
                                                                style: const TextStyle(color: GlobalVar.red, fontSize: 12),
                                                                overflow: TextOverflow.clip,
                                                            ),
                                                        )
                                                    ],
                                                )
                                            )
                                            : Container()
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