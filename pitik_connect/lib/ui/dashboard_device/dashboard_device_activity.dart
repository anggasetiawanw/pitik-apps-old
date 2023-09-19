import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/list_card_smartcamera/card_list_smartcamera.dart';
import 'package:components/list_card_smartcontroller/card_list_controller.dart';
import 'package:components/list_card_smartmonitor/card_list_monitor.dart';
import 'package:components/list_card_smartscale/card_list_smartscale.dart';
import 'package:components/menu_bottomsheet.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:components/tab_device/tab_device_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../route.dart';
import '../register_coop/register_coop_controller.dart';
import 'dashboard_device_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 14/07/23


class DashboardDevice extends GetView<DashboardDeviceController>{
    const DashboardDevice({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        final DashboardDeviceController controller = Get.put(DashboardDeviceController(
            context: context,
        ));

        final TabDeviceController tabController = Get.put(TabDeviceController());

        showButtonDialog(BuildContext context, DashboardDeviceController controller) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                    return Align(
                        alignment: const Alignment(1, -1),
                        child: Container(
                            margin: const EdgeInsets.only(top: 50, right: 30),
                            width: 135,
                            height: 72,
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
                                                  GlobalVar.track("Click_option_menu_edit_kandang");
                                                  Get.back();
                                                  Get.toNamed(RoutePage.createCoopPage, arguments:[RegisterCoopController.MODIFY_COOP, controller.coopDetail])!.then((value) {
                                                      controller.isLoading.value = true;
                                                      controller.smartMonitordevices.value.clear();
                                                      controller.smartControllerdevices.value.clear();
                                                      controller.smartCameradevices.value.clear();
                                                      Timer(const Duration(milliseconds: 500), () {
                                                          controller.getDetailRoom();
                                                      });
                                                  });
                                                  },
                                              child:  Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                      const SizedBox(
                                                          width: 8,
                                                      ),
                                                      DefaultTextStyle(
                                                        style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                        child: const Text("Edit Kandang",),
                                                      ),
                                                  ],
                                              ),
                                          ),
                                            const SizedBox(
                                                height: 8,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                    GlobalVar.track("Click_option_menu_edit_lantai");
                                                    Get.back();
                                                    Get.toNamed(RoutePage.createCoopPage, arguments:[RegisterCoopController.MODIFY_FLOOR, controller.coopDetail])!.then((value) {
                                                        controller.isLoading.value =true;
                                                        controller.smartMonitordevices.value.clear();
                                                        controller.smartControllerdevices.value.clear();
                                                        controller.smartCameradevices.value.clear();
                                                        Timer(const Duration(milliseconds: 500), () {
                                                            controller.getDetailRoom();
                                                        });
                                                    });
                                                },
                                                child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        const SizedBox(width: 8),
                                                        DefaultTextStyle(
                                                            style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),
                                                            child: const Text("Edit Lantai"),
                                                            ),
                                                        const SizedBox(height: 12),
                                                    ],
                                                ),
                                            ),
                                        ],
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
                            ]),
                        ));
                },
            );
        }


        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back()),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: GlobalVar.primaryOrange,
                centerTitle: true,
                title:
                Obx(() => controller.isLoading.isTrue ? Text(
                    "${controller.coop.name} - ${controller.coop.room!.name}",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                ): Text(
                    "${controller.coopDetail.coopName} - ${controller.coopDetail.room!.name}",
                    style: GlobalVar.whiteTextStyle
                        .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                ) )
                ,
                actions: [
                    if(GlobalVar.canModifyInfrasturucture())...[
                        GestureDetector(
                            onTap: () {
                                GlobalVar.track("Click_option_menus");
                                showButtonDialog(context, controller);
                            },
                            child: Container(
                                color: Colors.transparent,
                                height: 32,
                                width: 32,
                                margin: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
                                child: SvgPicture.asset("images/dot_icon.svg"),
                            ),
                        )
                    ]
                ],
            );
        }

        Widget tabBar() {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.bottomCenter,
                    children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: GlobalVar.gray, width: 2.0),
                                ),
                            ),
                        ),
                        TabBar(
                            isScrollable: true,
                            controller: tabController.controller,
                            tabs: const [
                                Tab(
                                    text: "Smart Monitoring",
                                ),
                                Tab(
                                    text: "Smart Controller",
                                ),
                                Tab(
                                    text: "Smart Camera",
                                ),
                                Tab(
                                    text: "Smart Scale",
                                )
                            ],
                            labelColor: GlobalVar.primaryOrange,
                            unselectedLabelColor: GlobalVar.gray,
                            labelStyle: GlobalVar.primaryTextStyle,
                            unselectedLabelStyle: GlobalVar.greyTextStyle,
                            indicatorColor: GlobalVar.primaryOrange,
                        ),
                    ],
                ),
            );
        }

        Widget tabViewSmartMonitor() {
            return  Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: ListView.builder(
                    controller: controller.scrollMonitorController,
                    itemCount: controller.isLoadMore.isTrue
                        ? controller.smartMonitordevices.value.length + 1
                        : controller.smartMonitordevices.value.length,
                    itemBuilder: (context, index) {
                        int length = controller.smartMonitordevices.value.length;
                        if (index >= length) {
                            return const Column(
                                children: [
                                    Center(
                                        child: SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: ProgressLoading(),
                                        ),
                                    ),
                                    SizedBox(height: 120),
                                ],
                            );
                        }
                        return Column(
                            children: [
                                CardListSmartMonitor(
                                    device: controller.smartMonitordevices.value[index],
                                    onTap: () {
                                        GlobalVar.track("Click_Button_Smart_Monitoring");
                                        Get.toNamed(RoutePage.detailSmartMonitorPage, arguments: [controller.coopDetail,controller.smartMonitordevices.value[index]])!.then((value) {
                                            controller.isLoading.value = true;
                                            controller.smartMonitordevices.value.clear();
                                            controller.smartControllerdevices.value.clear();
                                            controller.smartCameradevices.value.clear();
                                            controller.smartScaledevices.value.clear();
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.getDetailRoom();
                                            });
                                        });
                                    },
                                ),
                                index == controller.smartMonitordevices.value.length - 1 ? const SizedBox(height: 120)
                                    : Container(),
                            ],
                        );
                    },
                ),
            );
        }

        Widget tabViewSmartController() {
            return  Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.isLoadMore.isTrue
                        ? controller.smartControllerdevices.value.length + 1
                        : controller.smartControllerdevices.value.length,
                    itemBuilder: (context, index) {
                        int length = controller.smartControllerdevices.value.length;
                        if (index >= length) {
                            return const Column(
                                children: [
                                    Center(
                                        child: SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: ProgressLoading(
                                            ),
                                        ),
                                    ),
                                    SizedBox(height: 120),
                                ],
                            );
                        }
                        return Column(
                            children: [
                                CardListSmartController(
                                    device: controller.smartControllerdevices.value[index],
                                    onTap: () {
                                        GlobalVar.track("Click_Button_Smart_Controller");
                                        Get.toNamed(RoutePage.detailSmartControllerPage, arguments: [controller.coopDetail, controller.smartControllerdevices.value[index]])!.then((value) {
                                            controller.isLoading.value = true;
                                            controller.smartMonitordevices.value.clear();
                                            controller.smartControllerdevices.value.clear();
                                            controller.smartCameradevices.value.clear();
                                            controller.smartScaledevices.value.clear();
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.getDetailRoom();
                                            });
                                        });
                                    }, isItemList: true,
                                ),
                                index == controller.smartControllerdevices.value.length - 1 ? const SizedBox(height: 120)
                                    : Container(),
                            ],
                        );
                    },
                ),
            );
        }

        Widget tabViewSmartCamera() {
            return  ListView.builder(
                controller: controller.scrollCameraController,
                itemCount: controller.isLoadMore.isTrue
                    ? controller.smartCameradevices.value.length + 1
                    : controller.smartCameradevices.value.length,
                itemBuilder: (context, index) {
                    int length = controller.smartCameradevices.value.length;
                    if (index >= length) {
                        return const Column(
                            children: [
                                Center(
                                    child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: ProgressLoading(
                                        ),
                                    ),
                                ),
                                SizedBox(height: 120),
                            ],
                        );
                    }
                    return Column(
                        children: [
                            CardListSmartCamera(
                                device: controller.smartCameradevices.value[index],
                                imagesPath: "images/smartcamera_icon.svg",
                                onTap: () {
                                    GlobalVar.track("Click_Button_Smart_Camera");
                                    Get.toNamed(RoutePage.detailSmartCameraPage, arguments: [controller.smartCameradevices.value[index], controller.coopDetail])!.then((value) {
                                        controller.isLoading.value = true;
                                        controller.smartMonitordevices.value.clear();
                                        controller.smartControllerdevices.value.clear();
                                        controller.smartCameradevices.value.clear();
                                        controller.smartScaledevices.value.clear();
                                        Timer(const Duration(milliseconds: 500), () {
                                            controller.getDetailRoom();
                                        });
                                    });
                                },
                            ),
                            index == controller.smartCameradevices.value.length - 1 ? const SizedBox(height: 120)
                                : Container(),
                        ],
                    );
                },
            );
        }

        Widget tabViewSmartScale() {
            return  ListView.builder(
                controller: controller.scrollScaleController,
                itemCount: controller.isLoadMore.isTrue
                    ? controller.smartScaledevices.value.length + 1
                    : controller.smartScaledevices.value.length,
                itemBuilder: (context, index) {
                    int length = controller.smartScaledevices.value.length;
                    if (index >= length) {
                        return const Column(
                            children: [
                                Center(
                                    child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: ProgressLoading(
                                        ),
                                    ),
                                ),
                                SizedBox(height: 120),
                            ],
                        );
                    }
                    return Column(
                        children: [
                            CardListSmartScale(
                                device: controller.smartScaledevices.value[index],
                                imagesPath: "images/smartscale_icon.svg",
                                onTap: () {
                                    GlobalVar.track("Click_Button_Smart_Scale");
                                    Get.toNamed(RoutePage.listSmartScalePage, arguments: [controller.smartScaledevices.value[index], controller.coopDetail])!.then((value) {
                                        controller.isLoading.value = true;
                                        controller.smartMonitordevices.value.clear();
                                        controller.smartControllerdevices.value.clear();
                                        controller.smartCameradevices.value.clear();
                                        controller.smartScaledevices.value.clear();
                                        Timer(const Duration(milliseconds: 500), () {
                                            controller.getDetailRoom();
                                        });
                                    });
                                },
                            ),
                            index == controller.smartScaledevices.value.length - 1 ? const SizedBox(height: 120)
                                : Container(),
                        ],
                    );
                },
            );
        }

        showBottomDialog(BuildContext context, DashboardDeviceController controller) {
            return showModalBottomSheet(
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                    return Container(
                        decoration: const BoxDecoration(
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
                                    margin: const EdgeInsets.only(top: 8),
                                    width: 60,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: GlobalVar.outlineColor,
                                        borderRadius: BorderRadius.circular(2),
                                    ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                        GlobalVar.track("Click_add_smart_monitoring");
                                        Get.back();
                                        Get.toNamed(RoutePage.registerDevicePage, arguments: [controller.coopDetail, "Smart Monitoring"])!.then((value) {
                                            controller.isLoading.value = true;
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.smartMonitordevices.value.clear();
                                                controller.smartControllerdevices.value.clear();
                                                controller.smartCameradevices.value.clear();
                                                controller.getDetailRoom();
                                            });
                                        });
                                    },
                                    child:
                                    const MenuBottomSheet(title: "Smart Monitoring", subTitle : "Monitoring lingkungan kandang seperti Suhu, kelembaban, amonia, angin dan cahaya", imagesPath: "images/smartmonitoring_icon.svg",),),
                                GestureDetector(
                                    onTap: () {
                                        GlobalVar.track("Click_add_smart_controller");
                                        Get.back();
                                        Get.toNamed(RoutePage.registerDevicePage, arguments: [controller.coopDetail, "Smart Controller"])!.then((value) {
                                            controller.isLoading.value = true;
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.smartMonitordevices.value.clear();
                                                controller.smartControllerdevices.value.clear();
                                                controller.smartCameradevices.value.clear();
                                                controller.getDetailRoom();
                                            });
                                        });
                                    },
                                    child:
                                    const MenuBottomSheet(title: "Smart Controller", subTitle : "Kontrol peralatan di kandang seperti kipas, pemanas, pendingin dan alarm", imagesPath: "images/smartcontroller_icon.svg",),),
                                GestureDetector(
                                    onTap: () {
                                        GlobalVar.track("Click_add_smart_camera");
                                        Get.back();
                                        Get.toNamed(RoutePage.registerDevicePage, arguments: [controller.coopDetail, "Smart Camera"])!.then((value) {
                                            controller.isLoading.value = true;
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.smartMonitordevices.value.clear();
                                                controller.smartControllerdevices.value.clear();
                                                controller.smartCameradevices.value.clear();
                                                controller.getDetailRoom();
                                            });
                                        });
                                    },
                                    child:
                                    const MenuBottomSheet(title: "Smart Camera", subTitle : "Pantau kondisi lingkungan kandang secara langsung dengan mudah", imagesPath: "images/smartcamera_icon.svg",),
                                )
                                ,
                                const SizedBox(height: GlobalVar.bottomSheetMargin,)
                            ],
                        ),
                    );
                });
        }

        Widget bottomNavBar() {
            return Align(
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
                                            controller: GetXCreator.putButtonFillController("createDevice"),
                                            label: "Tambah Alat",
                                            onClick: () {
                                                GlobalVar.track("Click_button_tambah_alat");
                                                showBottomDialog(context, controller);
                                            },
                                        )),
                                ],
                            ),
                        ),
                    ],
                ));
        }


        return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),
            ),
            body: Stack(
                children: [
                    Column(
                        children: [
                            tabBar(),
                            const SizedBox(
                                height: 10,
                            ),
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    child: TabBarView(
                                        controller: tabController.controller,
                                        children: [
                                            Obx(() => controller.isLoading.isTrue ?
                                            const Center(child: ProgressLoading()) : controller.smartMonitordevices.value.isEmpty ?
                                            Center(
                                                child: Container(
                                                    width: double.infinity,
                                                    height: MediaQuery. of(context). size. height,
                                                    margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                                                    child: Column(
                                                      children: [
                                                          SvgPicture.asset("images/empty_icon.svg"),
                                                          const SizedBox(
                                                              height: 17,),
                                                          Text("Belum ada alat terpasang di lantai ini",
                                                              textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                                                      ],
                                                  ),
                                                )
                                            ) : tabViewSmartMonitor(),
                                            ),
                                            Obx(() => controller.isLoading.isTrue ?
                                            const Center(child: ProgressLoading()) : controller.smartControllerdevices.value.isEmpty ?
                                            Center(
                                                child: Container(
                                                    width: double.infinity,
                                                    height: MediaQuery. of(context). size. height,
                                                    margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                                                    child: Column(
                                                        children: [
                                                            SvgPicture.asset("images/empty_icon.svg"),
                                                            const SizedBox(
                                                                height: 17,),
                                                            Text("Belum ada alat terpasang di lantai ini",
                                                                textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                                                        ],
                                                    ),
                                                )
                                            ) : tabViewSmartController()
                                            ),
                                            Obx(() => controller.isLoading.isTrue ?
                                            const Center(child: ProgressLoading()) : controller.smartCameradevices.value.isEmpty ?
                                            Center(
                                                child: Container(
                                                    width: double.infinity,
                                                    height: MediaQuery. of(context). size. height,
                                                    margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                                                    child: Column(
                                                        children: [
                                                            SvgPicture.asset("images/empty_icon.svg"),
                                                            const SizedBox(
                                                                height: 17,),
                                                            Text("Belum ada alat terpasang di lantai ini",
                                                                textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                                                        ],
                                                    ),
                                                )
                                            ): tabViewSmartCamera()
                                            ),
                                            Obx(() => controller.isLoading.isTrue ?
                                            const Center(child: ProgressLoading()) : controller.smartScaledevices.value.isEmpty ?
                                            Center(
                                                child: Container(
                                                    width: double.infinity,
                                                    height: MediaQuery. of(context). size. height,
                                                    margin: const EdgeInsets.only(left: 56, right: 56, bottom: 32, top: 186),
                                                    child: Column(
                                                        children: [
                                                            SvgPicture.asset("images/empty_icon.svg"),
                                                            const SizedBox(
                                                                height: 17,),
                                                            Text("Belum ada alat terpasang di lantai ini",
                                                                textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium),)
                                                        ],
                                                    ),
                                                )
                                            ): tabViewSmartScale()
                                            )
                                        ],
                                    ),
                                ),
                            ),
                            bottomNavBar()
                        ],
                    )
                ],
            ),
        );
    }

}
