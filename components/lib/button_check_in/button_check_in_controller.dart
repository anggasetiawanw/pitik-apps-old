// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:get/get.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ButtonCheckInController extends GetxController {
    String tag;
    ButtonCheckInController({required this.tag});

    RxString error = "".obs;
    var isShow = false.obs;
    var isSuccess = false.obs;
    void showLabel(bool success, String value) {
        error.value = value;
        isSuccess.value = success;
        isShow.value = true;
    }

    void hideLabel() => isShow.value = false;
}

class ButtonCheckInBindings extends Bindings {
    @override
    void dependencies() {
        Get.lazyPut<ButtonCheckInController>(() => ButtonCheckInController(tag: ""));
    }
}
