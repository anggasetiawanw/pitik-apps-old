import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/receive_module/data_receive_activity/data_receive_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/list_card_order.dart';
import 'package:pitik_internal_app/widget/common/list_card_purchase.dart';
import 'package:pitik_internal_app/widget/common/list_card_transfer.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23

class ReceiveActivity extends GetView<ReceiveController> {
  const ReceiveActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final ReceiveController controller = Get.put(ReceiveController(
      context: context,
    ));
    Widget tabBar() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.grey, width: 2.0),
                ),
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              controller: controller.tabController.controller,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  text: "Pembelian",
                ),
                Tab(
                  text: "Transfer",
                ),
                Tab(
                  text: "Pengembalian",
                )
              ],
              labelColor: AppColors.primaryOrange,
              unselectedLabelColor: AppColors.grey,
              labelStyle: AppTextStyle.primaryTextStyle,
              unselectedLabelStyle: AppTextStyle.greyTextStyle,
              indicatorColor: AppColors.primaryOrange,
            ),
          ],
        ),
      );
    }

    Widget tabViewPurchase() {
      return Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: ListView.builder(
          controller: controller.scrollPurchaseController,
          itemCount: controller.isLoadMore.isTrue ? controller.listPurchase.value.length + 1 : controller.listPurchase.value.length,
          itemBuilder: (context, index) {
            int length = controller.listPurchase.value.length;
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
                CardListPurchase(
                  purchase: controller.listPurchase.value[index]!,
                  onTap: () {
                    Get.toNamed(RoutePage.grPurchaseDetailPage, arguments: controller.listPurchase.value[index]!)!.then((value) {
                      controller.isLoadingPurchase.value = true;
                      controller.listPurchase.value.clear();
                      controller.pagePurchase.value = 0;
                      Timer(const Duration(milliseconds: 500), () {
                        controller.getListPurchase();
                      });
                    });
                  },
                ),
                index == controller.listPurchase.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
              ],
            );
          },
        ),
      );
    }

    Widget tabViewTransfer() {
      return Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: ListView.builder(
          controller: controller.scrollTransferController,
          itemCount: controller.isLoadMore.isTrue ? controller.listTransfer.value.length + 1 : controller.listTransfer.value.length,
          itemBuilder: (context, index) {
            int length = controller.listTransfer.value.length;
            if (index >= length) {
              return const Column(
                children: [
                  Center(child: ProgressLoading()),
                  SizedBox(height: 100),
                ],
              );
            }
            return Column(
              children: [
                CardListTransfer(
                  onTap: () {
                    Get.toNamed(RoutePage.grTransferDetailPage, arguments: controller.listTransfer.value[index]!)!.then((value) {
                      controller.isLoadingTransfer.value = true;
                      controller.listTransfer.value.clear();
                      controller.pageTransfer.value = 0;
                      Timer(const Duration(milliseconds: 500), () {
                        controller.getListTransfer();
                      });
                    });
                  },
                  transferModel: controller.listTransfer.value[index]!,
                  isGoodReceipts: true,
                ),
                index == controller.listTransfer.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
              ],
            );
          },
        ),
      );
    }

    Widget tabViewReturn() {
      return Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: ListView.builder(
          controller: controller.scrollOrderController,
          itemCount: controller.isLoadMore.isTrue ? controller.listReturn.value.length + 1 : controller.listReturn.value.length,
          itemBuilder: (context, index) {
            int length = controller.listReturn.value.length;
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
                CardListOrder(
                  isSoPage: false,
                  order: controller.listReturn.value[index]!,
                  onTap: () {
                    Get.toNamed(
                      RoutePage.grOrderDetail,
                      arguments: controller.listReturn.value[index]!,
                    )!
                        .then((value) {
                      controller.isLoadingOrder.value = true;
                      controller.listReturn.value.clear();
                      controller.pageOrder.value = 0;
                      Timer(const Duration(milliseconds: 500), () {
                        controller.getListReturn();
                      });
                    });
                  },
                ),
                index == controller.listReturn.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
              ],
            );
          },
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
              margin: const EdgeInsets.only(right: 8, top: 8, left: 8),
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

    return Obx(() =>  Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(controller.isFilter.isTrue && controller.listFilter.value.isNotEmpty ? 210 : 160),
          child: Column(
            children: [
              CustomAppbar(
                title: "Penerimaan",
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
              tabBar(),
              Obx(
                () => controller.isFilter.isTrue && controller.listFilter.value.isNotEmpty ? Expanded(child: filterList()) : const SizedBox(),
              ),
            ],
          )),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: TabBarView(
                    controller: controller.tabController.controller,
                    children: [
                      Obx(
                        () => controller.isLoadingPurchase.isTrue
                            ? const Center(
                                child: ProgressLoading(),
                              )
                            : controller.listPurchase.value.isEmpty
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
                                : tabViewPurchase(),
                      ),
                      Obx(() => controller.isLoadingTransfer.isTrue
                          ? const Center(
                              child: ProgressLoading(),
                            )
                          : controller.listTransfer.value.isEmpty
                              ? Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      "Data Transfer Belum Ada",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : tabViewTransfer()),
                      Obx(() => controller.isLoadingOrder.isTrue
                          ? const Center(
                              child: ProgressLoading(),
                            )
                          : controller.listReturn.value.isEmpty
                              ? Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      "Data Pengembalian Belum Ada",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : tabViewReturn()),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
