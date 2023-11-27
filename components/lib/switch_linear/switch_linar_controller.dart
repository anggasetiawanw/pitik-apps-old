import 'package:get/get.dart';
class SwitchLinearController extends GetxController {
    String tag;
    SwitchLinearController({required this.tag});

    var isSwitchOn = false.obs;
    var isCanTap = true.obs;

    void tapEnable() => isCanTap.value = true;
    void tapDisable() => isCanTap.value = false;
    // @override
    // void onInit() {
    //     super.onInit();
    // }
    // @override
    // void onReady() {
    //     super.onReady();
    // }
    // @override
    // void onClose() {
    //     super.onClose();
    // }
}
class SwitchLinearBindings extends Bindings {
    String tag;
    SwitchLinearBindings({required this.tag});
    @override
    void dependencies() {
        Get.lazyPut(() => SwitchLinearController(tag: tag));
    }
}