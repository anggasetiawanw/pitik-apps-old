import 'dart:async';

import 'package:components/expandable_device/expandable_device.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/sensor_data_model.dart';

import '../../route.dart';
import 'detail_smartmonitor_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/07/23

class DetailSmartMonitor extends GetView<DetailSmartMonitorController> {
  const DetailSmartMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailSmartMonitorController controller = Get.put(DetailSmartMonitorController(
      context: context,
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
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                GlobalVar.track('Click_option_menu_edit_monitoring');
                                Get.back();
                                Get.toNamed(RoutePage.modifySmartMonitorPage, arguments: [controller.coop, controller.device, 'edit'])!.then((value) {
                                  controller.isLoading.value = true;
                                  Timer(const Duration(milliseconds: 500), () {
                                    controller.getLatestDataSmartMonitor();
                                  });
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  DefaultTextStyle(
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                    child: const Text('Edit'),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                GlobalVar.track('Click_option_menu_rename');
                                Get.back();
                                Get.toNamed(RoutePage.modifySmartMonitorPage, arguments: [controller.coop, controller.device, 'rename'])!.then((value) {
                                  controller.isLoading.value = true;
                                  value == null ? controller.deviceUpdatedName.value = '' : controller.deviceUpdatedName.value = value[0]['backValue'];
                                  Timer(const Duration(milliseconds: 500), () {
                                    controller.getLatestDataSmartMonitor();
                                  });
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  DefaultTextStyle(
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                    child: const Text('Ubah Nama'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Align(
                      alignment: const Alignment(1, -1),
                      child: Image.asset(
                        'images/triangle_icon.png',
                        height: 17,
                        width: 17,
                      ),
                    )
                  ]),
                ),
              ));
        },
      );
    }

    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Obx(() => controller.deviceUpdatedName.value == ''
            ? Text(
                '${controller.device.deviceName}',
                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
              )
            : Text(
                '${controller.deviceUpdatedName}',
                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
              )),
        actions: [
          if (GlobalVar.canModifyInfrasturucture()) ...[
            GestureDetector(
              onTap: () {
                GlobalVar.track('Click_option_menu');
                showButtonDialog(context, controller);
              },
              child: Container(
                color: Colors.transparent,
                height: 32,
                width: 32,
                margin: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
                child: SvgPicture.asset('images/dot_icon.svg'),
              ),
            )
          ]
        ],
      );
    }

    Widget customExpandable(String headerText, String icon, SensorData sensorData) {
      return ExpandableDevice(
        controller: GetXCreator.putAccordionDeviceController('smartMonitorCard$headerText', context),
        headerText: "${headerText[0].toUpperCase()}${headerText.substring(1)}",
        value: '${sensorData.value!}',
        valueTextColor: sensorData.status == 'good'
            ? 0xFF14CB82
            : sensorData.status == 'bad'
                ? 0xFFDD1E25
                : 0xFF2C2B2B,
        icon: icon,
        unitValue: headerText == 'temperature' ? '°C' : sensorData.uom!,
        onExpand: (bool isExpand) {
          if (!isExpand) {
            headerText == 'temperature'
                ? GlobalVar.track('Click_Suhu')
                : headerText == 'Kelembaban'
                    ? GlobalVar.track('Click_Kelembaban')
                    : headerText == 'Heat Stress'
                        ? GlobalVar.track('Click_Heat_Stress')
                        : headerText == 'Kecepatan Angin'
                            ? GlobalVar.track('Click_Kecepatan_Angin')
                            : headerText == 'Lampu'
                                ? GlobalVar.track('Click_Cahaya')
                                : headerText == 'Amonia'
                                    ? GlobalVar.track('Click_Ammonia')
                                    : '';
          } else {
            // controller.getHistoricalData(headerText);
          }
        },
        targetLabel: headerText == 'temperature'
            ? 'Target'
            : headerText == 'Kelembaban'
                ? 'Target'
                : headerText == 'Heat Stress'
                    ? ''
                    : headerText == 'Kecepatan Angin'
                        ? ''
                        : headerText == 'Lampu'
                            ? ''
                            : headerText == 'Amonia'
                                ? 'Standard'
                                : '',
        averageLabel: headerText == 'temperature'
            ? 'Rata-Rata'
            : headerText == 'Kelembaban'
                ? 'Rata-Rata'
                : headerText == 'Heat Stress'
                    ? 'Siklus Sekarang'
                    : headerText == 'Kecepatan Angin'
                        ? 'Siklus Sekarang'
                        : headerText == 'Lampu'
                            ? 'Siklus Sekarang'
                            : headerText == 'Amonia'
                                ? 'Mics-amonia'
                                : '',
        device: controller.device,
        sensorType: headerText == 'temperature'
            ? 'temperature'
            : headerText == 'Heat Stress'
                ? 'heatStressIndex'
                : headerText == 'Kecepatan Angin'
                    ? 'wind'
                    : headerText == 'Lampu'
                        ? 'lights'
                        : headerText == 'Amonia'
                            ? 'ammonia'
                            : 'relativeHumidity',
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBar(),
      ),
      body: Stack(
        children: [
          Obx(() => controller.isLoading.isTrue
              ? const Center(child: ProgressLoading())
              : controller.deviceSummary == null
                  ? Center(
                      child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                      child: Column(
                        children: [
                          SvgPicture.asset('images/empty_icon.svg'),
                          const SizedBox(
                            height: 17,
                          ),
                          Text(
                            'Data Smart Monitor Belum Ada',
                            textAlign: TextAlign.center,
                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                          )
                        ],
                      ),
                    ))
                  : SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            controller.deviceSummary!.temperature != null ? customExpandable('temperature', 'images/temperature_icon.svg', controller.deviceSummary!.temperature!) : Container(),
                            controller.deviceSummary!.relativeHumidity != null ? customExpandable('Kelembaban', 'images/humidity_icon.svg', controller.deviceSummary!.relativeHumidity!) : Container(),
                            controller.deviceSummary!.ammonia != null ? customExpandable('Amonia', 'images/amonia_icon.svg', controller.deviceSummary!.ammonia!) : Container(),
                            controller.deviceSummary!.heatStressIndex != null ? customExpandable('Heat Stress', 'images/heater_icon.svg', controller.deviceSummary!.heatStressIndex!) : Container(),
                            controller.deviceSummary!.wind != null ? customExpandable('Kecepatan Angin', 'images/wind_icon.svg', controller.deviceSummary!.wind!) : Container(),
                            controller.deviceSummary!.lights != null ? customExpandable('Lampu', 'images/lamp_icon.svg', controller.deviceSummary!.lights!) : Container(),
                          ],
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}
