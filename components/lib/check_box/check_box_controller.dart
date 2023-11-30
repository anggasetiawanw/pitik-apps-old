
// ignore_for_file: slash_for_doc_comments

import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class CheckBoxController extends GetxController {
    String tag;
    CheckBoxController({required this.tag});

    var isChecked = false.obs;
    void checked() => isChecked.value = true;
    void unchecked() => isChecked.value = false;
    bool status() => isChecked.value;
}

class CheckBoxBinding extends Bindings {
    String tag;
    CheckBoxBinding({required this.tag});

    @override
    void dependencies() => Get.lazyPut<CheckBoxController>(() => CheckBoxController(tag: ""));
}