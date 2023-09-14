import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'button_check_in_controller.dart';
import 'package:flutter_svg/svg.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class ButtonCheckIn extends StatelessWidget {
    final ButtonCheckInController controller;
    final Function(ButtonCheckIn) onTap;
    ButtonCheckIn({super.key, required this.onTap, required this.controller});

    ButtonCheckInController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Column(
                children: [
                    InkWell(
                        splashColor: GlobalVar.primaryOrange.withOpacity(0.2),
                        onTap: () {
                            onTap(this);
                        },
                        child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 2, color: GlobalVar.primaryOrange),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Text(
                                        "Check In",
                                        style: GlobalVar.primaryTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                    ),
                                    const SizedBox(width: 11),
                                    SvgPicture.asset("images/checkin_icon.svg", height: 22)
                                ],
                            ),
                        ),
                    ),
                    controller.isShow.isTrue ?
                    Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: controller.isSuccess.isTrue ? Color(0xFFECFDF3) : Color(0xFFFEF3F2),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                            children: [
                                Image.asset(controller.isSuccess.isTrue ? "images/check_in_success_icon.png" : "images/check_in_failed_icon.png", height: 14),
                                const SizedBox(width: 10),
                                Text(
                                    controller.isSuccess.isTrue ? "Selamat kamu berhasil melakukan Check in" : "Checkin Gagal ${controller.error.value}, coba Kembali",
                                    style: TextStyle(color: controller.isSuccess.isTrue ? Color(0xFF12B76A) : Color(0xFFF04438), fontSize: 10),
                                )
                            ],
                        ),
                    )
                        : Container(),
                ],
            )
        );
    }
}