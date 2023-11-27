// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:components/global_var.dart';
import 'package:components/multiple_dynamic_form_field/multiple_dynamic_form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultipleDynamicFormField<T> extends StatelessWidget {
    MultipleDynamicFormFieldController controller;
    Function(int) title;
    Widget iconIncrease;
    Widget iconDecease;
    Function(MultipleDynamicFormFieldController, int) onIncrease;
    Function(MultipleDynamicFormFieldController, int) onDecease;
    Function(int) child;
    dynamic initInstance;
    Function(int) selectedObject;

    MultipleDynamicFormField({super.key, required this.controller, required this.title, required this.iconIncrease, required this.iconDecease, required this.child, required this.initInstance,
                              required this.onIncrease, required this.onDecease, required this.selectedObject});

    MultipleDynamicFormFieldController getController() => Get.find(tag: controller.tag);

    bool isAlreadyInit = false;

    @override
    Widget build(BuildContext context) {
        if (!isAlreadyInit) {
            onIncrease(controller, 0);
            controller.addData(child: child(0), object: initInstance, index: 0);
        }

        return Obx(() =>
            Column(
                children: List.generate(controller.listChildAdded.length, (index) {
                    return Column(
                        children: [
                            Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                    border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                ),
                                child: Column(
                                    children: [
                                        Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                                                color: GlobalVar.headerSku
                                            ),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text(title(index), style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                    GestureDetector(
                                                        onTap: () {
                                                            if (index == controller.listChildAdded.length - 1) {
                                                                if (onIncrease(controller, index + 1)) {
                                                                    controller.addData(child: child(index + 1), object: selectedObject(index), index: index + 1);
                                                                }
                                                            } else {
                                                                if (onDecease(controller, index)) {
                                                                    controller.removeData(index: index);
                                                                }
                                                            }
                                                        },
                                                        child: index == controller.listChildAdded.length - 1 ?  iconIncrease : iconDecease,
                                                    )
                                                ]
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: child(index),
                                        )
                                    ]
                                )
                            ),
                            const SizedBox(height: 12),
                        ]
                    );
                }),
            )
        );
    }
}