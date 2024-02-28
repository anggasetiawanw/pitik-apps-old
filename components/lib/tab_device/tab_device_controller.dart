// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_var.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class TabDeviceController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: 4);
    controller.addListener(() {
      if (controller.indexIsChanging) {
        if (controller.index == 0) {
          GlobalVar.track("Click_tab_smart_monitoring");
        } else if (controller.index == 1) {
          GlobalVar.track("Click_tab_smart_controller");
        } else if (controller.index == 2) {
          GlobalVar.track("Click_tab_smart_camera");
        } else if (controller.index == 3) {
          GlobalVar.track("Click_tab_smart_scale");
        }
      }
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
