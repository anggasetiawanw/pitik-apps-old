// ignore_for_file: must_be_immutable

import 'package:components/expandable_device/expandable_device.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/building_model.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/sensor_data_model.dart';
import 'package:components/expandable_monitor_real_time/expandable_monitor_real_time.dart';
import 'detail_smartmonitor_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class DetailSmartMonitor extends GetView<DetailSmartMonitorController> {
    Widget? widgetLoading;
    Coop coop;
    Device? device;

    DetailSmartMonitor({super.key, required this.coop, this.device, this.widgetLoading});

    DetailSmartMonitorController getController() {
        return controller;
    }

    @override
    Widget build(BuildContext context) {
        final DetailSmartMonitorController controller = Get.put(DetailSmartMonitorController(
            context: context,
            coop: coop,
            device: device
        ));

        showButtonDialog(BuildContext context, DetailSmartMonitorController controller) {
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
                                child: Stack(children: [
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
                                                    onTap: () {
                                                        GlobalVar.track("Click_option_menu_edit_monitoring");
                                                        Get.back();
                                                        // Get.toNamed(RoutePage.modifySmartMonitorPage, arguments:[controller.coop, controller.device, "edit"])!.then((value) {
                                                        //     controller.isLoading.value = true;
                                                        //     Timer(const Duration(milliseconds: 500), () {
                                                        //         controller.getLatestDataSmartMonitor();
                                                        //     });
                                                        // });
                                                    },
                                                    child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            const SizedBox(
                                                                width: 8,),
                                                            DefaultTextStyle(
                                                                style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                                child: const Text("Edit"),
                                                            )
                                                        ]
                                                    )
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                        GlobalVar.track("Click_option_menu_rename");
                                                        Get.back();
                                                        // Get.toNamed(RoutePage.modifySmartMonitorPage, arguments:[controller.coop, controller.device, "rename"])!.then((value) {
                                                        //     controller.isLoading.value =true;
                                                        //     value == null ? controller.deviceUpdatedName.value = "" : controller.deviceUpdatedName.value = value[0]["backValue"];
                                                        //     Timer(const Duration(milliseconds: 500), () {
                                                        //         controller.getLatestDataSmartMonitor();
                                                        //     });
                                                        // });
                                                    },
                                                    child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            const SizedBox(
                                                                width: 8,),
                                                            DefaultTextStyle(
                                                                style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                                child: const Text(
                                                                  "Ubah Nama"),
                                                            )
                                                        ]
                                                    )
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
                                ])
                            )
                        )
                    );
                }
            );
        }

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back()
                ),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title: Obx(() =>
                    controller.deviceUpdatedName.value == "" ?
                    Text("${controller.device!.deviceName}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium)) :
                    Text("${controller.deviceUpdatedName}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium))
                ),
                actions: [
                    if(GlobalVar.canModifyInfrasturucture())...[
                        GestureDetector(
                            onTap: () {
                                GlobalVar.track("Click_option_menu");
                                showButtonDialog(context, controller);
                            },
                            child: Container(
                                color: Colors.transparent,
                                height: 32,
                                width: 32,
                                margin: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
                                child: SvgPicture.asset("images/dot_icon.svg"),
                            )
                        )
                    ]
                ]
            );
        }

        Widget customExpandable(String headerText, String icon, SensorData? sensorData) {
            if (device == null) {
                return  ExpandableMonitorRealTime(
                    controller: GetXCreator.putAccordionMonitorRealTimeController("smartMonitorRealTimeCard$headerText", context),
                    headerText: "${headerText[0].toUpperCase()}${headerText.substring(1)}",
                    value: "${sensorData == null || sensorData.value == null ? 'N/A' : sensorData.value}",
                    valueTextColor: sensorData == null || sensorData.status == null ? 0xFF2C2B2B : sensorData.status == "good" ? 0xFF14CB82 : sensorData.status == "bad" ? 0xFFDD1E25 : 0xFF2C2B2B,
                    icon: icon,
                    unitValue: sensorData == null || sensorData.uom == null ? '' : headerText == "temperature" ? "°C" : sensorData.uom!,
                    onExpand : (bool isExpand) {
                        if (!isExpand) {
                            headerText == "temperature" ? GlobalVar.track("Click_Suhu"):
                            headerText == "Kelembaban" ? GlobalVar.track("Click_Kelembaban") :
                            headerText == "Heat Stress" ? GlobalVar.track("Click_Heat_Stress") :
                            headerText == "Kecepatan Angin" ? GlobalVar.track("Click_Kecepatan_Angin") :
                            headerText == "Lampu" ? GlobalVar.track("Click_Cahaya") :
                            headerText == "Amonia" ? GlobalVar.track("Click_Ammonia") :"";
                        } else {
                            // controller.getHistoricalData(headerText);
                        }
                    },
                    coop: coop,
                    roomId: controller.spBuilding.value.getController().selectedObject == null || (controller.spBuilding.value.getController().selectedObject as Building).roomId == null ? '' :
                            (controller.spBuilding.value.getController().selectedObject as Building).roomId!,
                    targetLabel: headerText == "temperature" ? "Target" :
                                 headerText == "Kelembaban" ? "Target" :
                                 headerText == "Heat Stress" ? "" :
                                 headerText == "Kecepatan Angin" ? "" :
                                 headerText == "Lampu" ? "" :
                                 headerText == "Amonia" ? "Standard" :"",
                    averageLabel: headerText == "temperature" ? "Rata-Rata" :
                                  headerText == "Kelembaban" ? "Rata-Rata" :
                                  headerText == "Heat Stress" ? "Siklus Sekarang" :
                                  headerText == "Kecepatan Angin" ? "Siklus Sekarang" :
                                  headerText == "Lampu" ? "Siklus Sekarang" :
                                  headerText == "Amonia" ? "Mics-amonia" :"",
                    sensorType: headerText == "temperature" ? "temperature" :
                                headerText == "Heat Stress" ? "heatStressIndex" :
                                headerText == "Kecepatan Angin" ? "wind" :
                                headerText == "Lampu" ? "lights" :
                                headerText == "Amonia" ? "ammonia" :
                                "relativeHumidity",
                );
            } else {
                return  ExpandableDevice(
                    controller: GetXCreator.putAccordionDeviceController("smartMonitorCard$headerText", context),
                    headerText: "${headerText[0].toUpperCase()}${headerText.substring(1)}",
                    value: "${sensorData == null || sensorData.value == null ? 'N/A' : sensorData.value}",
                    valueTextColor: sensorData == null || sensorData.status == null ? 0xFF2C2B2B : sensorData.status == "good" ? 0xFF14CB82 : sensorData.status == "bad" ? 0xFFDD1E25 : 0xFF2C2B2B,
                    icon: icon,
                    unitValue: sensorData == null || sensorData.uom == null ? '' : headerText == "temperature" ? "°C" : sensorData.uom!,
                    onExpand : (bool isExpand) {
                        if (!isExpand) {
                            headerText == "temperature" ? GlobalVar.track("Click_Suhu"):
                            headerText == "Kelembaban" ? GlobalVar.track("Click_Kelembaban") :
                            headerText == "Heat Stress" ? GlobalVar.track("Click_Heat_Stress") :
                            headerText == "Kecepatan Angin" ? GlobalVar.track("Click_Kecepatan_Angin") :
                            headerText == "Lampu" ? GlobalVar.track("Click_Cahaya") :
                            headerText == "Amonia" ? GlobalVar.track("Click_Ammonia") :"";
                        } else {
                            // controller.getHistoricalData(headerText);
                        }
                    },
                    device: controller.device!,
                    targetLabel: headerText == "temperature" ? "Target" :
                                 headerText == "Kelembaban" ? "Target" :
                                 headerText == "Heat Stress" ? "" :
                                 headerText == "Kecepatan Angin" ? "" :
                                 headerText == "Lampu" ? "" :
                                 headerText == "Amonia" ? "Standard" :"",
                    averageLabel: headerText == "temperature" ? "Rata-Rata" :
                                  headerText == "Kelembaban" ? "Rata-Rata" :
                                  headerText == "Heat Stress" ? "Siklus Sekarang" :
                                  headerText == "Kecepatan Angin" ? "Siklus Sekarang" :
                                  headerText == "Lampu" ? "Siklus Sekarang" :
                                  headerText == "Amonia" ? "Mics-amonia" :"",
                    sensorType: headerText == "temperature" ? "temperature" :
                                headerText == "Heat Stress" ? "heatStressIndex" :
                                headerText == "Kecepatan Angin" ? "wind" :
                                headerText == "Lampu" ? "lights" :
                                headerText == "Amonia" ? "ammonia" :
                                "relativeHumidity",
                );
            }
        }

        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: controller.device != null ? appBar() : const SizedBox(),
                ),
                body: RefreshIndicator(
                    onRefresh: () => Future.delayed(
                        const Duration(milliseconds: 200), () => controller.getInitialLatestDataSmartMonitor()
                    ),
                    child: Stack(
                        children: [
                            controller.isLoading.isTrue ? (widgetLoading == null ? const Center(child: ProgressLoading()) : widgetLoading!) :
                            // controller.deviceSummary == null ? ListView(
                            //     physics: const AlwaysScrollableScrollPhysics(),
                            //     children: [
                            //         Padding(
                            //             padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height / 2) - 115),
                            //             child: Column(
                            //                 children: [
                            //                     SvgPicture.asset("images/empty_icon.svg", width: 96, height: 86),
                            //                     const SizedBox(height: 17),
                            //                     Text("Data Smart Monitor Belum Ada", textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))
                            //                 ]
                            //             ),
                            //         )
                            //     ]
                            // ) :
                            ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                    device == null ? controller.spBuilding.value : const SizedBox(),
                                    Container(
                                        margin: const EdgeInsets.symmetric(vertical: 16),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                customExpandable("temperature","images/temperature_icon.svg", controller.deviceSummary == null || controller.deviceSummary!.temperature == null ? null : controller.deviceSummary!.temperature),
                                                customExpandable("Kelembaban", "images/humidity_icon.svg", controller.deviceSummary == null || controller.deviceSummary!.relativeHumidity == null ? null : controller.deviceSummary!.relativeHumidity),
                                                customExpandable("Amonia", "images/amonia_icon.svg", controller.deviceSummary == null || controller.deviceSummary!.ammonia == null ? null : controller.deviceSummary!.ammonia),
                                                customExpandable("Heat Stress", "images/heater_icon.svg", controller.deviceSummary == null || controller.deviceSummary!.heatStressIndex == null ? null : controller.deviceSummary!.heatStressIndex),
                                                customExpandable("Kecepatan Angin", "images/wind_icon.svg", controller.deviceSummary == null || controller.deviceSummary!.wind == null ? null : controller.deviceSummary!.wind),
                                                customExpandable("Lampu", "images/lamp_icon.svg", controller.deviceSummary == null || controller.deviceSummary!.lights == null ? null : controller.deviceSummary!.lights),
                                            ],
                                        )
                                    )
                                ],
                            )
                        ]
                    )
                )
            )
        );
    }
}
