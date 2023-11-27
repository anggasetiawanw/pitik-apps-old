import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultipleDynamicFormFieldController<T> extends GetxController {
    String tag;
    MultipleDynamicFormFieldController({required this.tag});

    RxList<Widget> listChildAdded  = <Widget>[].obs;
    RxList<T> listData = <T>[].obs;

    void addData({required Widget child, required T object, required int index}) {
        listData.insert(index > 0 ? index - 1 : index, object);
        listChildAdded.insert(index, child);
    }

    void removeData({required int index}) {
        listData.removeAt(index);
        listChildAdded.removeAt(index);
    }
}

class MultipleDynamicFormFieldBinding extends Bindings {
    String tag;
    MultipleDynamicFormFieldBinding({required this.tag});

    @override
    void dependencies() => Get.lazyPut<MultipleDynamicFormFieldController>(() => MultipleDynamicFormFieldController(tag: tag));
}