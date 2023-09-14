import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */


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