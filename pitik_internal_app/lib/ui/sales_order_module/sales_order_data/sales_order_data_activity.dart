///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/sales_order_module/sales_order_data/sales_order_data_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/list_card_order.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class SalesOrderPage extends StatelessWidget {
  const SalesOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesOrderController controller = Get.put(SalesOrderController(context: context));

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
          padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
          child: controller.btPenjualan,
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
              controller: controller.tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(
                  text: "Outbound",
                ),
                Tab(
                  text: "Inbound",
                ),
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

    Widget tabViewOutbound() {
      return Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: RawScrollbar(
              controller: controller.scrollControllerOutbound,
              thumbColor: AppColors.primaryOrange,
              radius: const Radius.circular(8),
              child: RefreshIndicator(
                  onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.pullRefresh()),
                  color: AppColors.primaryOrange,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollControllerOutbound,
                    itemCount: controller.isLoadMore.isTrue ? controller.orderListOutbound.length + 1 : controller.orderListOutbound.length,
                    itemBuilder: (context, index) {
                      int length = controller.orderListOutbound.length;
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
                          CardListOrder(
                            isSoPage: true,
                            order: controller.orderListOutbound[index]!,
                            onTap: () {
                              Get.toNamed(RoutePage.salesOrderDetailPage, arguments: controller.orderListOutbound[index])!.then((value) {
                                controller.isLoadData.value = true;
                                controller.orderListOutbound.clear();
                                controller.pageOutbound.value = 1;
                                Timer(const Duration(milliseconds: 500), () {
                                  if (controller.isFilter.isTrue) {
                                    controller.orderListOutbound.clear();
                                    controller.pageOutbound.value = 1;
                                    controller.isLoadData.value = true;
                                    controller.getFilterOutbound();
                                  } else if (controller.isSearch.isTrue) {
                                    controller.orderListOutbound.clear();
                                    controller.pageOutbound.value = 1;
                                    controller.isLoadData.value = true;
                                    controller.searchOrderOutbound();
                                  } else {
                                    controller.getListOutboundGeneral();
                                  }
                                });
                              });
                            },
                          ),
                          index == controller.orderListOutbound.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
                        ],
                      );
                    },
                  ))));
    }

    Widget tabViewInbound() {
      return Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: RawScrollbar(
              controller: controller.scrollControllerInbound,
              thumbColor: AppColors.primaryOrange,
              radius: const Radius.circular(8),
              child: RefreshIndicator(
                  onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.pullRefresh()),
                  color: AppColors.primaryOrange,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollControllerInbound,
                    itemCount: controller.isLoadMore.isTrue ? controller.orderListInbound.length + 1 : controller.orderListInbound.length,
                    itemBuilder: (context, index) {
                      int length = controller.orderListInbound.length;
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
                          CardListOrder(
                            isSoPage: true,
                            order: controller.orderListInbound[index]!,
                            onTap: () {
                              Get.toNamed(RoutePage.salesOrderDetailPage, arguments: controller.orderListInbound[index])!.then((value) {
                                Timer(const Duration(milliseconds: 100), () {
                                  if (controller.isFilter.isTrue) {
                                    controller.orderListInbound.clear();
                                    controller.pageInbound.value = 1;
                                    controller.isLoadData.value = true;
                                    controller.getFilterInbound();
                                  } else if (controller.isSearch.isTrue) {
                                    controller.orderListInbound.clear();
                                    controller.pageInbound.value = 1;
                                    controller.isLoadData.value = true;
                                    controller.searchOrderInbound();
                                  } else {
                                    controller.isLoadData.value = true;
                                    controller.orderListOutbound.clear();
                                    controller.pageInbound.value = 1;
                                    controller.getListInboundGeneral();
                                  }
                                });
                              });
                            },
                          ),
                          index == controller.orderListInbound.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
                        ],
                      );
                    },
                  ))));
    }

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(controller.isFilter.isTrue && controller.listFilter.value.isNotEmpty ? 210 : 160),
            child: Column(
              children: [
                CustomAppbar(
                  title: "Penjualan",
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
                        child: SizedBox(height: 42, child: controller.searchBar),
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
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      Obx(
                        () => controller.isLoadingOutbond.isTrue || controller.isLoadData.isTrue
                            ? const Center(
                                child: ProgressLoading(),
                              )
                            : controller.orderListOutbound.isEmpty
                                ? Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Center(
                                      child: Text(
                                        "Data Penjualan Outbound Belum Ada",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : tabViewOutbound(),
                      ),
                      Obx(() => controller.isLoadingInbound.isTrue || controller.isLoadData.isTrue
                          ? const Center(
                              child: ProgressLoading(),
                            )
                          : controller.orderListInbound.isEmpty || Constant.isScRelation.isTrue
                              ? Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      "Data Penjualan Inbound Belum Ada",
                                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : tabViewInbound()),
                    ],
                  ),
                ),
              ],
            ),
            if (Constant.isSales.isTrue || Constant.isSalesLead.isTrue || Constant.isShopKepper.isTrue) bottomNavbar(),
          ],
        ),
      ),
    );
  }
}
