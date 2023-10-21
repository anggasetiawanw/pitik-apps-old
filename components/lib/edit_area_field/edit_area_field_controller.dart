// ignore_for_file: slash_for_doc_comments

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 21/10/2023
 */

class EditAreaFieldController extends GetxController {
    String tag;
    EditAreaFieldController({required this.tag});

    final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();

    var activeField = true.obs;
    var showTooltip = false.obs;
    var hideLabel = false.obs;

    void showAlert() => showTooltip.value = true;
    void hideAlert() => showTooltip.value = false;
    void enable() => activeField.value = true;
    void disable() => activeField.value = false;
    void invisibleLabel() => hideLabel.value = true;
    void visibleLabel() => hideLabel.value = false;
    void inFocus() => Scrollable.ensureVisible(formStateKey.currentContext!);
}

class EditAreaFieldBinding extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<EditAreaFieldController>(() => EditAreaFieldController(tag: ''));
    }
}