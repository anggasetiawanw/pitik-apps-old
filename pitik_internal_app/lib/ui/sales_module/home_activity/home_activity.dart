/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-16 08:37:59
/// @modify date 2023-02-16 08:37:59
/// @desc [description]

import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/sales_module/home_activity/home_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_home.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/search_field.dart';

class HomePageCustomer extends StatelessWidget {
    const HomePageCustomer({super.key,});

    @override
    Widget build(BuildContext context) {
        Timer? debounce;
        final HomePageCustomerController controller = Get.put(HomePageCustomerController(context: context));
        // controller.checkVersion(context);

        Widget bottomNavbar() {
            return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: double.infinity,
                    height: 100,
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
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                                child: ButtonFill(
                                    controller: GetXCreator.putButtonFillController("dataBaruHome"),
                                    label: "Data Baru",
                                    onClick: () {
                                        GlobalVar.track("Click_Data_Baru");
                                        Get.toNamed(RoutePage.newDataCustomer)!.then((value) {
                                            controller.isLoading.value =true;
                                            controller.listCustomer.value.clear();
                                            controller.page.value = 1;
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.getListCustomer();
                                            });
                                        });
                                    },
                                ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: ButtonOutline(
                                    controller: GetXCreator.putButtonOutlineController("kunjunganHome"),
                                    label: "Kunjungan",
                                    onClick: () {
                                        _showBottomDialog(context, controller);
                                    },
                                ),
                            ),
                        ],
                    ),
                ),
            );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: SearchField(
              onChanged: (text) {
                if (text.length > 1) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 1000), () {
                        // do something with query
                        controller.page.value = 1;
                        controller.isSearch.value = true;
                        controller.searchValue.value = text;
                        controller.getSearchCustomer();
                    });

                } else if (text.length <= 1) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    controller.isLoading.value = false;
                    controller.isSearch.value = false;
                    controller.searchValue.value = "";
                }
              },
            ),
          ),
          body: Stack(
              children: [
                  Obx(() =>
                      controller.isLoading.isTrue
                      ? const SizedBox()
                      : controller.searchCustomer.value.isEmpty && controller.isSearch.isTrue
                          ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                    child: Text(
                                        "Data Tidak ditemukan",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                        textAlign: TextAlign.center,
                                    ),
                                ),
                            )
                          : controller.listCustomer.value.isEmpty && controller.isSearch.isFalse
                          ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                    child: Text(
                                        "Customer Belom Ada Silahkan Lakukan Visit Customer",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                        textAlign: TextAlign.center,
                                    ),
                                ),
                            )
                            : Container(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                                child: ListView.builder(
                                    controller: controller.scrollController,
                                    itemCount: controller.isSearch.isTrue
                                        ? controller.isLoadMore.isTrue
                                            ? controller.searchCustomer.value.length + 1
                                            : controller.searchCustomer.value.length
                                        : controller.isLoadMore.isTrue
                                            ? controller.listCustomer.value.length + 1
                                            : controller.listCustomer.value.length,
                                    itemBuilder: (context, index) {
                                        int length = controller.isSearch.isTrue ? controller.searchCustomer.value.length : controller.listCustomer.value.length;
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
                                                CardListHome(
                                                    customer: controller.isSearch.isTrue ? controller.searchCustomer.value[index]! : controller.listCustomer.value[index]!,
                                                    onTap: () {
                                                        Get.toNamed(
                                                            RoutePage.customerDetailPage,
                                                            arguments: controller.isSearch.isTrue ? controller.searchCustomer.value[index]! : controller.listCustomer.value[index]!,
                                                        )!.then((value) {
                                                            controller.isLoading.value =true;
                                                            controller.listCustomer.value.clear();
                                                            controller.page.value = 1;
                                                            Timer(const Duration(milliseconds: 500), () {
                                                                controller.getListCustomer();
                                                            });
                                                        });
                                                    },
                                                ),
                                                controller.isSearch.isTrue ? index == controller.searchCustomer.value.length - 1 ? const SizedBox(height: 120)
                                                : const SizedBox()
                                                : index == controller.listCustomer.value.length - 1 ? const SizedBox(height: 120)
                                                : const SizedBox(),
                                            ],
                                        );
                                    },
                                ),
                            )
                    ),
                    bottomNavbar(),
                    Obx(
                        () => controller.isLoading.isTrue && controller.isSearch.isFalse
                            ? Center(
                                  child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.black54,
                                      child: const Center(
                                          child:ProgressLoading()
                                      )
                                  ),
                              )
                        : const SizedBox(),
                    ),
                ],
            ),
        );
    }

    _showBottomDialog(BuildContext context, HomePageCustomerController controller) {
        return showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
                return Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 60,
                                height: 4,
                                decoration: BoxDecoration(color: AppColors.outlineColor, borderRadius: BorderRadius.circular(2)),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                                child: Text(
                                  "Siapa Persona Customer Kamu?",
                                  style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                                ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                                child: const Text(
                                    "Tentukan persona dari customer yang kamu kunjungi agar lebih mudah saat mengisi data?",
                                    style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)
                                ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: SvgPicture.asset("images/who_customer.svg"),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: controller.dataBaruModalButton),
                                        const SizedBox(width: 16),
                                        Expanded(child: controller.kunjunganModalButton),
                                    ],
                                ),
                            ),
                            const SizedBox(height: Constant.bottomSheetMargin,)
                        ],
                    ),
                );
            }
        );
    }
}
