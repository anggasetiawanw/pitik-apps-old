// ignore_for_file: depend_on_referenced_packages, slash_for_doc_comments

import 'package:get/get.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ButtonOutlineController extends GetxController {
  String tag;
  ButtonOutlineController({required this.tag});

  var activeField = true.obs;
  void enable() => activeField.value = true;
  void disable() => activeField.value = false;
}

class ButtonOutlineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ButtonOutlineController>(() => ButtonOutlineController(tag: "tag"));
  }
}
