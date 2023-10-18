

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class BoardingActivity extends StatefulWidget {
    const BoardingActivity({super.key});

    @override
    State<StatefulWidget> createState() => BoardingState();
}

class BoardingState extends State<BoardingActivity> {
    int state = 0;

    late ButtonFill btnNext;

    @override
    void initState() {
        super.initState();
        btnNext = ButtonFill(controller: GetXCreator.putButtonFillController("boardingNext"), label: "Lanjut", onClick: () => _movePage());
    }

    void _movePage() {
        if (state == 0) {
            setState(() => state = 1);
        } else if (state == 1) {
            setState(() {
                state = 2;
                btnNext.getController().changeLabel('Mulai');
            });
        } else if (state == 2) {
            Get.offNamed(RoutePage.loginPage);
        }
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: WillPopScope(
                    onWillPop: () async {
                        if (state > 0) {
                            setState(() {
                                state--;
                                btnNext.getController().changeLabel('Lanjut');
                            });

                            return false;
                        } else {
                            return true;
                        }
                    },
                    child: Stack(
                        children: [
                            Positioned(
                                top: 16,
                                left: 16,
                                right: 16,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Row(
                                            children: [
                                                state == 0 ? Container(
                                                    decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                        color: GlobalVar.primaryOrange
                                                    ),
                                                    height: 8,
                                                    width: 18,
                                                ) : Container(
                                                    decoration: const BoxDecoration(
                                                        color: GlobalVar.gray,
                                                        shape: BoxShape.circle
                                                    ),
                                                    height: 8,
                                                    width: 8,
                                                ),
                                                const SizedBox(width: 8),
                                                state == 1 ? Container(
                                                    decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                        color: GlobalVar.primaryOrange
                                                    ),
                                                    height: 8,
                                                    width: 18,
                                                ) : Container(
                                                    decoration: const BoxDecoration(
                                                        color: GlobalVar.gray,
                                                        shape: BoxShape.circle
                                                    ),
                                                    height: 8,
                                                    width: 8,
                                                ),
                                                const SizedBox(width: 8),
                                                state == 2 ? Container(
                                                    decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                        color: GlobalVar.primaryOrange
                                                    ),
                                                    height: 8,
                                                    width: 18,
                                                ) : Container(
                                                    decoration: const BoxDecoration(
                                                        color: GlobalVar.gray,
                                                        shape: BoxShape.circle
                                                    ),
                                                    height: 8,
                                                    width: 8,
                                                )
                                            ]
                                        ),
                                        state == 0 || state == 1 ? GestureDetector(
                                            onTap: () => Get.offNamed(RoutePage.loginPage),
                                            child: Row(
                                                children: [
                                                    Text('Lewati', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                    const SizedBox(width: 8),
                                                    const Icon(Icons.arrow_forward_ios, size: 14)
                                                ],
                                            ),
                                        ) : const SizedBox(),
                                    ],
                                )
                            ),
                            Positioned.fill(
                                left: 16,
                                right: 16,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        const SizedBox(height: 32),
                                        state == 0 ? SvgPicture.asset('images/boarding_one_icon.svg') :
                                        state == 1 ? SvgPicture.asset('images/boarding_two_icon.svg') :
                                            SvgPicture.asset('images/boarding_three_icon.svg'),
                                        const SizedBox(height: 16),
                                        state == 0 ? Text('Pendapatan Tinggi dan Stabil', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange)) :
                                        state == 1 ? Text('Kualitas Sapronak Baik dan Teruji', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange)) :
                                            Text('Penggunaan Teknologi untuk Budidaya Ayam', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange)),
                                        const SizedBox(height: 8),
                                        state == 0 ? Text(
                                            'Harga ayam kompetitif dengan skema insentif yang adil dan transparan untuk menjamin pendapatan peternak',
                                            textAlign: TextAlign.center,
                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                        ) :
                                        state == 1 ? Text(
                                            'Kualitas sapronak unggul dari produsen ternama dan diuji dengan menggunakan teknologi Pitik',
                                            textAlign: TextAlign.center,
                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                        ) : Text(
                                            'Pantau kondisi kandang secara real-time menggunakan IoT serta dukungan dari algoritma Pitik untuk meningkatkan efisiensi kandang',
                                            textAlign: TextAlign.center,
                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                        ),
                                    ],
                                )
                            ),
                            Positioned(
                                bottom: 0,
                                left: 32,
                                right: 32,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 32),
                                    child: btnNext,
                                )
                            )
                        ]
                    )
                )
            )
        );
	}
}