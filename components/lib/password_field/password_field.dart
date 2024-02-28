// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'password_field_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class PasswordField extends StatelessWidget {
  PasswordFieldController controller;
  String label;
  String hint;
  String alertText;
  String alertPasswordLength;
  String alertPassword;
  int maxInput;
  bool hideLabel = false;
  TextInputAction action;
  Function(String) onTyping;

  PasswordField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.alertText,
      required this.maxInput,
      this.action = TextInputAction.done,
      this.hideLabel = false,
      required this.onTyping,
      this.alertPasswordLength = "Minimum harus lebih dari 6 karakter",
      this.alertPassword = "Setidaknya ada kombinasi huruf dan angka"});

  var passwordFieldController = TextEditingController();

  PasswordFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  String getInput() {
    return passwordFieldController.text;
  }

  @override
  Widget build(BuildContext context) {
    final labelField = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(color: GlobalVar.black, fontSize: 14),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Obx(() => Column(
              children: <Widget>[
                controller.hideLabel.isFalse ? labelField : Container(),
                Padding(
                    key: controller.formKey,
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: Column(children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: TextFormField(
                              controller: passwordFieldController,
                              enabled: controller.activeField.isTrue,
                              maxLength: maxInput,
                              textInputAction: action,
                              keyboardType: TextInputType.text,
                              obscureText: controller.obscure.isFalse,
                              onChanged: (text) {
                                if (controller.activeField.isTrue) {
                                  onTyping(text);
                                  controller.hideAlert();
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 8),
                                counterText: "",
                                hintText: hint,
                                hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF9E9D9D)),
                                suffixIcon: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: GestureDetector(
                                      onTap: () => controller.obscure.isTrue ? controller.hidePassword() : controller.showPassword(),
                                      child: Image.asset(controller.obscure.isTrue ? 'images/eye_on_icon.png' : 'images/eye_off_icon.png'),
                                    )),
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
                                    )),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: GlobalVar.primaryLight)),
                                filled: true,
                              ))),
                      Align(
                        alignment: Alignment.topLeft,
                        child: controller.showLengthAlert.isTrue
                            ? Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset(controller.goodLength.isTrue ? "images/check_password.svg" : "images/error_icon.svg")),
                                    Text(
                                      alertPasswordLength,
                                      style: TextStyle(color: controller.goodLength.isTrue ? GlobalVar.green : GlobalVar.red, fontSize: 12),
                                    )
                                  ],
                                ))
                            : Container(),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: controller.showPasswordAlert.isTrue
                            ? Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset(controller.goodPassword.isTrue ? "images/check_password.svg" : "images/error_icon.svg")),
                                    Text(
                                      alertPassword,
                                      style: TextStyle(color: controller.goodPassword.isTrue ? GlobalVar.green : GlobalVar.red, fontSize: 12),
                                    )
                                  ],
                                ))
                            : Container(),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: controller.showTooltip.isTrue
                              ? Container(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset("images/error_icon.svg")),
                                      Text(
                                        controller.alertText.isEmpty ? alertText : controller.alertText.value,
                                        style: const TextStyle(color: GlobalVar.red, fontSize: 12),
                                      )
                                    ],
                                  ))
                              : Container())
                    ]))
              ],
            )));
  }
}
