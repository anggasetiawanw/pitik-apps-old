
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/08/23

class OnBoardingController extends GetxController {
    BuildContext context;
    OnBoardingController({required this.context});

    final Future<SharedPreferences> pref = SharedPreferences.getInstance();
    late Future<bool> isFirstRun;

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    var boardingIndeks = 0.obs;

    late ButtonFill bfNext = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfNext"),
        label: "Lanjut", onClick: () {
        if(boardingIndeks < 3) {
            boardingIndeks++;
        }

    },
    );
    late ButtonFill bfStart = ButtonFill(
        controller: GetXCreator.putButtonFillController("bfStart"),
        label: "Mulai", onClick: () {
        setPreferences();
        Get.offNamed(RoutePage.loginPage);
    },
    );
    late ButtonOutline boNoRegBuilding;
    late EditField efNoHp = EditField(
        controller: GetXCreator.putEditFieldController(
            "efNoHpForgetPassword"),
        label: "Nomor Handphone",
        hint: "08xxxx",
        alertText: "Nomer Handphone Tidak Boleh Kosong",
        textUnit: "",
        inputType: TextInputType.number,
        maxInput: 20,
        onTyping: (value, control) {
        }
    );




    Future<void> setPreferences() async {
        final SharedPreferences prefs = await pref;
        isFirstRun = prefs.setBool('isFirstRun', false);
    }
}

class OnBoardingBindings extends Bindings {
    BuildContext context;

    OnBoardingBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => OnBoardingController(context: context));
    }
}

