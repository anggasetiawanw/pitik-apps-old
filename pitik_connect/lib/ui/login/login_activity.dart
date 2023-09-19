
import 'package:components/global_var.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../route.dart';
import 'login_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 04/07/23
 */


class LoginActivity extends StatelessWidget {
    LoginActivity({super.key});

    @override
    Widget build(BuildContext context) {
        final LoginController _controller = Get.put(LoginController(context: context));

        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Stack(
                children: [
                    Align(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset("images/logo_welcome.svg"),
                    ),
                    SingleChildScrollView(
                        child: Column(
                            children: [
                                SvgPicture.asset("images/welcome_user.svg", width: MediaQuery.of(context).size.width),
                                Column(
                                    children: [
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                        child: Column(
                                            children: [
                                                _controller.efNoHp,
                                                _controller.efPassword,
                                                Container(
                                                    child: GestureDetector(
                                                        onTap: (){
                                                            Get.toNamed(RoutePage.forgetPassPage);
                                                        },
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                              Text("Lupa Kata Sandi ?", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium,
                                                                  color: GlobalVar.primaryOrange)),
                                                          ],
                                                      ),
                                                    ) ,
                                                ),
                                                const SizedBox(height: 48,),
                                                _controller.bfLogin,
                                            ],
                                        ),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        height: 210,
                                        margin: EdgeInsets.only(left: 56, right: 56),
                                        child: Column(
                                            children: [
                                                const SizedBox(height: 8),
                                                Container(
                                                    margin: EdgeInsets.only(top: 32),
                                                    child: Column(
                                                        children: [
                                                            Text(
                                                                "Dengan kamu menekan tombol Sign In,",
                                                                style: GlobalVar.greyTextStyle.copyWith(fontSize: 10),
                                                            ),
                                                            Text(
                                                                "berarti kamu setuju dengan",
                                                                style: GlobalVar.greyTextStyle.copyWith(fontSize: 10),
                                                            ),
                                                            new RichText(
                                                                text: new TextSpan(
                                                                    style: GlobalVar.greyTextStyle.copyWith(fontSize: 10),
                                                                    children: <TextSpan>[
                                                                        TextSpan(
                                                                            text: "Kebijakan Privasi",
                                                                            style: GlobalVar.primaryTextStyle.copyWith(fontSize: 10),
                                                                            recognizer: TapGestureRecognizer()..onTap = () {
                                                                                Get.toNamed(RoutePage.privacyPage, arguments: false);
                                                                            },
                                                                        ),
                                                                        TextSpan(text: " serta"),
                                                                        TextSpan(
                                                                            text: " Syarat & Ketentuan",
                                                                            style: GlobalVar.primaryTextStyle.copyWith(fontSize: 10),
                                                                            recognizer: TapGestureRecognizer()..onTap = () {
                                                                                Get.toNamed(RoutePage.termPage);
                                                                            },
                                                                        ),
                                                                        TextSpan(text: " kami"),
                                                                    ],
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                )
                                            ],
                                        ),
                                    ),
                                ],),
                            ],
                        )
                    ),

                    Obx(() =>
                    _controller.isLoading.isTrue
                        ? Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black54,
                            // child: Center(
                            //     child: ProgressLoading()
                            // )
                        ),
                    )
                        : SizedBox(),
                    ),
                ],
            ),
        );
    }
}
