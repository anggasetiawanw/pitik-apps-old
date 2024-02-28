// ignore_for_file: slash_for_doc_comments

import 'package:components/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_var.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class MultipleFormFieldController<T> extends GetxController {
  String tag;
  MultipleFormFieldController({required this.tag});

  RxMap<String, Widget> listAdded = <String, Widget>{}.obs;
  RxMap<String, T> listObjectAdded = <String, T>{}.obs;

  late CustomDialog customDialog;

  @override
  void onInit() {
    super.onInit();
    customDialog = CustomDialog(Get.context!, Dialogs.YES_NO_OPTION).titleButtonOk("Ganti").titleButtonNo("Tambah");
  }

  String getDefaultMessageDialog() => 'Data telah ditambah, silahkan pilih Ganti atau Tambah data lama..!';
  dynamic getObject(String key, dynamic initInstance) => listObjectAdded.isEmpty ? initInstance : listObjectAdded[key];

  void addData({required Widget child, required T object, required String key}) {
    listObjectAdded[key] = object;
    listAdded[key] = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 8, child: child),
            Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    listObjectAdded.remove(key);
                    listAdded.remove(key);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    // padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.fromBorderSide(BorderSide(color: GlobalVar.primaryOrange, width: 2))),
                    child: const Icon(Icons.remove, color: GlobalVar.primaryOrange),
                  ),
                ))
          ],
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}

class MultipleFormFieldBinding extends Bindings {
  String tag;
  MultipleFormFieldBinding({required this.tag});

  @override
  void dependencies() {
    Get.lazyPut<MultipleFormFieldController>(() => MultipleFormFieldController(tag: tag));
  }
}
