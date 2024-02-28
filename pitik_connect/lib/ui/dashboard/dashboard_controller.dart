import 'package:dao_impl/smart_scale_impl.dart';
import 'package:get/get.dart';
import 'package:engine/offlinecapability/offline_automation.dart';
import 'package:engine/request/service.dart';
import 'package:dao_impl/offline_body/smart_scale_body.dart';

import '../../api_mapping/api_mapping.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 06/07/23

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    // running offline first
    OfflineAutomation().putWithRequest(SmartScaleImpl(), ServicePeripheral(keyMap: 'smartScaleApi', requestBody: SmartScaleBody(), baseUrl: ApiMapping().getBaseUrl())).launch();
  }
}

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
