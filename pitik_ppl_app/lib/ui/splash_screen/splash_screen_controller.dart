import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/util/updater_code_magic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/profile.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
final Future<SharedPreferences> _prefFirstLogin = SharedPreferences.getInstance();

class SplashScreenController extends GetxController {

    var isUpdated = false.obs;

    late Future<bool> isFirstRun;
    late Future<bool> isFirstLogin;
    late String pushNotificationPayload;

    @override
    void onInit() {
        super.onInit();
        pushNotificationPayload = Get.arguments ?? '';
    }

    @override
    void onReady() async {
        super.onReady();
        await UpdaterCodeMagic().checkForUpdate(
            isAvailable: (isAvailable) {
                if(isAvailable){
                    isUpdated.value = true;
                } else {
                    runSplash();
                }
            } ,
            isReadyToRestart: (isReadyToRestart) => Timer(const Duration(seconds: 1), () => showInformation()),
        );
    }

    void runSplash() => Timer(
        const Duration(seconds: 2), () async {
            Auth? auth = await AuthImpl().get();
            Profile? userProfile = await ProfileImpl().get();

            if (auth == null || userProfile == null ) {
                isFirstRun = _prefs.then((SharedPreferences prefs) => prefs.getBool('isFirstRun') ?? true);
                if (await isFirstRun) {
                    Get.offNamed(RoutePage.boardingPage);
                } else {
                    Get.offNamed(RoutePage.loginPage);
                }

            } else {
                GlobalVar.auth = auth;
                GlobalVar.profileUser = userProfile;

                isFirstLogin = _prefFirstLogin.then((SharedPreferences prefs) => prefs.getBool('isFirstLogin') ?? true);
                if (await isFirstLogin) {
                    Get.toNamed(RoutePage.privacyPage, arguments: [true, RoutePage.coopList, pushNotificationPayload]);
                } else {
                    Get.offNamed(RoutePage.coopList, arguments: pushNotificationPayload);
                }
            }
        }
    );

    void showInformation() => Get.dialog(
        Center(
            child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Row(
                            children: [
                                SvgPicture.asset(
                                    "images/check_password.svg",
                                    height: 24,
                                    width: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "Information!",
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, decoration: TextDecoration.none),
                                ),
                            ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            "Update aplikasi berhasil, silahkan restart aplikasi" ,
                            style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                SizedBox(
                                    width: 100,
                                    child: ButtonOutline(
                                        controller:
                                        GetXCreator.putButtonOutlineController("btnOutlineDialogCodeMagicClose"),
                                        label: "Tutup",
                                        onClick: () => Get.back()

                                    ),
                                ),
                                SizedBox(
                                    width: 100,
                                    child: ButtonFill(
                                        controller:
                                        GetXCreator.putButtonFillController("btnFillDialogCodeMagicRestart"),
                                        label: "Restart",
                                        onClick: () => Restart.restartApp()
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
            ),
        ),
        barrierDismissible: false
    );
}

class SplashScreenBindings extends Bindings {
    SplashScreenBindings();

    @override
    void dependencies() => Get.lazyPut(() => SplashScreenController());
}