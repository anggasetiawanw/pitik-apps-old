// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class MediaFieldController extends GetxController {

    String tag;
    MediaFieldController({required this.tag});

    var showTooltop = false.obs;
    var activeField = true.obs;
    var hideLabel = false.obs;
    var fileName = "".obs;

    void showAlert() => showTooltop.value = true;
    void hideAlert() => showTooltop.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void setFileName(String value) => fileName.value = value;
}

class MediaFiledBinding extends Bindings {

    @override
    void dependencies() {
        Get.lazyPut<MediaFieldController>(() => MediaFieldController(tag: ""));
    }
}