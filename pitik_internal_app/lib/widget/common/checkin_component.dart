import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/text_style.dart';

class GpsComponent{
    static Future<dynamic> checkinSuccess(){
        return Get.dialog(Center(
        child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Row(
                        children: [
                            SvgPicture.asset(
                                "images/success_checkin.svg",
                                height: 24,
                                width: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                                "Check in Berhasil!",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.bold, decoration: TextDecoration.none),
                            ),
                        ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        "Selemat kamu telah berhasil melakukan check in",
                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 16),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Container(
                                height: 32,
                                width: 100,
                                color: Colors.transparent,
                            ),
                            SizedBox(
                                width: 100,
                                child: ButtonFill(
                                    controller:
                                    GetXCreator.putButtonFillController("Dialog"),
                                    label: "OK",
                                    onClick: () => Get.back()
                                ),
                            ),
                        ],
                    )
                ],
            ),),
        ));
    }

    static Future<dynamic> failedCheckin(String message){
        return  Get.dialog(Center(
                child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Row(
                                children: [
                                    SvgPicture.asset(
                                        "images/failed_checkin.svg",
                                        height: 24,
                                        width: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                        "Check in gagal!",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.bold, decoration: TextDecoration.none),
                                    ),
                                ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                                "Oops gagal melakukan check in, $message. Silahkan coba kembali.",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                            ),
                            const SizedBox(height: 16),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                        height: 32,
                                        width: 100,
                                        color: Colors.transparent,
                                    ),
                                    SizedBox(
                                        width: 100,
                                        child: ButtonFill(
                                            controller:
                                            GetXCreator.putButtonFillController("Dialog"),
                                            label: "OK",
                                            onClick: () => Get.back()
                                        ),
                                    ),
                                ],
                            )
                        ],
                    ),
                ),
            ));
    }
}