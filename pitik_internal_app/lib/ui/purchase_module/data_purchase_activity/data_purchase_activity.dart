///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/purchase_module/data_purchase_activity/data_purchase_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_purchase.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage>{


  @override
  Widget build(BuildContext context) {
    final PurchaseController controller = Get.put(PurchaseController(context: context));
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
          "Pembelian",
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
          padding: const EdgeInsets.only(left: 16, bottom: 16,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ButtonFill(
                  controller: GetXCreator.putButtonFillController("dataBaruHome"),
                  label: "Buat Pembelian",
                  onClick: () {
                    Get.toNamed(RoutePage.newDataPurchase)!.then((value) {
                      controller.isLoading.value =true;
                      controller.purchaseList.value.clear();
                        controller.page.value = 0;
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



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar()),
      body: Stack(
        children: [
          Obx(() =>
          controller.isLoading.isTrue ? const SizedBox()
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
              : Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.isLoadMore.isTrue
                  ? controller.purchaseList.value.length + 1
                  : controller.purchaseList.value.length,
              itemBuilder: (context, index) {
                int length = controller.purchaseList.value.length;
                if (index >= length) {
                  return const Column(
                    children: [
                      Center(
                        child: ProgressLoading()
                      ),
                      SizedBox(height: 120),
                    ],
                  );
                }
                return Column(
                  children: [
                    CardListPurchase(
                      purchase: controller.purchaseList.value[index]!,
                      onTap: () {
                        Get.toNamed(RoutePage.purchaseDetailPage, arguments: controller.purchaseList.value[index]!)!.then((value) {
                          controller.isLoading.value =true;
                          controller.purchaseList.value.clear();
                            controller.page.value = 0;
                          Timer(const Duration(milliseconds: 100), () {
                            controller.getListPurchase();
                          });
                        });
                      },
                    ),
                    index == controller.purchaseList.value.length - 1 ? const SizedBox(height: 120)
                        : const SizedBox(),
                  ],
                );
              },
            ),
          )
          ),
          bottomNavbar(),
          Obx(
                () => controller.isLoading.isTrue
                ? const Center(
                      child: ProgressLoading()
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}