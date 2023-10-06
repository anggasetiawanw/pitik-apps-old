import 'dart:async';

import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/profile_impl.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:dao_impl/x_app_id_impl.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/auth_model.dart';
import 'package:model/profile.dart';
import 'package:model/user_google_model.dart';
import 'package:model/x_app_model.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class SplashActivity extends StatefulWidget {
    const SplashActivity({super.key});

    @override
    State<SplashActivity> createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {
    @override
    void initState()  {
        WidgetsBinding.instance.addPostFrameCallback((_)async {
            Timer(
                const Duration(seconds: 3),
                () async {
                    Auth? auth = await AuthImpl().get();
                    UserGoogle? userGoogle = await UserGoogleImpl().get();
                    Profile? userProfile = await ProfileImpl().get();
                    XAppId? xAppId = await XAppIdImpl().get();
                    if (auth == null || userGoogle == null ||userProfile == null ) {
                        Get.offNamed(RoutePage.loginPage);
                    } else {
                        Constant.auth = auth;
                        Constant.userGoogle = userGoogle;
                        Constant.profileUser = userProfile;
                        String appId = FirebaseRemoteConfig.instance.getString("appId");
                        if(xAppId != null && (appId.isNotEmpty && xAppId.appId != appId) ){
                            xAppId.appId = appId;
                            XAppIdImpl().save(xAppId);
                            Constant.xAppId = xAppId.appId;
                        } else if(xAppId != null){
                            Constant.xAppId = xAppId.appId;
                        } else {
                            xAppId = XAppId();
                            xAppId.appId = appId;
                            XAppIdImpl().save(xAppId);
                            Constant.xAppId = appId;
                        }
                        Get.offNamed(RoutePage.homePage);
                    }
                },
            );
        });
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: AppColors.primaryOrange,
            body: Center(
                child: SizedBox(
                    height: 192,
                    width: 192,
                    child: SvgPicture.asset("images/white_logo.svg"),
                ),
            ),
        );
    }
}
