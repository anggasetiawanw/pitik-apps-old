
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
 *@create date 11/09/2023
 */

class SmartScaleWeighing extends GetView<SmartScaleWeighingController> {

    @override
    Widget build(BuildContext context) {
        final SmartScaleWeighingController controller = Get.put(SmartScaleWeighingController(context: context));
        final DateTime currentDate = DateTime.now();

        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),
            ),
            body: Stack(
                children: [
                    Obx(() =>
                        controller.isLoading.isTrue ? // IF LOADING IS RUNNING
                        Center(child: ProgressLoading()) :
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
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
                                                        SizedBox(width: 8),
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
                                                        SizedBox(width: 8),
                                                        Text("Belum siap timbang!", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                    ]
                                                ],
                                            ),
                                            Text("Baterai: ${controller.batteryStatus.value}%", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange))
                                        ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 16, bottom: 8),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                color: GlobalVar.grayBackground
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text("Waktu Timbang", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                        SizedBox(height: 4),
                                                        Text(
                                                            "Mulai Timbang ${Convert.getYear(currentDate)}/${Convert.getMonthNumber(currentDate)}/${Convert.getDay(currentDate)} - ${Convert.getHour(currentDate)}.${Convert.getMinute(currentDate)}",
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
                                            SizedBox(width: 8),
                                            Expanded(child: controller.outstandingTotalWeighingField)
                                        ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width - 32,
                                            height: 1.6,
                                            color: GlobalVar.outlineColor,
                                        )
                                    ),
                                    Expanded(
                                        child: ListView(
                                            children: [
                                                SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(child: controller.totalChicken),
                                                        SizedBox(width: 8),
                                                        Expanded(child: controller.totalWeighing),
                                                        SizedBox(width: 8),
                                                        Padding(
                                                            padding: EdgeInsets.only(top: 28),
                                                            child: controller.isTimeout.isTrue ?
                                                                Container(
                                                                    width: 32,
                                                                    height: 32,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                        border: Border.all(width: 2, color: GlobalVar.grayLightText),
                                                                    ),
                                                                    child: GestureDetector(
                                                                        child: SvgPicture.asset('images/add_orange_icon.svg', width: 16, height: 16, color: GlobalVar.grayLightText),
                                                                        onTap: () {},
                                                                    )
                                                                ) :
                                                                Container(
                                                                    width: 32,
                                                                    height: 32,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                                                if (controller.smartScaleDataWidget.length > 0) ...[
                                                    Padding(
                                                        padding: EdgeInsets.only(top: 12),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Container(
                                                                    width: 40,
                                                                    child: Text("No", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                                                ),
                                                                SizedBox(width: 8),
                                                                Expanded(child: Text("Jumlah Ayam", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))),
                                                                SizedBox(width: 8),
                                                                Expanded(child: Text("Timbangan", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))),
                                                                SizedBox(width: 40),
                                                            ]
                                                        )
                                                    )
                                                ] else ...[
                                                    SizedBox()
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
                                                SizedBox(height: 120),
                                            ]
                                        )
                                    )
                                ],
                            )
                        )
                    ),
                    bottomNavBar()
                ],
            ),
        );
    }

    Widget appBar() => AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
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
                                child: ButtonFill(
                                    controller: GetXCreator.putButtonFillController("submitSmartScaleWeighing"),
                                    label: "Selesai",
                                    onClick: () {
                                        GlobalVar.track("Click_button_submit_timbang_ayam");
                                        controller.saveSmartScaleWeighing();
                                    },
                                )),
                        ],
                    ),
                ),
            ],
        )
    );
}