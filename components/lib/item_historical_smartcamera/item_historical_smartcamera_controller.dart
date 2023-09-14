
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../edit_field/edit_field.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class ItemHistoricalSmartCameraController extends GetxController {
    String tag;
    BuildContext context;
    ItemHistoricalSmartCameraController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<EditField>> efDayTotal = Rx<List<EditField>>([]);
    Rx<List<EditField>> efDecreaseTemp = Rx<List<EditField>>([]);

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = false.obs;
    var isLoadApi = false.obs;
    var numberList = 0.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void InvisibleCard() => isShow.value = false;

    @override
    void onInit() {
        super.onInit();
    }

    @override
    void onReady() {
        super.onReady();
    }

    @override
    void onClose() {
        super.onClose();
    }

}

class ItemHistoricalSmartCameraBindings extends Bindings {
    String tag;
    BuildContext context;
    ItemHistoricalSmartCameraBindings({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<ItemHistoricalSmartCameraController>(() => ItemHistoricalSmartCameraController(tag: tag, context: context));
    }
}
