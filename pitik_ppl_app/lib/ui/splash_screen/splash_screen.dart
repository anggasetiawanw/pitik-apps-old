import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/splash_screen/splash_screen_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class SplashScreenActivity extends StatelessWidget {
    const SplashScreenActivity({super.key});

    @override
    Widget build(BuildContext context) {
        SplashScreenController controller = Get.put(SplashScreenController());

        return Scaffold(
            backgroundColor: GlobalVar.primaryOrange,
            body: Obx(() =>
                Center(
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
                            const Text("Aplikasi sedang memperbarui, jangan tutup aplikasi...", style: TextStyle(color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 24),
                            const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            )
                        ]
                    ) : SizedBox(
                        height: 192,
                        width: 192,
                        child: SvgPicture.asset("images/white_logo.svg"),
                    ),
                )
            )
        );
    }
}