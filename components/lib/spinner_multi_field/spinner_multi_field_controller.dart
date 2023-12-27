// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class SpinnerMultiFieldController<T> extends GetxController {
  String tag;
  SpinnerMultiFieldController({required this.tag});

  RxMap<String, T?> selectedObject = RxMap<String, T?>({});
  RxMap<String, T?> listObject = RxMap<String, T?>({});
  var showTooltip = false.obs;
  var activeField = true.obs;
  var isShowList = false.obs;
  var hideLabel = false.obs;
  Rx<List<String>> items = Rx<List<String>>([]);
  Rx<List<String>> selectedValue = Rx<List<String>>([]);
  var showSpinner = true.obs;
  var alertText = "".obs;
  var isSubtitle = false.obs;
  RxMap<String, String> subtitles = RxMap<String, String>({});

  void visibleSpinner() => showSpinner.value = true;
  void invisibleSpinner() => showSpinner.value = false;
  void setAlertText(String text) => alertText.value = text;
  void showAlert() => showTooltip.value = true;
  void hideAlert() => showTooltip.value = false;
  void enable() => activeField.value = true;
  void disable() => activeField.value = false;
  void expand() => isShowList.value = true;
  void collapse() => isShowList.value = false;
  void invisibleLabel() => hideLabel.value = true;
  void visibleLabel() => hideLabel.value = false;
  void setupObjects(Map<String, T?> data) => listObject.value = data;
  void generateItems(List<String> data) {
    items.value = data;
    items.refresh();
    update();
  }

  void generateSubtitles(Map<String, String> data) => subtitles.value = data;
  Map<String, T?> getSelectedObject() => selectedObject;
  void showSubtitle() => isSubtitle.value = true;
  void hideSubtitle() => isSubtitle.value = false;
}

class SpinnerFieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpinnerMultiFieldController>(() => SpinnerMultiFieldController(tag: ""));
  }
}
