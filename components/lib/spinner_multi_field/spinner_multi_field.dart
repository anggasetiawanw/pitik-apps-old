// ignore_for_file: slash_for_doc_comments, must_be_immutable, depend_on_referenced_packages

import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'spinner_multi_field_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SpinnerMultiField extends GetView<SpinnerMultiFieldController> {
  @override
  final SpinnerMultiFieldController controller;

  final String label;
  final String hint;
  final String alertText;
  final bool hideLabel;
  final List<String> items;
  Function(String?) onSpinnerSelected;
  bool onInit = true;

  SpinnerMultiField({super.key, required this.controller, required this.label, required this.hint, required this.alertText, this.hideLabel = false, required this.items, required this.onSpinnerSelected});

  SpinnerMultiFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  @override
  Widget build(BuildContext context) {
    if (onInit) {
      controller.generateItems(items);
      onInit = false;
    }

    final labelField = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(color: GlobalVar.black, fontSize: 14),
      ),
    );

    return Obx(() => controller.showSpinner.isTrue
        ? Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(children: <Widget>[
              controller.hideLabel.isFalse ? labelField : Container(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Column(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            color: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: controller.activeField.isTrue && controller.showTooltip.isFalse && controller.selectedValue.value.isNotEmpty
                                    ? GlobalVar.primaryOrange
                                    : controller.activeField.isTrue && controller.showTooltip.isTrue
                                        ? GlobalVar.red
                                        : Colors.transparent,
                                width: 2)),
                        child: controller.items.value.isNotEmpty
                            ? createDropdown()
                            : GestureDetector(
                                onTap: () {
                                  print("com ${controller.items.value}");
                                  if (controller.activeField.isTrue) {
                                    Get.snackbar("Informasi", "$label data kosong", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);
                                  }
                                },
                                child: createDropdown())),
                    Align(alignment: Alignment.topLeft, child: controller.showTooltip.isTrue ? Container(padding: const EdgeInsets.only(top: 4), child: Row(children: [Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset("images/error_icon.svg")), Text(controller.alertText.value.isNotEmpty ? controller.alertText.value : alertText, style: const TextStyle(color: GlobalVar.red, fontSize: 12))])) : Container())
                  ]))
            ]),
          )
        : Container());
  }

  Widget createDropdown() {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(children: [
          Expanded(
              flex: 8,
              child: DropdownButton(
                isExpanded: true,
                icon: Align(
                  alignment: Alignment.center,
                  child: controller.activeField.isTrue ? SvgPicture.asset("images/arrow_down.svg") : SvgPicture.asset("images/disable.svg"),
                ),
                items: controller.items.value
                    .map((key) => DropdownMenuItem<String>(
                        value: key,
                        onTap: () {
                          if (controller.selectedValue.value.contains(key)) {
                            controller.selectedValue.value.remove(key);
                            controller.selectedValue.refresh();
                          } else {
                            controller.selectedValue.value.add(key);
                            controller.selectedValue.refresh();
                          }
                        },
                        child: InkWell(
                          onTap: () {
                            if (controller.selectedValue.value.contains(key)) {
                              controller.selectedValue.value.remove(key);
                              controller.selectedValue.refresh();
                            } else {
                              controller.selectedValue.value.add(key);
                              controller.selectedValue.refresh();
                            }
                          },
                          child: Row(
                            children: [
                              Obx(() => Checkbox(
                                  value: controller.selectedValue.value.contains(key),
                                  activeColor: GlobalVar.primaryOrange,
                                  onChanged: (isSelect) {
                                    if (controller.selectedValue.value.contains(key)) {
                                      // for selected object
                                      if (controller.selectedObject.containsKey(key)) {
                                        controller.selectedObject.remove(key);
                                      }

                                      controller.selectedValue.value.remove(key);
                                      controller.selectedValue.refresh();
                                    } else {
                                      // for selected object
                                      if (controller.listObject.isNotEmpty) {
                                        controller.selectedObject.putIfAbsent(key, () => controller.listObject[key]);
                                      }

                                      controller.selectedValue.value.add(key);
                                      controller.selectedValue.refresh();
                                    }
                                  })),
                              controller.isSubtitle.isTrue
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [Text(key, style: const TextStyle(color: GlobalVar.black, fontSize: 14)), Text(controller.subtitles[key]!, style: const TextStyle(color: GlobalVar.black, fontSize: 12))],
                                    )
                                  : Text(key, style: const TextStyle(color: GlobalVar.black, fontSize: 14))
                            ],
                          ),
                        )))
                    .toList(),
                underline: Container(),
                onTap: controller.activeField.isTrue ? () => controller.expand() : null,
                hint: Text(controller.selectedValue.value.isNotEmpty ? controller.selectedValue.value.map((e) => e.toString()).reduce((a, b) => '$a , $b') : hint, style: TextStyle(color: controller.selectedValue.value.isNotEmpty ? GlobalVar.black : const Color(0xFF9E9D9D), fontSize: 14)),
                onChanged: controller.activeField.isTrue ? onSpinnerSelected : null,
              ))
        ]));
  }
}
