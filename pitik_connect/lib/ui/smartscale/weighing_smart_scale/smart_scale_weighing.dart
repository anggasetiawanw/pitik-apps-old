// ignore_for_file: slash_for_doc_comments, use_key_in_widget_constructors

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pitik_connect/ui/smartscale/weighing_smart_scale/smart_scale_weighing_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class SmartScaleWeighingActivity extends GetView<SmartScaleWeighingController> {

    @override
    Widget build(BuildContext context) {
        final SmartScaleWeighingController controller = Get.put(SmartScaleWeighingController(context: context));

        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),
            ),
            body: Obx(() =>
                Stack(
                    children: [
                        controller.isLoading.isTrue ? // IF LOADING IS RUNNING
                        const Center(child: ProgressLoading()) :
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                                children: [
                                    const SizedBox(height: 16),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Row(
                                                children: [
                                                    if (controller.isTimeout.isFalse) ... [
                                                        Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration: BoxDecoration(
                                                                color: GlobalVar.green,
                                                                shape: BoxShape.circle
                                                            )
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text("Sudah siap timbang!", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ] else ... [
                                                        Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration: BoxDecoration(
                                                                color: GlobalVar.red,
                                                                shape: BoxShape.circle
                                                            )
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text("Belum siap timbang!", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ]
                                                ],
                                            ),
                                            Text("Baterai: ${controller.batteryStatus.value}%", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange))
                                        ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                color: GlobalVar.grayBackground
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.all(16),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text("Waktu Timbang", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                            "Mulai Timbang ${Convert.getYear(controller.startWeighingTime)}/${Convert.getMonthNumber(controller.startWeighingTime)}/${Convert.getDay(controller.startWeighingTime)} - ${Convert.getHour(controller.startWeighingTime)}.${Convert.getMinute(controller.startWeighingTime)}",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ),
                                    ),
                                    Row(
                                        children: [
                                            Expanded(child: controller.totalWeighingField),
                                            const SizedBox(width: 8),
                                            Expanded(child: controller.outstandingTotalWeighingField)
                                        ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width - 32,
                                            height: 1.6,
                                            color: GlobalVar.outlineColor,
                                        )
                                    ),
                                    Expanded(
                                        child: ListView(
                                            children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(child: controller.totalChicken),
                                                        const SizedBox(width: 8),
                                                        Expanded(child: controller.totalWeighing),
                                                        const SizedBox(width: 8),
                                                        Padding(
                                                            padding: const EdgeInsets.only(top: 28),
                                                            child:
                                                            // controller.isTimeout.isTrue ?
                                                            // Container(
                                                            //     width: 32,
                                                            //     height: 32,
                                                            //     decoration: BoxDecoration(
                                                            //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                            //         border: Border.all(width: 2, color: GlobalVar.grayLightText),
                                                            //     ),
                                                            //     child: GestureDetector(
                                                            //         child: SvgPicture.asset('images/add_orange_icon.svg', width: 16, height: 16, color: GlobalVar.grayLightText),
                                                            //         onTap: () {},
                                                            //     )
                                                            // ) :
                                                            Container(
                                                                width: 32,
                                                                height: 32,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                                    border: Border.all(width: 2, color: GlobalVar.primaryOrange),
                                                                ),
                                                                child: GestureDetector(
                                                                    child: SvgPicture.asset('images/add_orange_icon.svg', width: 16, height: 16),
                                                                    onTap: () => controller.addWeighing(null),
                                                                )
                                                            )
                                                        )
                                                    ]
                                                ),
                                                if (controller.smartScaleDataWidget.isNotEmpty) ...[
                                                    Padding(
                                                        padding: const EdgeInsets.only(top: 12),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                SizedBox(
                                                                    width: 40,
                                                                    child: Text("No", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                                ),
                                                                const SizedBox(width: 8),
                                                                Expanded(child: Text("Jumlah Ayam", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))),
                                                                const SizedBox(width: 8),
                                                                Expanded(child: Text("Timbangan", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))),
                                                                const SizedBox(width: 40),
                                                            ]
                                                        )
                                                    )
                                                ] else ...[
                                                    const SizedBox()
                                                ],
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Column(children: controller.smartScaleDataWidgetNumber.entries.map( (entry) => entry.value).toList()),
                                                        Expanded(
                                                            child: Column(children: controller.smartScaleDataWidget.entries.map( (entry) => entry.value).toList())
                                                        )
                                                    ],
                                                ),
                                                const SizedBox(height: 120),
                                            ]
                                        )
                                    )
                                ],
                            )
                        ),
                        if (controller.isLoading.isTrue) ...[
                            const SizedBox()
                        ] else ...[
                            bottomNavBar()
                        ]
                    ],
                )
            ),
        );
    }

    Widget appBar() => AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text("Timbang Ayam", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium)),
    );

    Widget bottomNavBar() => Align(
        alignment: Alignment.bottomCenter,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                                child: ButtonFill(
                                    controller: GetXCreator.putButtonFillController("submitSmartScaleWeighing"),
                                    label: "Selesai",
                                    onClick: () {
                                        GlobalVar.track("Click_button_submit_timbang_ayam");
                                        controller.saveSmartScaleWeighing();
                                    }
                                )
                            )
                        ]
                    )
                )
            ]
        )
    );
}