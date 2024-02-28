// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'spinner_field_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class SpinnerField extends StatelessWidget {
  SpinnerFieldController controller;
  String label;
  String hint;
  String alertText;
  bool hideLabel = false;
  bool isDetail;
  bool hasSubtitle;
  Color backgroundField;
  Map<String, bool> items;
  Function(String) onSpinnerSelected;

  SpinnerField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.alertText,
      this.hideLabel = false,
      required this.items,
      required this.onSpinnerSelected,
      this.isDetail = false,
      this.backgroundField = GlobalVar.primaryLight,
      this.hasSubtitle = false});

  SpinnerFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  bool onInit = true;

  @override
  Widget build(BuildContext context) {
    if (onInit) {
      controller.hideLabel.value = hideLabel;
      controller.generateItems(items);
      int index = 0;
      items.forEach((key, value) {
        if (value) {
          controller.setTextSelected(key);
          controller.selectedIndex = index;
        }
        index++;
      });
      controller.hasSubtitle.value = hasSubtitle;
      onInit = false;
    }

    final labelField = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          label,
          textAlign: TextAlign.left,
          style: const TextStyle(color: GlobalVar.black, fontSize: 14),
        ),
      ),
    );

    return Obx(() => controller.showSpinner.isTrue
        ? Padding(
            key: controller.formKey,
            padding: EdgeInsets.only(top: controller.hideLabel.isFalse ? 16 : 0),
            child: Column(children: [
              controller.hideLabel.isFalse ? labelField : const SizedBox(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: controller.activeField.isTrue ? backgroundField : GlobalVar.gray,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: controller.activeField.isTrue && controller.showTooltip.isFalse && controller.isShowList.isTrue
                                ? GlobalVar.primaryOrange
                                : controller.activeField.isTrue && controller.showTooltip.isTrue
                                    ? GlobalVar.red
                                    : Colors.transparent,
                            width: 2)),
                    child: controller.items.isNotEmpty
                        ? createDropdown()
                        : GestureDetector(
                            onTap: () {
                              if (controller.activeField.isTrue) {
                                Get.snackbar("Informasi", "$label data kosong", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);
                              }
                            },
                            child: createDropdown())),
                controller.showTooltip.isTrue
                    ? Container(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(children: [
                          Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset("images/error_icon.svg")),
                          Expanded(
                            child: Text(
                              controller.alertText.value.isNotEmpty ? controller.alertText.value : alertText,
                              style: const TextStyle(color: GlobalVar.red, fontSize: 12),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ]))
                    : Container()
              ])
            ]))
        : Container());
  }

  DropdownButtonHideUnderline createDropdown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      enableFeedback: true,
      autofocus: true,
      menuItemStyleData: const MenuItemStyleData(),
      dropdownStyleData: DropdownStyleData(
          maxHeight: 260,
          padding: null,
          isOverButton: false,
          offset: const Offset(0, -5),
          scrollbarTheme: ScrollbarThemeData(
            trackVisibility: MaterialStateProperty.all(true),
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
            interactive: true,
          )),
      isExpanded: true,
      isDense: true,
      alignment: Alignment.centerLeft,
      focusNode: controller.focusNode,
      buttonStyleData: const ButtonStyleData(padding: null),
      iconStyleData: IconStyleData(
          icon: Align(
              alignment: Alignment.center,
              child: Row(children: [
                controller.isLoading.isTrue
                    ? Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: GlobalVar.primaryOrange)),
                      )
                    : Container(),
                controller.activeField.isTrue
                    ? controller.isShowList.isTrue
                        ? SvgPicture.asset("images/arrow_up.svg")
                        : SvgPicture.asset("images/arrow_down.svg")
                    : SvgPicture.asset("images/arrow_disable.svg"),
                const SizedBox(width: 16)
              ]))),
      onMenuStateChange: (isOpen) {
        if (isOpen) {
          controller.focusNode.focusInDirection(TraversalDirection.down);
        }
        controller.isShowList.value = isOpen;
      },
      items: controller.items.isNotEmpty ? renderItems() : <DropdownMenuItem<String>>[],
      underline: Container(),
      hint: Text(controller.textSelected.value == "" ? hint : controller.textSelected.value, style: TextStyle(color: controller.textSelected.value == "" ? const Color(0xFF9E9D9D) : GlobalVar.black, fontSize: 14)),
      onChanged: controller.activeField.isTrue
          ? (String? newValue) {
              controller.items.forEach((key, value) {
                if (key == newValue) {
                  controller.items[key] = true;
                  controller.textSelected.value = key;

                  int index = 0;
                  controller.items.forEach((label, value) {
                    if (key == label) {
                      controller.selectedIndex = index;

                      // for selected object
                      if (controller.listObject.isNotEmpty) {
                        controller.selectedObject = controller.listObject[controller.selectedIndex];
                      }
                    }
                    index++;
                  });

                  onSpinnerSelected(key);
                  controller.showTooltip.value = false;
                  controller.isShowList.value = false;
                } else {
                  controller.items[key] = false;
                }
              });
            }
          : null,
    ));
  }

  List<DropdownMenuItem<String>> renderItems() {
    List<DropdownMenuItem<String>> result = [];

    controller.items.forEach((key, value) {
      result.add(DropdownMenuItem(
          value: key,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            controller.items[key] == true ? SvgPicture.asset("images/on_spin.svg") : SvgPicture.asset("images/off_spin.svg"),
            const SizedBox(width: 8),
            if (isDetail) ...[
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(key, style: const TextStyle(color: GlobalVar.black, fontSize: 14)),
                      Row(children: [
                        Text(
                          "Jumlah (Ekor) ",
                          style: GlobalVar.blackTextStyle.copyWith(fontSize: 10),
                        ),
                        Text("${controller.amountItems[key]} Ekor - ", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                        Text(
                          "Total (Kg) ",
                          style: GlobalVar.blackTextStyle.copyWith(fontSize: 10),
                        ),
                        Text("${controller.weightItems[key]} Kg", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                      ])
                    ],
                  ),
                ),
              )
            ],
            if (controller.hasSubtitle.isTrue) ...[
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(key, style: const TextStyle(color: GlobalVar.black, fontSize: 14)),
                      Row(children: [
                        Text(
                          "Total Global : ",
                          style: GlobalVar.blackTextStyle.copyWith(fontSize: 10),
                        ),
                        Text("${controller.subtitle[key]} Kg", style: GlobalVar.blackTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                      ])
                    ],
                  ),
                ),
              )
            ] else ...[
              Expanded(child: Text(key, style: const TextStyle(color: GlobalVar.black, fontSize: 14), overflow: TextOverflow.clip))
            ],
          ])));
    });

    return result;
  }
}
