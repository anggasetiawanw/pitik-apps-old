
// ignore_for_file: slash_for_doc_comments

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_var.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class MultipleFormFieldController<T> extends GetxController {
    String tag;
    MultipleFormFieldController({required this.tag});

    RxMap<String, Widget> listAdded = <String, Widget>{}.obs;
    RxMap<String, T> listObjectAdded = <String, T>{}.obs;

    void addData({required Widget child, required T object, required String key}) {
        listObjectAdded.putIfAbsent(key, () => object);
        listAdded.putIfAbsent(key, () =>
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    child,
                    GestureDetector(
                        onTap: () {
                            listObjectAdded.remove(key);
                            listAdded.remove(key);
                        },
                        child: Container(
                            width: 32,
                            height: 32,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                border: Border.fromBorderSide(BorderSide(color: GlobalVar.primaryOrange, width: 2))
                            ),
                            child: Icon(Icons.remove, color: GlobalVar.primaryOrange),
                        ),
                    )
                ],
            )
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