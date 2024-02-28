// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'detail_smartcontroller_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class SmartControllerDashboard extends GetView<SmartControllerDashboardController> {
    const SmartControllerDashboard({super.key});

    static const ALARM_PATH = "alarm_path";
    static const COOLER_PATH = "cooler_path";
    static const FAN_PATH = "fan_path";
    static const GROWTH_DAY_PATH = "growth_day_path";
    static const HEATER_PATH = "heater_path";
    static const LAMP_PATH = "lamp_path";
    static const RESET_PATH = "reset_path";

    @override
    Widget build(BuildContext context) {
        final SmartControllerDashboardController controller = Get.put(SmartControllerDashboardController(context: context));

        showButtonDialog(BuildContext context, SmartControllerDashboardController controller) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                    return Align(
                        alignment: const Alignment(1, -1),
                        child: GestureDetector(
                            onTap: () {
                                // _showBottomDialog(context, controller);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 50, right: 30),
                                width: 135,
                                height: 66,
                                child: Stack(
                                    children: [
                                        Container(
                                            margin: const EdgeInsets.only(top: 8),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(6)),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    GestureDetector(
                                                        child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                const SizedBox(width: 8),
                                                                DefaultTextStyle(
                                                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                                    child: const Text("Edit")
                                                                )
                                                            ]
                                                        ),
                                                        onTap: (){
                                                            GlobalVar.track("Click_option_menu_edit_controller");
                                                            Get.back();
                                                            Get.toNamed(controller.modifySmartMonitorPage!, arguments:[controller.coop, controller.device, "edit"])!.then((value) {
                                                                controller.isLoading.value = true;
                                                                Timer(const Duration(milliseconds: 500), () => controller.getDetailSmartController());
                                                            });
                                                        },
                                                    ),
                                                    GestureDetector(
                                                        child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                const SizedBox(width: 8),
                                                                DefaultTextStyle(
                                                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                                    child: const Text("Ubah Nama")
                                                                )
                                                            ]
                                                        ),
                                                        onTap: (){
                                                            GlobalVar.track("Click_option_menu_rename");
                                                            Get.back();
                                                            Get.toNamed(controller.modifySmartMonitorPage!, arguments:[controller.coop, controller.device, "rename"])!.then((value) {
                                                                controller.isLoading.value =true;
                                                                value == null ? controller.deviceUpdatedName.value = "" : controller.deviceUpdatedName.value = value[0]["backValue"];
                                                                Timer(const Duration(milliseconds: 500), () => controller.getDetailSmartController());
                                                            });
                                                        }
                                                    )
                                                ]
                                            )
                                        ),
                                        Align(
                                            alignment: const Alignment(1, -1),
                                            child: Image.asset(
                                                "images/triangle_icon.png",
                                                height: 17,
                                                width: 17,
                                            ),
                                        )
                                    ]
                                ),
                            ),
                        )
                    );
                },
            );
        }

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Text(" ${controller.device.deviceName}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),),
                actions: [
                    if(GlobalVar.canModifyInfrasturucture() && controller.modifySmartMonitorPage != null)...[
                        GestureDetector(
                            onTap: () => showButtonDialog(context, controller),
                            child: Container(
                                color: Colors.transparent,
                                height: 32,
                                width: 32,
                                margin: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
                                child: SvgPicture.asset("images/dot_icon.svg"),
                            ),
                        ),
                    ]
                ],
            );
        }

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),
            ),
            body: RefreshIndicator(
                color: GlobalVar.primaryOrange,
                backgroundColor: Colors.white,
                onRefresh: () => Future.delayed(
                    const Duration(milliseconds: 200), () => controller.getDetailSmartController()
                ),
                child: Stack(
                    children: [
                        Container(
                            margin: const EdgeInsets.only(left: 16 , right: 16),
                            child: Obx(() => controller.isLoading.isTrue ?
                                const Center(
                                    child : Center(
                                        child: SizedBox(
                                            height: 124,
                                            width: 124,
                                            child: ProgressLoading(),
                                        ),
                                    ) ,
                                ) : controller.deviceController == null ?
                                Center(
                                    child: Container(
                                        width: double.infinity,
                                        height: MediaQuery. of(context). size. height,
                                        margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                                        child: Column(
                                            children: [
                                                SvgPicture.asset("images/empty_icon.svg"),
                                                const SizedBox(height: 17),
                                                Text("Data Smart Controller Belum Ada", textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        )
                                    )
                                ) :
                                SingleChildScrollView(
                                    child: Column(
                                        children: [
                                            Container(
                                                margin: const EdgeInsets.only(bottom: 10, right: 4, left: 4),
                                                child: controller.monitorContainer.value
                                            ),
                                            controller.itemGridview(MediaQuery.of(context).size.width)
                                        ]
                                    )
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}
