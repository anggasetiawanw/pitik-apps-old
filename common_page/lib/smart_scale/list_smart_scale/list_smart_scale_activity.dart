// ignore_for_file: slash_for_doc_comments, use_key_in_widget_constructors

import 'dart:async';

import 'package:common_page/smart_scale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'list_smart_scale_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class ListSmartScaleActivity extends GetView<ListSmartScaleController> {
    const ListSmartScaleActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Obx(() =>
                Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: AppBarFormForCoop(
                            title: 'Smart Scale',
                            coop: controller.bundle.getCoop(),
                            hideCoopDetail: true,
                        ),
                    ),
                    body: Stack(
                        children: [
                            controller.isLoading.isTrue ? // IF LOADING IS RUNNING
                            const Center(child: ProgressLoading()) :
                            RefreshIndicator(
                                child: controller.smartScaleList.isEmpty ? // IF LOADING IS DONE AND DATA EMPTY
                                Column(
                                    children: [
                                        const SizedBox(height: 16),
                                        filterContainer(context),
                                        ListView(
                                            shrinkWrap: true,
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            children: [
                                                SizedBox(
                                                    width: double.infinity,
                                                    height: MediaQuery.of(context).size.height - 210,
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            SvgPicture.asset("images/empty_icon.svg"),
                                                            const SizedBox(height: 17),
                                                            Text("Belum ada data timbang pada lantai ini", textAlign: TextAlign.center, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium))
                                                        ],
                                                    ),
                                                )
                                            ],
                                        )
                                    ],
                                ) :
                                Column(
                                    children: [
                                        const SizedBox(height: 16),
                                        filterContainer(context),
                                        Expanded(child: listSmartScale())
                                    ]
                                ),
                                onRefresh: () => Future.delayed(
                                    const Duration(milliseconds: 200), () => controller.getSmartScaleListData(isPull: true)
                                )
                            ),
                            controller.bundle.isShowWeighingButton() ? bottomNavBar() : const SizedBox()
                        ]
                    )
                )
            )
        );
    }

    Widget filterContainer(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text("Daftar Timbang", style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                GestureDetector(
                    child: SvgPicture.asset("images/filter_orange_icon.svg", width: 36, height: 36),
                    onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                            )
                        ),
                        builder: (context) => Container(
                            color: Colors.transparent,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Container(
                                                width: 60,
                                                height: 4,
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                                    color: GlobalVar.outlineColor
                                                )
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 24, bottom: 24),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Filter Daftar Timbang", style: GlobalVar.subTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange))
                                            )
                                        ),
                                        controller.dateFilterField,
                                        Padding(
                                            padding: const EdgeInsets.only(top: 32, bottom: 32),
                                            child: ButtonFill(controller: GetXCreator.putButtonFillController("buttonFilterListSmartScale"), label: "Konfirmasi Filter", onClick: () {
                                                if (controller.dateFilterField.controller.textSelected.value == "") {
                                                    controller.dateFilterField.controller.showAlert();
                                                } else {
                                                    Navigator.pop(context);
                                                    controller.isLoading.value = true;
                                                    controller.getSmartScaleListData(dateFilter: controller.dateFilterField.controller.textSelected.value);
                                                }
                                            })
                                        )
                                    ]
                                )
                            )
                        )
                    )
                )
            ]
        )
    );

    Widget appBar() => AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text("Smart Scale", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium)),
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                                child: ButtonFill(
                                    controller: GetXCreator.putButtonFillController("ChickenWeightingButton"),
                                    label: "Timbang Ayam",
                                    onClick: () {
                                        GlobalVar.track("Click_button_timbang_ayam");
                                        Get.to(SmartScaleWeighingActivity(), arguments: [controller.bundle.getCoop(), controller.bundle.getWeighingBundle()])!.then((value) {
                                            controller.isLoading.value = true;
                                            controller.smartScaleList.clear();
                                            controller.pageSmartScale.value = 1;
                                            Timer(const Duration(milliseconds: 500), () => controller.getSmartScaleListData());
                                        });
                                    }
                                )
                            )
                        ]
                    )
                )
            ]
        )
    );

    Widget listSmartScale() => Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.scrollController,
            itemCount: controller.isLoadMore.isTrue ? controller.smartScaleList.length + 1 : controller.smartScaleList.length,
            itemBuilder: (context, index) {
                int length = controller.smartScaleList.length;
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
                        controller.bundle.onCreateCard(controller, index),
                        index == controller.smartScaleList.length - 1 ? const SizedBox(height: 120) : Container()
                    ]
                );
            }
        )
    );
}