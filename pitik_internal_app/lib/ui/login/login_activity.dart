import 'dart:io' show Platform;

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:global_variable/global_variable.dart";
import "package:pitik_internal_app/ui/login/login_controller.dart";
import "package:pitik_internal_app/widget/common/loading.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginActivityController controller = Get.put(LoginActivityController(context: context));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset("images/logo_welcome.svg"),
          ),
          controller.isDemo.isTrue && Platform.isIOS
              ? Positioned(top: -150, child: SvgPicture.asset("images/welcome_sales.svg", width: MediaQuery.of(context).size.width))
              : Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset("images/welcome_sales.svg", width: MediaQuery.of(context).size.width),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: controller.isDemo.isTrue && Platform.isIOS ? 520 : 210,
              margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32),
              child: Column(
                children: [
                  if (controller.isDemo.isTrue && Platform.isIOS) ...[
                    controller.efUsername,
                    controller.efPassword,
                    controller.bfLogin,
                    const SizedBox(height: 16),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    const SizedBox(height: 16),
                  ],
                  controller.googleLoginButton,
                  const SizedBox(height: 8),
                  Platform.isIOS ? controller.appleLoginButton : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.only(top: 55),
                    child: Column(
                      children: [
                        Text(
                          "Dengan kamu menekan tombol Sign In,",
                          style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        ),
                        Text(
                          "berarti kamu setuju dengan",
                          style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        ),
                        RichText(
                          text: TextSpan(
                            style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Kebijakan Privasi",
                                style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 10),
                              ),
                              const TextSpan(text: " serta"),
                              TextSpan(
                                text: " Syarat & Ketentuan",
                                style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 10),
                              ),
                              const TextSpan(text: " kami"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.isTrue
                ? Center(
                    child: Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.black54, child: const Center(child: ProgressLoading())),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
