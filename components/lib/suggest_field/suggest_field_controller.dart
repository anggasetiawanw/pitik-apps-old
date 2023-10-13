// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SuggestFieldController<T> extends GetxController {

    String tag;
    SuggestFieldController({required this.tag});

    RxList<T?> listObject = <T?>[].obs;
    T? selectedObject;
    var showTooltip = false.obs;
    var activeField = true.obs;
    var hideLabel = false.obs;
    RxList<String> suggestList = <String>[].obs;

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void visibleLabel() => hideLabel.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void setupObjects(List<T?> data) => listObject.value = data;
    void generateItems(List<String> data) => suggestList.value = data;
    void addItems(String data) => suggestList.add(data);
    T? getSelectedObject() => selectedObject;
}

class SuggestFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<SuggestFieldController>(() => SuggestFieldController(tag: ""));
    }
}