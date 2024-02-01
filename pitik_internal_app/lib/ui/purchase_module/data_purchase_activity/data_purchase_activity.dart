///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/purchase_module/data_purchase_activity/data_purchase_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/list_card_purchase.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  @override
  Widget build(BuildContext context) {
    final PurchaseController controller = Get.put(PurchaseController(context: context));

    Widget bottomNavbar() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ButtonFill(
                  controller: GetXCreator.putButtonFillController("dataBaruHome"),
                  label: "Buat Pembelian",
                  onClick: () {
                    Constant.track("Click_Buat_Pembelian");
                    Get.toNamed(RoutePage.newDataPurchase)!.then((value) {
                      controller.isLoading.value = true;
                      controller.purchaseList.value.clear();
                      controller.page.value = 1;
                      Timer(const Duration(milliseconds: 100), () {
                        controller.getListPurchase();
                      });
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      );
    }

    Widget filterList() {
      List<MapEntry<String, String>> listFilter = controller.listFilter.value.entries.toList();
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listFilter.length,
          itemBuilder: (context, index) {
            if (listFilter[index].value.isEmpty) {
              return const SizedBox();
            }
            return Container(
              height: 32,
              margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.bgAbu),
              child: Row(
                children: [
                  Text(
                    listFilter[index].value,
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => controller.removeOneFilter(listFilter[index].key),
                    child: const Icon(Icons.close, size: 16, color: AppColors.primaryOrange),
                  )
                ],
              ),
            );
          });
    }

    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(controller.isFilter.isTrue && controller.listFilter.value.isNotEmpty ? 160 : 110),
              child: Column(
                children: [
                  CustomAppbar(
                    title: "Pembelian",
                    onBack: () => Navigator.of(context).pop(),
                    isFlat: true,
                  ),
                  Container(
                    color: AppColors.primaryOrange,
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => controller.openFilter(),
                          child: Container(
                            height: 32,
                            width: 32,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.primaryLight),
                            child: SvgPicture.asset("images/filter_line.svg"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(height: 42, child: controller.sbSearch),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => controller.isFilter.isTrue && controller.listFilter.value.isNotEmpty ? Expanded(child: filterList()) : const SizedBox(),
                  ),
                ],
              )),
          body: Stack(
            children: [
              Obx(() => controller.isLoading.isTrue
                  ? const SizedBox()
                  : controller.purchaseList.value.isEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              "Data Purchase Belum Ada",
                              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : RawScrollbar(
                          controller: controller.scrollController,
                          thumbColor: AppColors.primaryOrange,
                          radius: const Radius.circular(8),
                          child: RefreshIndicator(
                            color: AppColors.primaryOrange,
                            onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.pullRefresh()),
                            child: Container(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                              child: ListView.builder(
                                controller: controller.scrollController,
                                itemCount: controller.isLoadMore.isTrue ? controller.purchaseList.value.length + 1 : controller.purchaseList.value.length,
                                itemBuilder: (context, index) {
                                  int length = controller.purchaseList.value.length;
                                  if (index >= length) {
                                    return const Column(
                                      children: [
                                        Center(child: ProgressLoading()),
                                        SizedBox(height: 120),
                                      ],
                                    );
                                  }
                                  return Column(
                                    children: [
                                      CardListPurchase(
                                        purchase: controller.purchaseList.value[index]!,
                                        onTap: () {
                                            Constant.track("Click_Detail_Pembelian");
                                          Get.toNamed(RoutePage.purchaseDetailPage, arguments: controller.purchaseList.value[index]!)!.then((value) {
                                            controller.isLoading.value = true;
                                            controller.purchaseList.value.clear();
                                            controller.page.value = 1;
                                            Timer(const Duration(milliseconds: 100), () {
                                              controller.getListPurchase();
                                            });
                                          });
                                        },
                                      ),
                                      index == controller.purchaseList.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        )),
              bottomNavbar(),
              Obx(
                () => controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : const SizedBox(),
              ),
            ],
          ),
        ));
  }
}
