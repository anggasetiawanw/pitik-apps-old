import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/08/23

class PrivacyScreenController extends GetxController {
  BuildContext context;

  PrivacyScreenController({required this.context});
  ScrollController scrollController = ScrollController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late Future<bool> isFirstLogin;
  var isLoading = false.obs;
  var showBtnApprove = false.obs;

  late ButtonFill bfAgree = ButtonFill(
    controller: GetXCreator.putButtonFillController('bfAgree'),
    label: 'Saya Setuju',
    onClick: () async {
      final SharedPreferences pref = await prefs;
      isFirstLogin = pref.setBool('isFirstLogin', false);
      await Get.offAllNamed(RoutePage.homePage);
    },
  );
  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        bfAgree.controller.enable();
      }
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    if (Get.arguments != null) {
      showBtnApprove.value = Get.arguments;
    }
    isFirstLogin = prefs.then((SharedPreferences prefs) {
      return prefs.getBool('isFirstLogin') ?? true;
    });
    scrollListener();
    bfAgree.controller.disable();
    // if(showBtnApprove.isFalse){
    //     bfAgree.controller.disable()
    // }
    isLoading.value = false;
  }
}

class PrivacyScreenBindings extends Bindings {
  BuildContext context;

  PrivacyScreenBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyScreenController(context: context));
  }
}
