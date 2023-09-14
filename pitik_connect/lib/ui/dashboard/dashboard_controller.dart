import 'package:get/get.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 06/07/23
 */


class DashboardController extends GetxController {
    var tabIndex = 0;

    void changeTabIndex(int index) {
        tabIndex = index;
        update();
    }

    @override
    void onInit() {
        // TODO: implement onInit
        super.onInit();
    }

    @override
    void onReady() {
        // TODO: implement onReady
        super.onReady();
    }

}

class DashboardBindings extends Bindings {
    @override
    void dependencies() {
        Get.put(DashboardController());
    }

}