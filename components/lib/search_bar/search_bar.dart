// ignore_for_file: must_be_immutable

import 'package:components/global_var.dart';
import 'package:components/search_bar/search_bar_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SearchBarField extends StatelessWidget {
    final SearchBarController controller;
    final List<String> items;
    final Function(String, SearchBarField) onTyping;
    final Function(String) onCategorySelected;
    final String? hint;
    final bool addPrefixDropdown;

    SearchBarField({super.key, required this.controller, this.hint, required this.items, required this.onTyping, required this.onCategorySelected, this.addPrefixDropdown = true});
    SearchBarController getController() => Get.find(tag: controller.tag);

    bool onInit = true;

    @override
    Widget build(BuildContext context) {
        if (onInit) {
            controller.items = items;
            if (controller.items.isNotEmpty) {
                controller.selectedValue.value = items[0];
            }
            onInit = false;
        }

        return Obx(() => TextField(
            controller: controller.textSearch,
            focusNode: controller.focusNode,
            onChanged: (text) => onTyping(text, this),
            cursorColor: GlobalVar.primaryOrange,
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFF9ED),
                contentPadding: const EdgeInsets.only(left: 4.0),
                hintText: hint ?? "Cari ${controller.selectedValue.value}",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                suffixIcon:addPrefixDropdown ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: SvgPicture.asset("images/search_icon.svg")
                ) : null,
                prefixIcon: addPrefixDropdown ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                        width: 104,
                        child: Column(
                            children: [
                                const SizedBox(height: 1),
                                DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                        isExpanded: true,
                                        customButton: Container(
                                            padding: const EdgeInsets.only(top: 10),
                                            height: 32,
                                            width: 96,
                                            child: Obx(() => Row(
                                                children: [
                                                    Expanded(child: Text(controller.selectedValue.value, style: const TextStyle(fontSize: 14, color: GlobalVar.black), overflow: TextOverflow.ellipsis)),
                                                    const SizedBox(width: 8),
                                                    controller.isShowList.isTrue ? SvgPicture.asset("images/arrow_up.svg") : SvgPicture.asset("images/arrow_down.svg")
                                                ]
                                            ))
                                        ),
                                        items: controller.items.map((item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(item, style: GlobalVar.subTextStyle.copyWith(fontSize: 14, color: GlobalVar.black))
                                        )).toList(),
                                        value: controller.selectedValue.value,
                                        onChanged: (String? value) {
                                            controller.selectedValue.value = value ?? "";
                                            onCategorySelected(controller.selectedValue.value);
                                        },
                                        onMenuStateChange: (isOpen) => controller.isShowList.value = isOpen,
                                        dropdownStyleData: const DropdownStyleData(width: 120)
                                    )
                                )
                            ]
                        )
                    )
                ) : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: SvgPicture.asset("images/search_icon.svg")
                ),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.0, color: GlobalVar.primaryOrange)),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.0, color: GlobalVar.primaryOrange)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.0, color: GlobalVar.primaryOrange)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.0, color: GlobalVar.primaryOrange))
            )
        ));
    }
}
