import 'dart:async';

import 'package:components/device_controller_status.dart';
import 'package:components/global_var.dart';
import 'package:components/list_card_smartcontroller/card_list_controller.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../route.dart';
import 'detail_smartcontroller_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/07/23

class DetailSmartController extends GetView<DetailSmartControllerController> {
  const DetailSmartController({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailSmartControllerController controller = Get.put(DetailSmartControllerController(
      context: context,
    ));

    showButtonDialog(BuildContext context, DetailSmartControllerController controller) {
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  DefaultTextStyle(
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                    child: const Text(
                                      "Edit",
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                GlobalVar.track("Click_option_menu_edit_controller");
                                Get.back();
                                Get.toNamed(RoutePage.modifySmartMonitorPage, arguments: [controller.coop, controller.device, "edit"])!.then((value) {
                                  controller.isLoading.value = true;
                                  Timer(const Duration(milliseconds: 500), () {
                                    controller.getDetailSmartController();
                                  });
                                });
                              },
                            ),
                            GestureDetector(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  DefaultTextStyle(
                                    style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                    child: const Text("Ubah Nama"),
                                  ),
                                ],
                              ),
                              onTap: () {
                                GlobalVar.track("Click_option_menu_rename");
                                Get.back();
                                Get.toNamed(RoutePage.modifySmartMonitorPage, arguments: [controller.coop, controller.device, "rename"])!.then((value) {
                                  controller.isLoading.value = true;
                                  value == null ? controller.deviceUpdatedName.value = "" : controller.deviceUpdatedName.value = value[0]["backValue"];
                                  Timer(const Duration(milliseconds: 500), () {
                                    controller.getDetailSmartController();
                                  });
                                });
                              },
                            ),
                          ],
                        )),
                    Align(
                      alignment: const Alignment(1, -1),
                      child: Image.asset(
                        "images/triangle_icon.png",
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
        title: Text(
          " ${controller.device.deviceName}",
          style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
        ),
        actions: [
          if (GlobalVar.canModifyInfrasturucture()) ...[
            GestureDetector(
              onTap: () {
                showButtonDialog(context, controller);
              },
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

    /// The `itemGridview` function returns a GridView widget with a specified
    /// number of items per row and calculates the height based on the width of
    /// the screen.
    ///
    /// Args:
    ///   width (double): The `width` parameter is the width of the
    /// itemGridview. It is used to calculate the height of the itemGridview
    /// based on the number of items per row and the aspect ratio of the items.
    ///
    /// Returns:
    ///   The code is returning a widget called `itemGridview`.
    Widget itemGridview(double width) {
      const int count = 7;
      const int itemsPerRow = 2;
      const double ratio = 1 / 1;
      const double horizontalPadding = 0;
      final double calcHeight = ((width / itemsPerRow) - (horizontalPadding)) * (count / itemsPerRow).ceil() * (1 / ratio);
      return SizedBox(
        height: calcHeight,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 7,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0 && controller.deviceController!.growthDay != null) {
                    Get.toNamed(RoutePage.growthSetupPage, arguments: [controller.device, controller.deviceController!.fan])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  } else if (index == 1 && controller.deviceController!.fan != null) {
                    Get.toNamed(RoutePage.fanDashboardPage, arguments: [controller.device, controller.deviceController!.fan])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  } else if (index == 2 && controller.deviceController!.heater != null) {
                    Get.toNamed(RoutePage.heaterSetupPage, arguments: [controller.device, controller.deviceController!.heater])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  } else if (index == 3 && controller.deviceController!.cooler != null) {
                    Get.toNamed(RoutePage.coolerSetupPage, arguments: [controller.device, controller.deviceController!.cooler])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  } else if (index == 4 && controller.deviceController!.lamp != null) {
                    Get.toNamed(RoutePage.lampDashboardPage, arguments: [controller.device, controller.deviceController!.lamp])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  } else if (index == 5 && controller.deviceController!.alarm != null) {
                    Get.toNamed(RoutePage.alarmSetupPage, arguments: [controller.device, controller.deviceController!.alarm])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  } else if (index == 6 && controller.deviceController!.resetTime != null) {
                    Get.toNamed(RoutePage.resetTimePage, arguments: [controller.device, controller.deviceController!.resetTime])!.then((value) {
                      controller.isLoading.value = true;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getDetailSmartController();
                      });
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      height: 124,
                      width: 124,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: index == 0 && controller.deviceController!.growthDay != null
                              ? null
                              : index == 0 && controller.deviceController!.growthDay == null
                                  ? const Color(0xFFFDDFD1)
                                  : index == 1 && controller.deviceController!.fan != null
                                      ? null
                                      : index == 1 && controller.deviceController!.fan == null
                                          ? const Color(0xFFFDDFD1)
                                          : index == 2 && controller.deviceController!.heater != null
                                              ? null
                                              : index == 2 && controller.deviceController!.heater == null
                                                  ? const Color(0xFFFDDFD1)
                                                  : index == 3 && controller.deviceController!.cooler != null
                                                      ? null
                                                      : index == 3 && controller.deviceController!.cooler == null
                                                          ? const Color(0xFFFDDFD1)
                                                          : index == 4 && controller.deviceController!.lamp != null
                                                              ? null
                                                              : index == 4 && controller.deviceController!.lamp == null
                                                                  ? const Color(0xFFFDDFD1)
                                                                  : index == 5 && controller.deviceController!.alarm != null
                                                                      ? null
                                                                      : index == 5 && controller.deviceController!.alarm == null
                                                                          ? const Color(0xFFFDDFD1)
                                                                          : index == 6 && controller.deviceController!.resetTime != null
                                                                              ? null
                                                                              : index == 6 && controller.deviceController!.resetTime == null
                                                                                  ? const Color(0xFFFDDFD1)
                                                                                  : null,
                          border: Border.all(width: 1, color: GlobalVar.outlineColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: controller.deviceController!.growthDay == null ? const Color(0xFFFBB8A4) : GlobalVar.iconHomeBg,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomRight: Radius.circular(4), bottomLeft: Radius.circular(4))),
                                child: Center(
                                  child: index == 0 && (controller.deviceController!.growthDay == null || controller.deviceController!.growthDay!.status == false)
                                      ? SvgPicture.asset("images/growth_icon.svg")
                                      : index == 0 && controller.deviceController!.growthDay != null && controller.deviceController!.growthDay!.status! == true
                                          ? SvgPicture.asset("images/growth_icon.svg")
                                          : index == 1 && controller.deviceController!.fan != null && controller.deviceController!.fan!.status! == true
                                              ? SvgPicture.asset("images/fan_icon.svg")
                                              : index == 1 && (controller.deviceController!.fan == null || controller.deviceController!.fan!.status! == false)
                                                  ? SvgPicture.asset("images/fan_error_icon.svg")
                                                  : index == 2 && controller.deviceController!.heater != null && controller.deviceController!.heater!.status! == true
                                                      ? SvgPicture.asset("images/heater_icon.svg")
                                                      : index == 2 && (controller.deviceController!.heater == null || controller.deviceController!.heater!.status! == false)
                                                          ? SvgPicture.asset("images/heater_warning_icon.svg")
                                                          : index == 3 && controller.deviceController!.cooler != null && controller.deviceController!.cooler!.status! == true
                                                              ? SvgPicture.asset("images/cooler_icon.svg")
                                                              : index == 3 && (controller.deviceController!.cooler == null || controller.deviceController!.cooler!.status! == false)
                                                                  ? SvgPicture.asset("images/cooler_error_icon.svg")
                                                                  : index == 4 && controller.deviceController!.lamp != null && controller.deviceController!.lamp!.status! == true
                                                                      ? SvgPicture.asset("images/lamp_icon.svg")
                                                                      : index == 4 && (controller.deviceController!.lamp == null || controller.deviceController!.lamp!.status! == false)
                                                                          ? SvgPicture.asset("images/lamp_icon.svg")
                                                                          : index == 5 && controller.deviceController!.alarm != null
                                                                              ? SvgPicture.asset("images/alarm_icon.svg")
                                                                              : index == 5 && (controller.deviceController!.alarm == null)
                                                                                  ? SvgPicture.asset("images/alarm_error_icon.svg")
                                                                                  : index == 6 && controller.deviceController!.resetTime != null
                                                                                      ? SvgPicture.asset("images/timer_icon.svg")
                                                                                      : SvgPicture.asset("images/temperature_icon.svg"),
                                ),
                              ),
                              index == 0
                                  ? DeviceStatus(
                                      status: controller.deviceController!.growthDay!.status!,
                                      activeString: "Aktif",
                                      inactiveString: "Non-Aktif",
                                    )
                                  : index == 1
                                      ? DeviceStatus(
                                          status: controller.deviceController!.fan!.status!,
                                          activeString: "Aktif",
                                          inactiveString: "Non-Aktif",
                                        )
                                      : index == 2
                                          ? DeviceStatus(
                                              status: controller.deviceController!.heater!.status!,
                                              activeString: "Nyala",
                                              inactiveString: "Mati",
                                            )
                                          : index == 3
                                              ? DeviceStatus(
                                                  status: controller.deviceController!.cooler!.status!,
                                                  activeString: "Nyala",
                                                  inactiveString: "Mati",
                                                )
                                              : index == 4
                                                  ? DeviceStatus(
                                                      status: controller.deviceController!.lamp!.status!,
                                                      activeString: "Nyala",
                                                      inactiveString: "Mati",
                                                    )
                                                  : index == 5
                                                      ? const DeviceStatus(
                                                          status: true,
                                                          activeString: "Normal",
                                                          inactiveString: "Error",
                                                        )
                                                      : index == 6
                                                          ? const DeviceStatus(status: true, activeString: "Default", inactiveString: "Default")
                                                          : const SizedBox(height: 0),
                            ],
                          ),
                          index == 0
                              ? const SizedBox(height: 20)
                              : index == 1
                                  ? const SizedBox(height: 65)
                                  : index == 2
                                      ? const SizedBox(height: 65)
                                      : index == 3
                                          ? const SizedBox(height: 65)
                                          : index == 4
                                              ? const SizedBox(height: 45)
                                              : index == 5
                                                  ? const SizedBox(height: 45)
                                                  : index == 6
                                                      ? const SizedBox(height: 65)
                                                      : const SizedBox(height: 0),
                          Text(
                            index == 0
                                ? "Masa Tumbuh"
                                : index == 1
                                    ? "Kipas"
                                    : index == 2
                                        ? "Pemanas"
                                        : index == 3
                                            ? "Pendingin"
                                            : index == 4
                                                ? "Lampu"
                                                : index == 5
                                                    ? "Alarm"
                                                    : index == 6
                                                        ? "Reset Waktu"
                                                        : "",
                            style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 14),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: index == 0
                                    ? Column(children: [
                                        RichText(
                                          text: TextSpan(
                                              style: const TextStyle(color: Colors.blue), //apply style to all
                                              children: [
                                                TextSpan(
                                                  text: 'Target Suhu Hari Ini',
                                                  style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                ),
                                                TextSpan(
                                                  text: ' ${controller.deviceController!.growthDay!.temperature} °C',
                                                  style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                ),
                                              ]),
                                        ),
                                        Text("Umur Pertumbuhan ${controller.deviceController!.growthDay!.day} hari", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12))
                                      ])
                                    : index == 1
                                        ? Text(" Nyala ${controller.deviceController!.fan!.online} - Mati ${controller.deviceController!.fan!.offline} ", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12))
                                        : index == 2
                                            ? RichText(
                                                text: TextSpan(
                                                    style: const TextStyle(color: Colors.blue), //apply style to all
                                                    children: [
                                                      TextSpan(
                                                        text: 'Suhu',
                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                      ),
                                                      TextSpan(
                                                        text: ' ${controller.deviceController!.heater!.temperature} °C',
                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                      ),
                                                    ]),
                                              )
                                            : index == 3
                                                ? RichText(
                                                    text: TextSpan(
                                                        style: const TextStyle(color: Colors.blue), //apply style to all
                                                        children: [
                                                          TextSpan(
                                                            text: 'Suhu',
                                                            style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                          ),
                                                          TextSpan(
                                                            text: ' ${controller.deviceController!.cooler!.temperature} °C',
                                                            style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                          ),
                                                        ]),
                                                  )
                                                : index == 4
                                                    ? RichText(
                                                        text: TextSpan(
                                                            style: const TextStyle(color: Colors.blue), //apply style to all
                                                            children: [
                                                              TextSpan(
                                                                text: '${controller.deviceController!.lamp!.name!} ',
                                                                style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                              ),
                                                              TextSpan(
                                                                text: '${controller.deviceController!.lamp!.onlineTime} - ${controller.deviceController!.lamp!.offlineTime}',
                                                                style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                              ),
                                                            ]),
                                                      )
                                                    : index == 5
                                                        ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                    style: const TextStyle(color: Colors.blue), //apply style to all
                                                                    children: [
                                                                      TextSpan(
                                                                        text: 'Panas ',
                                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                                      ),
                                                                      TextSpan(
                                                                        text: '${controller.deviceController!.alarm!.hot} °C',
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                                      ),
                                                                    ]),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                    style: const TextStyle(color: Colors.blue), //apply style to all
                                                                    children: [
                                                                      TextSpan(
                                                                        text: 'Dingin ',
                                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                                      ),
                                                                      TextSpan(
                                                                        text: '${controller.deviceController!.alarm!.cold} °C',
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ],
                                                          )
                                                        : index == 6
                                                            ? RichText(
                                                                text: TextSpan(
                                                                    style: const TextStyle(color: Colors.blue), //apply style to all
                                                                    children: [
                                                                      TextSpan(
                                                                        text: 'Waktu Bawaan',
                                                                        style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                                      ),
                                                                      TextSpan(
                                                                        text: ' ${controller.deviceController!.resetTime!.onlineTime}',
                                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12),
                                                                      ),
                                                                    ]),
                                                              )
                                                            : Container(),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              );
            }),
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
          onRefresh: () async {
            controller.isLoading.value = true;
            // controller.coops.value.clear();
            controller.getDetailSmartController();
            // return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Obx(
                () => controller.isLoading.isTrue
                    ? const Center(
                        child: Center(
                          child: SizedBox(
                            height: 124,
                            width: 124,
                            child: ProgressLoading(),
                          ),
                        ),
                      )
                    : controller.deviceController == null
                        ? Center(
                            child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                            child: Column(
                              children: [
                                SvgPicture.asset("images/empty_icon.svg"),
                                const SizedBox(
                                  height: 17,
                                ),
                                Text(
                                  "Data Smart Controller Belum Ada",
                                  textAlign: TextAlign.center,
                                  style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                )
                              ],
                            ),
                          ))
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10, right: 4, left: 4),
                                  child: CardListSmartController(
                                    device: controller.device,
                                    onTap: () {},
                                    isItemList: false,
                                  ),
                                ),
                                itemGridview(MediaQuery.of(context).size.width)
                              ],
                            ),
                          ),
              ),
            )
          ]),
        ));
  }
}
