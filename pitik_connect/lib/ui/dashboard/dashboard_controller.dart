import 'package:get/get.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 06/07/23


class DashboardController extends GetxController {
    var tabIndex = 0;

    void changeTabIndex(int index) {
        tabIndex = index;
        update();
    }

}

class DashboardBindings extends Bindings {
    @override
    void dependencies() {
        Get.put(DashboardController());
    }

}