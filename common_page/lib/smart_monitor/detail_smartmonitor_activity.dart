// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:components/expandable_device/expandable_device.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/building_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_summary_model.dart';
import 'package:model/sensor_data_model.dart';
import 'package:components/expandable_monitor_real_time/expandable_monitor_real_time.dart';
import 'detail_smartmonitor_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class DetailSmartMonitor extends StatelessWidget {
    DetailSmartMonitorController controller;
    Widget? widgetLoading;
    Device? device;
    String? modifySmartMonitorPage;
    String? deviceIdForController;
    String? coopIdForController;
    DeviceSummary? bundleLatestCondition;

    // for hide card
    bool hideBuildings;
    bool hideTemperature;
    bool hideHumidity;
    bool hideHeatStress;
    bool hideAmmonia;
    bool hideWind;
    bool hideLight;

    DetailSmartMonitor({super.key, required this.controller, this.device, this.widgetLoading, this.modifySmartMonitorPage, this.deviceIdForController, this.coopIdForController, this.bundleLatestCondition,
                        this.hideBuildings = false, this.hideTemperature = false, this.hideHumidity = false, this.hideHeatStress = false, this.hideAmmonia = false, this.hideWind = false, this.hideLight = false});
    DetailSmartMonitorController getController() => Get.find(tag: controller.tag);

    @override
    Widget build(BuildContext context) {
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
                                                        Get.toNamed(modifySmartMonitorPage!, arguments:[controller.coop, controller.device, "edit"])!.then((value) {
                                                            Timer(const Duration(milliseconds: 500), () => controller.getInitialLatestDataSmartMonitor());
                                                        });
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
                                                        Get.toNamed(modifySmartMonitorPage!, arguments:[controller.coop, controller.device, "rename"])!.then((value) {
                                                            value == null ? controller.deviceUpdatedName.value = "" : controller.deviceUpdatedName.value = value[0]["backValue"];
                                                            Timer(const Duration(milliseconds: 500), () => controller.getInitialLatestDataSmartMonitor());
                                                        });
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
                    if(GlobalVar.canModifyInfrasturucture() && modifySmartMonitorPage != null)...[
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

        Widget customExpandable(String sensorType, String icon, SensorData? sensorData) {
            if (device == null) {
                return  ExpandableMonitorRealTime(
                    controller: GetXCreator.putAccordionMonitorRealTimeController("smartMonitorRealTimeCard$sensorType", context),
                    headerText: sensorType == "temperature" ? "Temperatur" :
                                sensorType == "relativeHumidity" ? "Kelembaban" :
                                sensorType == "heatStressIndex" ? "Heat Stress" :
                                sensorType == "wind" ? "Kecepatan Angin" :
                                sensorType == "lights" ? "Lampu" :
                                sensorType == "ammonia" ? "Amonia" :
                                "",
                    value: "${sensorData == null || sensorData.value == null ? 'N/A' : sensorData.value}",
                    valueTextColor: sensorData == null || sensorData.status == null ? 0xFF2C2B2B : sensorData.status == "good" ? 0xFF14CB82 : sensorData.status == "bad" ? 0xFFDD1E25 : 0xFF2C2B2B,
                    icon: icon,
                    unitValue: sensorData == null || sensorData.uom == null ? '' : sensorType == "temperature" ? "°C" : sensorData.uom!,
                    onExpand : (bool isExpand) {
                        if (!isExpand) {
                            sensorType == "temperature" ? GlobalVar.track("Click_Suhu"):
                            sensorType == "relativeHumidity" ? GlobalVar.track("Click_Kelembaban") :
                            sensorType == "heatStressIndex" ? GlobalVar.track("Click_Heat_Stress") :
                            sensorType == "wind" ? GlobalVar.track("Click_Kecepatan_Angin") :
                            sensorType == "lights" ? GlobalVar.track("Click_Cahaya") :
                            sensorType == "ammonia" ? GlobalVar.track("Click_Ammonia") :"";
                        }
                    },
                    deviceIdForController: deviceIdForController,
                    coopIdForController: coopIdForController,
                    coop: controller.coop!,
                    roomId: controller.spBuilding.value.getController().selectedObject == null || (controller.spBuilding.value.getController().selectedObject as Building).roomId == null ? '' :
                            (controller.spBuilding.value.getController().selectedObject as Building).roomId!,
                    targetLabel: sensorType == "temperature" ? "Target" :
                                 sensorType == "relativeHumidity" ? "Target" :
                                 sensorType == "heatStressIndex" ? "" :
                                 sensorType == "wind" ? "" :
                                 sensorType == "lights" ? "" :
                                 sensorType == "ammonia" ? "Standard" :"",
                    averageLabel: sensorType == "temperature" ? "Rata-Rata" :
                                  sensorType == "relativeHumidity" ? "Rata-Rata" :
                                  sensorType == "heatStressIndexs" ? "Siklus Sekarang" :
                                  sensorType == "wind" ? "Siklus Sekarang" :
                                  sensorType == "lights" ? "Siklus Sekarang" :
                                  sensorType == "ammonia" ? "Mics-amonia" :"",
                    sensorType: sensorType,
                );
            } else {
                return  ExpandableDevice(
                    controller: GetXCreator.putAccordionDeviceController("smartMonitorCard$sensorType", context),
                    headerText: sensorType == "temperature" ? "Temperatur" :
                                sensorType == "relativeHumidity" ? "Kelembaban" :
                                sensorType == "heatStressIndex" ? "Heat Stress" :
                                sensorType == "wind" ? "Kecepatan Angin" :
                                sensorType == "lights" ? "Lampu" :
                                sensorType == "ammonia" ? "Amonia" :
                                "",
                    value: "${sensorData == null || sensorData.value == null ? 'N/A' : sensorData.value}",
                    valueTextColor: sensorData == null || sensorData.status == null ? 0xFF2C2B2B : sensorData.status == "good" ? 0xFF14CB82 : sensorData.status == "bad" ? 0xFFDD1E25 : 0xFF2C2B2B,
                    icon: icon,
                    unitValue: sensorData == null || sensorData.uom == null ? '' : sensorType == "temperature" ? "°C" : sensorData.uom!,
                    onExpand : (bool isExpand) {
                        if (!isExpand) {
                            sensorType == "temperature" ? GlobalVar.track("Click_Suhu"):
                            sensorType == "relativeHumidity" ? GlobalVar.track("Click_Kelembaban") :
                            sensorType == "heatStressIndex" ? GlobalVar.track("Click_Heat_Stress") :
                            sensorType == "wind" ? GlobalVar.track("Click_Kecepatan_Angin") :
                            sensorType == "lights" ? GlobalVar.track("Click_Cahaya") :
                            sensorType == "ammonia" ? GlobalVar.track("Click_Ammonia") :"";
                        }
                    },
                    device: controller.device!,
                    targetLabel: sensorType == "temperature" ? "Target" :
                                 sensorType == "relativeHumidity" ? "Target" :
                                 sensorType == "heatStressIndex" ? "" :
                                 sensorType == "wind" ? "" :
                                 sensorType == "lights" ? "" :
                                 sensorType == "ammonia" ? "Standard" :"",
                    averageLabel: sensorType == "temperature" ? "Rata-Rata" :
                                  sensorType == "relativeHumidity" ? "Rata-Rata" :
                                  sensorType == "heatStressIndexs" ? "Siklus Sekarang" :
                                  sensorType == "wind" ? "Siklus Sekarang" :
                                  sensorType == "lights" ? "Siklus Sekarang" :
                                  sensorType == "ammonia" ? "Mics-amonia" :"",
                    sensorType: sensorType,
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
                            ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                    !hideBuildings ? controller.spBuilding.value : const SizedBox(),
                                    Container(
                                        margin: const EdgeInsets.symmetric(vertical: 16),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                !hideTemperature ? customExpandable("temperature", "images/temperature_icon.svg", controller.deviceSummary.value == null || controller.deviceSummary.value!.temperature == null ? null : controller.deviceSummary.value!.temperature) : const SizedBox(),
                                                !hideHumidity ? customExpandable("relativeHumidity", "images/humidity_icon.svg", controller.deviceSummary.value == null || controller.deviceSummary.value!.relativeHumidity == null ? null : controller.deviceSummary.value!.relativeHumidity) : const SizedBox(),
                                                !hideHeatStress ? customExpandable("heatStressIndex", "images/heater_icon.svg", controller.deviceSummary.value == null || controller.deviceSummary.value!.heatStressIndex == null ? null : controller.deviceSummary.value!.heatStressIndex) : const SizedBox(),
                                                !hideAmmonia ? customExpandable("ammonia", "images/amonia_icon.svg", controller.deviceSummary.value == null || controller.deviceSummary.value!.ammonia == null ? null : controller.deviceSummary.value!.ammonia) : const SizedBox(),
                                                !hideWind ? customExpandable("wind", "images/wind_icon.svg", controller.deviceSummary.value == null || controller.deviceSummary.value!.wind == null ? null : controller.deviceSummary.value!.wind) : const SizedBox(),
                                                !hideLight ? customExpandable("lights", "images/lamp_icon.svg", controller.deviceSummary.value == null || controller.deviceSummary.value!.lights == null ? null : controller.deviceSummary.value!.lights) : const SizedBox(),
                                            ]
                                        )
                                    )
                                ]
                            )
                        ]
                    )
                )
            )
        );
    }
}
