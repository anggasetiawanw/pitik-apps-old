
// ignore_for_file: must_be_immutable, slash_for_doc_comments

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/listener/custom_dialog_listener.dart';
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
    Function() childAdded;
    Function(T) increaseWhenDuplicate;
    String labelButtonAdd;
    String titleDialogWhenDuplicate;
    Function()? messageDialogWhenDuplicate;
    Function() selectedObject;
    Function(T) selectedObjectWhenIncreased;
    Function() keyData;
    Function() validationAdded;
    Function()? onAfterAdded;
    dynamic initInstance;
    EdgeInsetsGeometry padding;
    Decoration decoration;

    MultipleFormField({super.key, required this.controller, required this.child, required this.childAdded, required this.increaseWhenDuplicate, required this.labelButtonAdd, required this.selectedObject,
                       this.titleDialogWhenDuplicate = 'Perhatian !', this.messageDialogWhenDuplicate, required this.selectedObjectWhenIncreased, required this.initInstance, required this.validationAdded,
                       required this.keyData, this.decoration = const BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                           border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
                       ), this.padding = const EdgeInsets.all(16), this.onAfterAdded});

    MultipleFormFieldController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Column(
                children: [
                    Container(
                        padding: padding,
                        decoration: decoration,
                        child: Column(
                            children: [
                                child,
                                ButtonFill(controller: GetXCreator.putButtonFillController("multipleFormFieldAdd${controller.tag}"), label: labelButtonAdd, isHaveIcon: true, imageAsset: const Icon(Icons.add, color: Colors.white),
                                    onClick: () {
                                        if (validationAdded()) {
                                            if (controller.listAdded.containsKey(keyData())) {
                                                controller.customDialog
                                                    .title(titleDialogWhenDuplicate)
                                                    .message(messageDialogWhenDuplicate == null ? '${keyData()} telah ditambah, silahkan pilih Ganti atau Tambah data lama..!' : messageDialogWhenDuplicate!())
                                                    .listener(CustomDialogListener(
                                                    onDialogOk: (context, id, packet) {
                                                        controller.addData(child: childAdded(), object: selectedObject(), key: keyData());
                                                        afterAdded();
                                                    },
                                                    onDialogCancel: (context, id, packet) {
                                                        T data = selectedObjectWhenIncreased(controller.getObject(keyData(), initInstance));
                                                        controller.addData(child: increaseWhenDuplicate(data), object: data, key: keyData());
                                                        afterAdded();
                                                    }
                                                )).show();
                                            } else {
                                                controller.addData(child: childAdded(), object: selectedObject(), key: keyData());
                                                afterAdded();
                                            }
                                        }
                                    }
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

    void afterAdded() {
        if (onAfterAdded != null) {
            Future.delayed(const Duration(milliseconds: 200), () => onAfterAdded!());
        }
    }
}