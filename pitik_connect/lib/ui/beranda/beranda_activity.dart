import 'dart:async';

import 'package:components/floor_status.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../route.dart';
import 'beranda_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 06/07/23


class BerandaActivity extends StatelessWidget {
    const BerandaActivity({super.key});

    @override
  Widget build(BuildContext context) {
        final BerandaController controller =
        Get.put(BerandaController(context: context));

        @override
        Widget header() {
            return Stack(
                children: [
                    SizedBox(
                        width: Get.width, child: Image.asset("images/header_bg.png")),
                    Container(
                        margin: const EdgeInsets.only(left: 16, right: 16, top: 42),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    "Selamat Datang\nDi Pitik Connect!",
                                    style: GlobalVar.whiteTextStyle
                                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                                ),
                                Container(
                                    // child: Row(
                                    //     children: [
                                    //         SvgPicture.asset("images/launcher_logo.svg", width: 24, height: 24)
                                    //     ],
                                    // ),
                                )

                            ],
                        ),
                    )
                ],
            );
        }

        Widget toolTab() {
            return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Container(
                            margin: const EdgeInsets.only(right: 8, left: 8),
                            child: Text(
                                "Daftar Kandang",
                                style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold)
                            ),
                        ),
                        SizedBox(
                            height: 36,
                            child: Row(
                                children: [
                                    GestureDetector(
                                        onTap: () {
                                            controller.isLoading.value = true;
                                            controller.setPreferences();
                                            controller.isLoading.value = false;
                                        },
                                        child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: const BoxDecoration(
                                                color:GlobalVar.iconHomeBg,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight: Radius.circular(4),
                                                    bottomRight: Radius.circular(4),
                                                    bottomLeft: Radius.circular(4))),
                                            child: Center(
                                                child: SvgPicture.asset("images/filter_icon.svg", width: 16, height: 12,),
                                            ),
                                        ),),
                                ],
                            ),
                        )
                    ],
                ),
            );
        }


        Widget listFloor() {
            return RefreshIndicator(
                color: GlobalVar.primaryOrange,
                backgroundColor: Colors.white,
              onRefresh: () async {
                  controller.isLoading.value = true;
                  controller.coops.value.clear();
                  controller.getDataCoops();
                  return Future<void>.delayed(const Duration(seconds: 3));
                  },
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.coops.value.length,
                    itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                                GlobalVar.track("Click_card_lantai");
                                Get.toNamed(RoutePage.dashboardDevicePage, arguments: controller.coops.value[index])!.then((value) {
                                    controller.isLoading.value = true;
                                    controller.coops.value.clear();
                                    Timer(const Duration(milliseconds: 500), () {
                                        controller.getDataCoops();
                                    });
                                });
                            },
                            child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: GlobalVar.outlineColor),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                                color:GlobalVar.iconHomeBg,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    topRight: Radius.circular(4),
                                                    bottomRight: Radius.circular(4),
                                                    bottomLeft: Radius.circular(4))),
                                            child: Center(
                                                child: SvgPicture.asset("images/building_icon.svg"),
                                            ),
                                        ),
                                         Expanded(
                                           child: Container(
                                               margin: const EdgeInsets.only(left: 8, right: 8),
                                             child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                     Text(
                                                         controller.coops.value[index].name!,
                                                         style: GlobalVar.blackTextStyle
                                                             .copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.ellipsis),
                                                     ),
                                                     const SizedBox(height: 4,),
                                                     Text(
                                                         controller.coops.value[index].room!.name!,
                                                         style: GlobalVar.greyTextStyle
                                                             .copyWith(fontSize: 10,overflow: TextOverflow.ellipsis),
                                                     )
                                                 ],
                                             ),
                                           ),
                                         ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                                FloorStatus(floorStatus: controller.coops.value[index].room!.status!),
                                            ],
                                        ),
                                ]
                                )
                            ),
                        );
                    }),
            );
        }

        return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
                children: [
                    Column(
                        children: [
                            header(),
                            const SizedBox(
                                height: 8,
                            ),
                            Obx(() => controller.isLoading.isTrue ?
                            const Column(
                                children: [
                                    SizedBox(height: 160,),
                                    ProgressLoading(),
                                ],
                            )  :
                            controller.isEmptyCoop.isTrue ?
                            Column(
                                children: [
                                    Container(
                                        padding: const EdgeInsets.all(12),
                                        margin: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(color: GlobalVar.outlineColor, width: 2),
                                                left: BorderSide(color: GlobalVar.outlineColor, width: 2),
                                                right: BorderSide(color: GlobalVar.outlineColor, width: 2),
                                                top: BorderSide(color: GlobalVar.outlineColor, width: 2),
                                            ),
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8), topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Row(
                                                    children: [
                                                        Padding(
                                                            padding: const EdgeInsets.all(6),
                                                            child: SvgPicture.asset("images/error_icon.svg", fit: BoxFit.cover, width: 24, height: 24),
                                                        ),
                                                        Text("Perhatian",  style: GlobalVar.blackTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium))
                                                    ]
                                                ),
                                                const SizedBox(
                                                    height: 4,
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(left: 6, right: 6),
                                                    child: Text(
                                                        "Kamu belum memiliki Kandang aktif dalam Peternakan kamu. yuk buat kandang!",
                                                        textAlign: TextAlign.left,
                                                        style: GlobalVar.greyTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                                    ),
                                                ),
                                                const SizedBox(
                                                    height: 8,
                                                ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: controller.bfAddCoop,
                                                        ),
                                                    ],
                                                ),
                                                const SizedBox(
                                                    height: 8,
                                                ),
                                            ]
                                        ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 64),
                                            width: double.infinity,
                                            child: Column(
                                                children: [
                                                    SvgPicture.asset("images/empty_icon.svg"),
                                                    const SizedBox(
                                                        height: 17,
                                                    ),
                                                    Text("Kamu belum memiliki Kandang aktif dalam Peternakan kamu. yuk buat kandang!",
                                                        textAlign: TextAlign.center,
                                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                                                ],)
                                        ),
                                    )
                                ],
                            ) : toolTab()

                            ),
                            Obx(() => controller.isEmptyCoop.isTrue || controller.isLoading.isTrue ? Container() : Expanded(child: listFloor())
                            )
                        ],
                    )

                ],
            ),
        );
    }
}
