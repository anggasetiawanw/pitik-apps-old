// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:components/global_var.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'spinner_search_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class SpinnerSearch extends StatelessWidget {
  final SpinnerSearchController controller;
  final String label;
  final String hint;
  final String alertText;
  final bool hideLabel = false;
  final Map<String, bool> items;
  final Function(String) onSpinnerSelected;
  const SpinnerSearch({super.key, required this.controller, required this.label, required this.hint, required this.alertText, required this.items, required this.onSpinnerSelected});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (controller.init) {
        controller.generateItems(items);
        controller.init = false;
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

    return Obx(() => controller.showSpinner.isTrue
        ? Container(
            key: controller.formKey,
            margin: const EdgeInsets.only(top: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              controller.hideLabel.isFalse ? labelField : Container(),
              const SizedBox(height: 8),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: controller.activeField.isTrue && controller.showTooltip.isFalse && controller.isShowList.isTrue
                              ? GlobalVar.primaryOrange
                              : controller.activeField.isTrue && controller.showTooltip.isTrue
                                  ? GlobalVar.red
                                  : Colors.transparent,
                          width: 2)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                          autofocus: true,
                          menuItemStyleData: const MenuItemStyleData(height: 40),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 260,
                              padding: null,
                              isOverButton: false,
                              offset: const Offset(0, -5),
                              scrollbarTheme:
                                  ScrollbarThemeData(trackVisibility: MaterialStateProperty.all(true), radius: const Radius.circular(40), thickness: MaterialStateProperty.all(6), thumbVisibility: MaterialStateProperty.all(true), interactive: true)),
                          isExpanded: true,
                          isDense: true,
                          alignment: Alignment.centerLeft,
                          focusNode: controller.focusNode,
                          buttonStyleData: const ButtonStyleData(padding: null),
                          iconStyleData: IconStyleData(
                              icon: Align(
                                  alignment: Alignment.center,
                                  child: Row(children: [
                                    controller.isloading.isTrue
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
                          dropdownSearchData: DropdownSearchData(
                              searchController: controller.textEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller: controller.textEditingController,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'Ketik di sini',
                                          hintStyle: const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: GlobalVar.primaryOrange)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: controller.activeField.isTrue && controller.showTooltip.isFalse
                                                    ? GlobalVar.primaryOrange
                                                    : controller.activeField.isTrue && controller.showTooltip.isTrue
                                                        ? GlobalVar.red
                                                        : GlobalVar.outlineColor,
                                                width: 2.0,
                                              )),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(color: GlobalVar.gray),
                                          ),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey))))),
                              searchMatchFn: (item, searchValue) {
                                return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                              }),
                          items: renderItems(),
                          hint: Text(controller.textSelected.value == "" ? hint : controller.textSelected.value, style: TextStyle(color: controller.textSelected.value == "" ? const Color(0xFF9E9D9D) : GlobalVar.black, fontSize: 14)),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              controller.textEditingController.clear();
                            }
                            controller.isShowList.value = isOpen;
                          },
                          onChanged: (newValue) {
                            controller.items.value.forEach((key, value) {
                              if (key == (newValue as String)) {
                                controller.items.value[key] = true;
                                controller.textSelected.value = key;

                                int index = 0;
                                controller.items.value.forEach((label, value) {
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
                                controller.items.value[key] = false;
                              }
                            });
                          }))),
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
            ]))
        : const SizedBox());
  }

  List<DropdownMenuItem<String>> renderItems() {
    List<DropdownMenuItem<String>> result = [];

    controller.items.value.forEach((key, value) {
      result.add(DropdownMenuItem(
          value: key,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            controller.items.value[key] == true ? SvgPicture.asset("images/on_spin.svg") : SvgPicture.asset("images/off_spin.svg"),
            const SizedBox(width: 8),
            Expanded(child: Text(key, style: const TextStyle(color: GlobalVar.black, fontSize: 14), overflow: TextOverflow.clip)),
          ])));
    });

    return result;
  }
}
