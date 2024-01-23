
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/login/login_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class LoginActivity extends GetView<LoginController> {
    const LoginActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: SvgPicture.asset('images/logo_fill.svg', width: 96, height: 96),
                            ),
                            const SizedBox(height: 32),
                            Text('Login', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 31, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange)),
                            const SizedBox(height: 16),
                            controller.phoneNumberField,
                            controller.passwordField,
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    const SizedBox(),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Text('Lupa Kata Sandi?', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                    )
                                ],
                            ),
                            const SizedBox(height: 32),
                            ButtonFill(controller: GetXCreator.putButtonFillController("btnLogin"), label: "Masuk", onClick: () => controller.login()),
                            ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnRegister"), label: "Bergabung menjadi Kawan Pitik!", onClick: () {

                            })
                        ]
                    )
                )
            )
        );
    }
}