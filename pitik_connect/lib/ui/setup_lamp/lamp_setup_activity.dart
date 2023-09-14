
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'lamp_setup_controller.dart';

/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 28/07/23
 */

class LampSetup extends GetView<LampSetupController>{
    const LampSetup({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        LampSetupController controller = Get.put(LampSetupController(context: context));

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Text(
                    "Lampu",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
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
                                        child: Obx(() => controller.isEdit.isTrue ?
                                        ButtonFill(
                                            controller: GetXCreator.putButtonFillController("bfSaveSetingLamp"),
                                            label: "Simpan",
                                            onClick: () {
                                                showBottomDialog(context, controller);
                                            },
                                        ):
                                        ButtonFill(
                                            controller: GetXCreator.putButtonFillController("bfEditSettingFan"),
                                            label: "Edit",
                                            onClick: () {
                                                controller.isEdit.value = true;
                                                controller.isLoading.value = true;
                                                controller.loadPage();
                                            },
                                        )
                                        ) ,
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
                preferredSize: const Size.fromHeight(60),
                child: appBar(),
            ),
            body: Stack(
                children: [
                    Obx(() => controller.isLoading.isTrue ?
                    Container(
                        child: Center(
                            child: ProgressLoading(),
                        ),
                    ) :
                    SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    controller.dtfLampOn,
                                    controller.dtfLampOff,
                                    const SizedBox(
                                        height: 120,
                                    )],
                            ),
                        ),
                    )
                    ),
                    bottomNavBar()
                ],

            ));

    }

    showBottomDialog(BuildContext context, LampSetupController controller) {
        return showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                        ),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: EdgeInsets.only(top: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: GlobalVar.outlineColor,
                                    borderRadius: BorderRadius.circular(2),
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 24, left: 16, right: 73),
                                child: Text(
                                    "Apakah kamu yakin data yang dimasukan sudah benar?",
                                    style: GlobalVar.primaryTextStyle
                                        .copyWith(fontSize: 21, fontWeight: GlobalVar.bold),
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 8, left: 16, right: 52),
                                child: Text(
                                    "Pastikan semua data yang kamu masukan semua sudah benar",
                                    style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 24),
                                child: SvgPicture.asset(
                                    "images/ask_bottom_sheet_1.svg",
                                ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: controller.bfYesSetingLamp),
                                        const SizedBox(
                                            width: 16,
                                        ),
                                        Expanded(
                                            child: controller.boNoSettingLamp,
                                        ),
                                    ],
                                ),
                            ),
                            const SizedBox(height: GlobalVar.bottomSheetMargin,)
                        ],
                    ),
                );
            });
    }


}
