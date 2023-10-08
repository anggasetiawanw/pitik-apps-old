import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/splash_activity/splash_controller.dart';

class SplashActivity extends StatelessWidget {
    const SplashActivity({super.key});

    @override
    Widget build(BuildContext context) {
        SplashController controller = Get.put(SplashController());
        return Scaffold(
            backgroundColor: AppColors.primaryOrange,
            body:Obx(() =>  Center(
                child: controller.isUpdated.isTrue? 
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SizedBox(
                                height: 192,
                                width: 192,
                                child: SvgPicture.asset("images/white_logo.svg"),
                            ),
                            const SizedBox(height: 24,),
                            const Text("Aplikasi sedang diupdate, jangan tutup aplikasi.", style: TextStyle(color: Colors.white, fontSize: 16),),
                            const SizedBox(height: 24,),
                            const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                            )
                        ]
                    ,)
                    : SizedBox(
                        height: 192,
                        width: 192,
                        child: SvgPicture.asset("images/white_logo.svg"),
                    ),
        )));
    }
}
