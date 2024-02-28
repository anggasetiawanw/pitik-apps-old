// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ButtonFillController extends GetxController {
  String tag;
  ButtonFillController({required this.tag});

  var activeField = true.obs;
  var label = "".obs;

  void enable() => activeField.value = true;
  void disable() => activeField.value = false;
  void changeLabel(String text) => label.value = text;
}

class ButtonFillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ButtonFillController>(() => ButtonFillController(tag: "tag"));
  }
}
