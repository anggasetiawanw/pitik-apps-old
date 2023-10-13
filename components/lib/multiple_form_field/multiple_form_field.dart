
// ignore_for_file: must_be_immutable, slash_for_doc_comments

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/multiple_form_field/multiple_form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class MultipleFormField<T> extends StatelessWidget {
    MultipleFormFieldController controller;
    Widget child;
    Widget childAdded;
    String labelButtonAdd;
    T selectedObject;
    String keyData;

    MultipleFormField({super.key, required this.controller, required this.child, required this.childAdded, required this.labelButtonAdd, required this.selectedObject, required this.keyData});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Column(
                children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
                        ),
                        child: Column(
                            children: [
                                child,
                                ButtonFill(controller: GetXCreator.putButtonFillController("multipleFormFieldAdd${controller.tag}"), label: labelButtonAdd, isHaveIcon: true, imageAsset: const Icon(Icons.add, color: Colors.white),
                                    onClick: () => controller.addData(child: childAdded, object: selectedObject, key: keyData)
                                )
                            ]
                        ),
                    ),
                    const SizedBox(height: 16),
                    Column(children: controller.listAdded.entries.map((entry) => entry.value).toList())
                ],
            )
        );
    }
}