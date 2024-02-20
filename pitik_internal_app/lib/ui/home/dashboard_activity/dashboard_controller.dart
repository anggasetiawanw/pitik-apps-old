import 'package:get/get.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;
  var isOpslead = false.obs;
  var isExpanded = false.obs;
  String pushNotificationPayload = "";
  void changeTabIndex(int index) {
    tabIndex.value = index;
    if (index == 1) {
      isExpanded.value = true;
    } else if (index == 2) {
      isExpanded.value = false;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      pushNotificationPayload = Get.arguments;
      if (pushNotificationPayload.isNotEmpty) {
        Constant.pushNotifPayload.value = pushNotificationPayload;
      }
    }
    Constant.isOpsLead.listen((p0) {
      isOpslead.value = p0;
      refresh();
      update();
    });
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
