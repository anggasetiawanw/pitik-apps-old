import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  String tag;
  SearchBarController({required this.tag});

  RxString selectedValue = "".obs;
  RxBool isShowList = false.obs;
  FocusNode focusNode = FocusNode();
  List<String> items = [];
  TextEditingController textSearch = TextEditingController();
  RxBool isShowAccordion = false.obs;

  void clearText() => textSearch.clear();
  String getSearchText() => textSearch.text;
  void setDefaultSelected() {
    if (items.isNotEmpty) {
      selectedValue.value = items[0];
    }
  }

  void setSelectedValue(String value) {
    if (items.contains(value)) {
      selectedValue.value = value;
    } else {
      if (items.isNotEmpty) {
        selectedValue.value = items[0];
      } else {
        selectedValue.value = "";
      }
    }
  }

  void generateItem(List<String> items) => this.items = items;
  void showAccordion() => isShowAccordion.value = true;
  void hideAccordion() => isShowAccordion.value = false;
}

class SearchBarBindings extends Bindings {
  String tag;
  SearchBarBindings({required this.tag});

  @override
  void dependencies() => Get.lazyPut(() => SearchBarController(tag: tag));
}
