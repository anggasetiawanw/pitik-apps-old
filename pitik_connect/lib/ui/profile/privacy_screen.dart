
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pitik_connect/ui/profile/privacy_screen_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 02/08/23
 */


class PrivacyScreen extends GetView<PrivacyScreenController> {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final PrivacyScreenController controller = Get.put(PrivacyScreenController(
          context: context,
      ));
    Widget bottomNavBar() {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(20, 158, 157, 157),
                                    blurRadius: 5,
                                    offset: Offset(0.75, 0.0))
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        ),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child:controller.bfAgree
                                )
                            ],
                        ),
                    ),
                ],
            ));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child:Container(),
        ),
        body: Stack(
            children: [
                SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Container(
                        padding: EdgeInsets.only(top: 16, bottom: 100),
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                            Center(
                                child: Text("Kebijakan Privasi\nPitik Digital Indonesia",style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                            ),
                            Container(
                                margin: EdgeInsets.only(top:4),
                                child: Center(child:
                                Text("Terakhir di perbarui 17 Des 2022 - 10:00", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 32),
                                child: Html(data: GlobalVar.privacyPolicy),
                            )
                        ],),
                    ),
                ),
                bottomNavBar(),
            ],
        ),
    );
  }
}