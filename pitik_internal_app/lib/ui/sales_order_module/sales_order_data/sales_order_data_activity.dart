///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/sales_order_module/sales_order_data/sales_order_data_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_order.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class SalesOrderPage extends StatefulWidget {
  const SalesOrderPage({super.key});

  @override
  State<SalesOrderPage> createState() => _SalesOrderPageState();
}

class _SalesOrderPageState extends State<SalesOrderPage>{


  @override
  Widget build(BuildContext context) {
    final SalesOrderController controller = Get.put(SalesOrderController(context: context));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          "Penjualan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget bottomNavbar() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
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
          padding: const EdgeInsets.only(left: 16, bottom: 16,right: 16),
          child: controller.btPenjualan,
        ),
      );
    }



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar()),
      body: Obx(() =>
          controller.isLoading.isTrue ? Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: ProgressLoading()
                  )
              ),
            )
              : Stack(
        children: [
          controller.orderList.value.isEmpty
              ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                "Data Order Belum Ada",
                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                textAlign: TextAlign.center,
              ),
            ),
          ) : Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            child: RawScrollbar(
                    controller: controller.scrollController,
                    thumbColor: AppColors.primaryOrange,
                    radius: const Radius.circular(8),
                    child: RefreshIndicator(
                        onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.getListOrder()),
                        color: AppColors.primaryOrange,
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: controller.scrollController,
                            itemCount: controller.isLoadMore.isTrue
                                ? controller.orderList.value.length + 1
                                : controller.orderList.value.length,
                            itemBuilder: (context, index) {
                                int length = controller.orderList.value.length;
                                if (index >= length) {
                                return const Column(
                                    children: [
                                    Center(
                                        child:ProgressLoading()
                                    ),
                                    SizedBox(height: 120),
                                    ],
                                );
                            }
                            return Column(
                                children: [
                                    CardListOrder(
                                        isSoPage: true,
                                    order:controller.orderList.value[index]!,
                                    onTap: () {
                                        Get.toNamed(RoutePage.salesOrderDetailPage, arguments: controller.orderList.value[index])!.then((value) {
                                        controller.isLoading.value = true;
                                        controller.orderList.value.clear();
                                        controller.page.value = 1;
                                        Timer(const Duration(milliseconds: 500), () {
                                            controller.getListOrders();
                                        });
                                        });
                                    },
                                    ),
                                    index == controller.orderList.value.length - 1 ? const SizedBox(height: 120)
                                        : const SizedBox(),
                                ],
                            );
                        },
                    ),
                )
            ),
          ),
          bottomNavbar(),
        ],
      ),
    ));
  }
}

