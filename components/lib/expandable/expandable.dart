// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../global_var.dart';
import 'expandable_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class Expandable extends StatelessWidget {
    ExpandableController controller;
    Widget child;
    String headerText;
    bool expanded;

    Expandable({super.key, required this.controller, required this.headerText, this.expanded = false, required this.child});

    ExpandableController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        controller.expanded.value = expanded;

        return Obx(() =>
            GFAccordion(
                margin: EdgeInsets.zero,
                title: headerText,
                textStyle: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium),
                onToggleCollapsed: (isExpand) {
                    if (isExpand) {
                        controller.expand();
                    } else {
                        controller.collapse();
                    }
                },
                collapsedTitleBackgroundColor: Color(0xFFFDDAA5),
                expandedTitleBackgroundColor: Color(0xFFFDDAA5),
                showAccordion: controller.expanded.value,
                collapsedIcon: SvgPicture.asset("images/arrow_down.svg"),
                expandedIcon: SvgPicture.asset("images/arrow_up.svg"),
                titleBorder: Border.all(color: Color(0xFFFDDAA5),),
                titleBorderRadius: controller.expanded.isTrue ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : BorderRadius.all(Radius.circular(10)),
                contentBorder: Border(
                  bottom: BorderSide(color:GlobalVar.outlineColor, width: 1),
                  left: BorderSide(color: GlobalVar.outlineColor, width: 1),
                  right: BorderSide(color: GlobalVar.outlineColor, width: 1),
                  top: BorderSide(color: GlobalVar.outlineColor, width: 0),
                ),
                contentBorderRadius: controller.expanded.isTrue ? BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : BorderRadius.all(Radius.circular(10)),
                 contentChild: child,
            )
        );
    }
}
