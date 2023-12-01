
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class PrivacyScreenController extends GetxController {
    BuildContext context;

    PrivacyScreenController({required this.context});
    ScrollController scrollController = ScrollController();
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    late Future<bool> isFirstLogin;
    var isLoading = false.obs;
    var showBtnApprove = false.obs;

    late String homePageRoute;
    late ButtonFill bfAgree;
    
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
        
        bfAgree = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfAgree"),
            label: "Saya Setuju", onClick: () async {
            final SharedPreferences pref = await prefs;
            isFirstLogin = pref.setBool('isFirstLogin', false);
            Get.offAllNamed(homePageRoute, arguments: Get.arguments[2]);
        });

        if (Get.arguments != null) {
            showBtnApprove.value = Get.arguments[0];
            homePageRoute = Get.arguments[1];
        }

        isFirstLogin = prefs.then((SharedPreferences prefs) {
            return prefs.getBool('isFirstLogin') ?? true;
        });

        scrollListener();
        bfAgree.controller.disable();
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

