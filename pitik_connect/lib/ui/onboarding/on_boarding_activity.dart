
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../route.dart';
import '../profile/change_password/change_password_controller.dart';
import 'on_boarding_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 25/08/23
 */


class OnBoarding extends GetView<ChangePasswordController> {
    const OnBoarding({super.key});

    @override
    Widget build(BuildContext context) {
        final OnBoardingController controller = Get.put(OnBoardingController(
            context: context,
        ));
        Widget topBar(){
            return Container(
                height: 32,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Row(
                            children: [
                                Obx(() => controller.boardingIndeks == 0 ? SvgPicture.asset("images/dot_elipse_orange.svg") : SvgPicture.asset("images/dot_grey.svg")),
                                SizedBox(width: 5,),
                                Obx(() => controller.boardingIndeks == 1 ? SvgPicture.asset("images/dot_elipse_orange.svg") : SvgPicture.asset("images/dot_grey.svg")),
                                SizedBox(width: 5,),
                                Obx(() => controller.boardingIndeks == 2 ? SvgPicture.asset("images/dot_elipse_orange.svg") : SvgPicture.asset("images/dot_grey.svg")),
                            ],
                        ),
                        Obx(() => controller.boardingIndeks < 2 ?
                        GestureDetector(
                            onTap: (){
                                controller.setPreferences();
                                Get.offNamed(RoutePage.loginPage);
                            },
                            child: Row(
                                children: [
                                    Text("Lewati"),
                                    SvgPicture.asset("images/arrow_right_black.svg"),
                                ],
                            ),
                        ):Container())
                    ],
                ),
            );
        }


        Widget bottomNavBar() {
            return Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Container(
                            margin: EdgeInsets.only(right: 24, left: 24),
                            width: double.infinity,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(
                                        child: Stack(
                                            children: [
                                                Obx(() => controller.boardingIndeks < 2 ? controller.bfNext : controller.bfStart)
                                            ],
                                        )),
                                ],
                            ),
                        ),
                        SizedBox(height: 80,),
                    ],
                ));
        }

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Container(),
            ),
            body: Stack(
                children: [
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(top: 16),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child: Stack(
                                children: [
                                    topBar(),
                                    Container(
                                        padding: EdgeInsets.only(top: 16),
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                            children: [
                                                SizedBox(height: 60),
                                                Obx(() => controller.boardingIndeks == 0 ? Image.asset("images/onboarding_1.png") :
                                                controller.boardingIndeks == 1 ? Image.asset("images/onboarding_2.png") : Image.asset("images/onboarding_3.png")),
                                            ],
                                        ),
                                    ),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            SizedBox(height: 420),
                                            Obx(() => controller.boardingIndeks == 0 ? Text("Pemantauan Real-time", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center) :
                                            controller.boardingIndeks == 1 ? Text("Kontrol Jarak Jauh", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center) :
                                            Text("Notifikasi Penting", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                                            ),
                                            SizedBox(height: 16),
                                            Obx(() => controller.boardingIndeks == 0 ? Text("Dapatkan pemantauan langsung dari kandang ternak Anda kapan saja dan di mana saja. Pantau kondisi lingkungan, suhu, kelembaban, dan lainnya secara real-time.", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.center) :
                                            controller.boardingIndeks == 1 ? Text(" Melalui aplikasi ini, Anda bisa mengontrol berbagai aspek kandang seperti pemberian pakan, pengaturan suhu, pencahayaan, dan lainnya secara jarak jauh.", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.center) :
                                            Text("Tetap up-to-date dengan status kandang Anda melalui notifikasi langsung ke ponsel Anda. Dapatkan pemberitahuan tentang perubahan suhu yang tiba-tiba, level pakan yang rendah, dan informasi penting lainnya.", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.normal), textAlign: TextAlign.center)
                                            ),
                                            SizedBox(height: 20),
                                            bottomNavBar(),
                                        ],
                                    )
                                ],),
                        ),
                    ),
                ]

            ),
        );
    }
}