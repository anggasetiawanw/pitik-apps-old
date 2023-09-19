import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23

class TabReceiveController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: 3);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}