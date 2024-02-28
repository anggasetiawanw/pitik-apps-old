// ignore_for_file: must_be_immutable, slash_for_doc_comments, depend_on_referenced_packages

import 'package:components/expandable/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'expandable_controller.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class Expandable extends StatelessWidget {
  ExpandableController controller;
  Widget child;
  String headerText;
  bool expanded;
  Widget? titleWidget;
  Color titleBackgroundColorExpand;
  Color titleBackgroundColorCollapse;
  Color titleBorderColor;

  Expandable(
      {super.key,
      required this.controller,
      required this.headerText,
      this.expanded = false,
      required this.child,
      this.titleWidget,
      this.titleBackgroundColorExpand = const Color(0xFFFDDAA5),
      this.titleBackgroundColorCollapse = const Color(0xFFFDDAA5),
      this.titleBorderColor = const Color(0xFFFDDAA5)});

  ExpandableController getController() {
    return Get.find(tag: controller.tag);
  }

  @override
  Widget build(BuildContext context) {
    controller.expanded.value = expanded;

    return Obx(() => Accordion(
          margin: EdgeInsets.zero,
          title: titleWidget != null ? null : headerText,
          textStyle: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium),
          onToggleCollapsed: (isExpand) {
            if (isExpand) {
              controller.expand();
            } else {
              controller.collapse();
            }
          },
          titleChild: titleWidget,
          collapsedTitleBackgroundColor: titleBackgroundColorCollapse,
          expandedTitleBackgroundColor: titleBackgroundColorExpand,
          showAccordion: controller.expanded.value,
          collapsedIcon: SvgPicture.asset("images/arrow_down.svg"),
          expandedIcon: SvgPicture.asset("images/arrow_up.svg"),
          titleBorder: Border.all(
            color: titleBorderColor,
          ),
          titleBorderRadius: controller.expanded.isTrue ? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
          contentBorder: const Border(
            bottom: BorderSide(color: GlobalVar.outlineColor, width: 1),
            left: BorderSide(color: GlobalVar.outlineColor, width: 1),
            right: BorderSide(color: GlobalVar.outlineColor, width: 1),
            top: BorderSide(color: GlobalVar.outlineColor, width: 0.1),
          ),
          contentBorderRadius: controller.expanded.isTrue ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
          contentChild: child,
        ));
  }
}
