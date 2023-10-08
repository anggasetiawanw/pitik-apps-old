import 'dart:async';
import 'dart:io';

import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:engine/util/access_phone_permission.dart';
import 'package:engine/util/updater_code_magic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/auth_model.dart';
import 'package:model/profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class SplashScreenActivity extends StatefulWidget {
    const SplashScreenActivity({super.key});

    @override
    State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenActivity> {

    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    late Future<bool> isFirstRun;

    final Future<SharedPreferences> prefFirstLogin = SharedPreferences.getInstance();
    late Future<bool> isFirstLogin;

    @override
    void initState() {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
            var permissionGPS = await Permission.location.request();
            if (Platform.isIOS) {
                // GpsUtil.on();
            } else {
                var permissionPhoneAccess = await handlePermissionPhoneAccess();
                if (permissionGPS.isDenied) {
                    Get.snackbar("Alert", "This Apps Need Location Permission",
                        duration: const Duration(seconds: 5), snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: GlobalVar.red);
                } else if (await Permission.locationWhenInUse.isDenied) {
                    Get.snackbar("Info", "Enable Location, Please!", snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: GlobalVar.red);

                } else if(!permissionPhoneAccess) {
                    Get.snackbar("Alert", "Enable Phone Access, Please!", snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: GlobalVar.red);
                } else {
                    // GpsUtil.mock(true);
                }
            }

            // Check New Update
            UpdaterCodeMagic().checkForUpdate(
                isAvailable: (isAvailable) => print('NEW UPDATE -> $isAvailable'),
                isReadyToRestart: (isReadyToRestart) => print('RESTART APP -> $isReadyToRestart'),
            );

            Timer(
                const Duration(seconds: 2), () async {
                    Auth? auth = await AuthImpl().get();
                    Profile? userProfile = await ProfileImpl().get();

                    if (auth == null || userProfile == null ) {
                        isFirstRun = prefs.then((SharedPreferences prefs) => prefs.getBool('isFirstRun') ?? true);
                        if (await isFirstRun) {
                            Get.offNamed(RoutePage.boardingPage);
                        } else {
                            Get.offNamed(RoutePage.loginPage);
                        }

                    } else {
                        GlobalVar.auth = auth;
                        GlobalVar.profileUser = userProfile;

                        isFirstLogin = prefFirstLogin.then((SharedPreferences prefs) => prefs.getBool('isFirstLogin') ?? true);
                        if (await isFirstLogin) {
                            Get.toNamed(RoutePage.privacyPage, arguments: [true, RoutePage.coopList]);
                        } else {
                            Get.offNamed(RoutePage.coopList);
                        }
                    }
                },
            );
        });
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                color: GlobalVar.primaryOrange,
                child: Center(
                    child: SvgPicture.asset('images/logo_white.svg'),
                ),
            ),
        );
	}
}