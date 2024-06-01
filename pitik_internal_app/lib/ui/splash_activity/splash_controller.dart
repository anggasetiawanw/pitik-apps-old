import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:dao_impl/x_app_id_impl.dart';
import 'package:engine/util/updater_code_magic.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/text_style.dart';
import 'package:model/auth_model.dart';
import 'package:model/profile.dart';
import 'package:model/user_google_model.dart';
import 'package:model/x_app_model.dart';
import 'package:restart_app/restart_app.dart';

import '../../utils/constant.dart';
import '../../utils/route.dart';

class SplashController extends GetxController {
  var isUpdated = false.obs;

  String pushNotificationPayload = '';
  @override
  void onInit() {
    super.onInit();
    pushNotificationPayload = Get.arguments ?? '';
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await UpdaterCodeMagic().checkForUpdate(
      isAvailable: (isAvailable) {
        if (isAvailable) {
          isUpdated.value = true;
        } else {
          runSplash();
        }
      },
      isReadyToRestart: (isReadyToRestart) => Timer(const Duration(seconds: 1), () {
        showInformation();
      }),
    );
  }

  void runSplash() {
    Timer(
      const Duration(seconds: 1),
      () async {
        final Auth? auth = await AuthImpl().get();
        final UserGoogle? userGoogle = await UserGoogleImpl().get();
        final Profile? userProfile = await ProfileImpl().get();
        XAppId? xAppId = await XAppIdImpl().get();

        await Get.offNamed(RoutePage.homePage, arguments: pushNotificationPayload);
        // if (auth == null || userGoogle == null || userProfile == null) {
        //   await Get.offNamed(RoutePage.loginPage);
        // } else {
        //   Constant.auth = auth;
        //   Constant.profileUser = userProfile;
        //   final String appId = FirebaseRemoteConfig.instance.getString('appId');
        //   if (xAppId != null && (appId.isNotEmpty && xAppId.appId != appId)) {
        //     xAppId.appId = appId;
            //     await XAppIdImpl().save(xAppId);
        //     Constant.xAppId = xAppId.appId;
        //   } else if (xAppId != null) {
        //     Constant.xAppId = xAppId.appId;
        //   } else {
        //     xAppId = XAppId();
        //     xAppId.appId = appId;
        //     await XAppIdImpl().save(xAppId);
        //     Constant.xAppId = appId;
        //   }
        //   await Get.offNamed(RoutePage.homePage, arguments: pushNotificationPayload);
        // }
      },
    );
  }

  void showInformation() {
    Get.dialog(
        Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'images/success_checkin.svg',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Information!',
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.bold, decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Update aplikasi berhasil, silahkan restart aplikasi',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: ButtonOutline(controller: GetXCreator.putButtonOutlineController('ButtonOutlineDialog'), label: 'Tutup', onClick: () => Get.back()),
                    ),
                    SizedBox(
                      width: 120,
                      child: ButtonFill(controller: GetXCreator.putButtonFillController('Dialog'), label: 'Restart', onClick: () => Restart.restartApp()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }
}

class SplashBindings extends Bindings {
  SplashBindings();
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
