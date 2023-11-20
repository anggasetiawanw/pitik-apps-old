import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/delivery_module/delivery_home/delivery_home_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_delivery.dart';
import 'package:pitik_internal_app/widget/common/list_card_order.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/controllers/tab_detail_controller.dart';

class DeliveryHomeActivity extends StatelessWidget {
  DeliveryHomeActivity({super.key});
  final TabDetailController _tabController = Get.put(TabDetailController());
  @override
  Widget build(BuildContext context) {
    final DeliveryHomeController controller = Get.put(DeliveryHomeController(context: context));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          "Pengiriman",
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget tabBar() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              controller: _tabController.controller,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  text: "Penjualan",
                ),
                Tab(
                  text: "Transfer",
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body: Column(
        children: [
          tabBar(),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: TabBarView(controller: _tabController.controller, children: [
                    Obx(
                      () => controller.isLoadingSales.isTrue
                          ? const Center(child: ProgressLoading())
                          : controller.listSalesOrder.value.isEmpty
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("images/empty_icon.svg"),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          "Belum ada data",
                                          style: AppTextStyle.greyTextStyle.copyWith(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: controller.scrollControllerSales,
                                  itemCount: controller.isLoadMoreSales.isTrue ? controller.listSalesOrder.value.length + 1 : controller.listSalesOrder.value.length,
                                  itemBuilder: (context, index) {
                                    int length = controller.listSalesOrder.value.length;
                                    if (index >= length) {
                                      return const SizedBox(
                                        height: 120,
                                        child: Center(child: ProgressLoading()),
                                      );
                                    }
                                    return Column(
                                      children: [
                                        CardListOrder(
                                          order: controller.listSalesOrder.value[index]!,
                                          onTap: () {
                                            Get.toNamed(
                                              RoutePage.deliveryDetailSO,
                                              arguments: controller.listSalesOrder.value[index],
                                            )!
                                                .then((value) {
                                              controller.isLoadingSales.value = true;
                                              controller.listSalesOrder.value.clear();

                                              controller.pageSales.value = 0;
                                              Timer(const Duration(milliseconds: 500), () {
                                                controller.getListOrders();
                                              });
                                            });
                                          },
                                          isSoPage: true,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                    ),
                    Obx(
                      () => controller.isLoadingTransfer.isTrue
                          ? const Center(child: ProgressLoading())
                          : controller.listTransfer.value.isEmpty
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("images/empty_icon.svg"),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          "Belum ada data",
                                          style: AppTextStyle.greyTextStyle.copyWith(
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: controller.scrollControllerTransfer,
                                  itemCount: controller.isLoadMoreTransfer.isTrue ? controller.listTransfer.value.length + 1 : controller.listTransfer.value.length,
                                  itemBuilder: (context, index) {
                                    int length = controller.listTransfer.value.length;
                                    if (index >= length) {
                                      return const SizedBox(
                                        height: 120,
                                        child: Center(child: ProgressLoading()),
                                      );
                                    }
                                    return Column(
                                      children: [
                                        CardListDelivery(
                                          isPenjualan: false,
                                          transferModel: controller.listTransfer.value[index],
                                          onTap: () {
                                            Get.toNamed(
                                              RoutePage.deliveryDetailTransfer,
                                              arguments: controller.listTransfer.value[index],
                                            )!
                                                .then((value) {
                                              controller.isLoadingTransfer.value = true;
                                              controller.listTransfer.value.clear();
                                              controller.pageTransfer.value = 0;
                                              Timer(const Duration(milliseconds: 500), () {
                                                controller.getListTransfer();
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                    ),
                  ]))),
        ],
      ),
    );
  }
}
