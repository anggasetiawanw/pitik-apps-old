import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:pitik_internal_app/ui/home/job_activity/job_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/list_card_stock.dart';
import 'package:pitik_internal_app/widget/common/list_card_terminate.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class JobActivity extends GetView<JobController> {
  const JobActivity({super.key});

  @override
  Widget build(BuildContext context) {
    JobController controller = Get.put(JobController(context: context));

    Widget tabBar() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 26),
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
                  text: "Stock Opname",
                ),
                Tab(
                  text: "Pemusnahan",
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

    Widget tabViewStockOpname() {
      return Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: RawScrollbar(
          controller: controller.scrollStockOpname,
          thumbColor: AppColors.primaryOrange,
          radius: const Radius.circular(8),
          child: RefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.pullRefreshStock()),
            color: AppColors.primaryOrange,
            child: ListView.builder(
              controller: controller.scrollStockOpname,
              itemCount: controller.isLoadMore.isTrue ? controller.listStock.value.length + 1 : controller.listStock.value.length,
              itemBuilder: (context, index) {
                int length = controller.listStock.value.length;
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
                    CardListStock(
                      opnameModel: controller.listStock.value[index]!,
                      onTap: () {
                        Get.toNamed(RoutePage.stockDetail, arguments: controller.listStock.value[index]!)!.then((value) {
                          Timer(const Duration(milliseconds: 500), () {
                            controller.isLoadingStock.value = true;
                            controller.listStock.value.clear();
                            controller.pageStock.value = 1;
                            controller.getListStock();
                          });
                        });
                      },
                      isApprove: controller.listStock.value[index]!.reviewer != null ? true : false,
                    ),
                    index == controller.listStock.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    Widget tabViewTerminate() {
      return Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: RawScrollbar(
          controller: controller.scrollTerminate,
          thumbColor: AppColors.primaryOrange,
          radius: const Radius.circular(8),
          child: RefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.pullrefreshTerminate()),
            color: AppColors.primaryOrange,
            child: ListView.builder(
          controller: controller.scrollTerminate,
          itemCount: controller.isLoadMore.isTrue ? controller.listTerminate.value.length + 1 : controller.listTerminate.value.length,
          itemBuilder: (context, index) {
            int length = controller.listTerminate.value.length;
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
                CardListTerminate(
                  onTap: () {
                    Get.toNamed(RoutePage.terminateDetail, arguments: controller.listTerminate.value[index]!)!.then((value) {
                      controller.isLoadingTerminate.value = true;
                      controller.listTerminate.value.clear();
                      controller.pageTerminate.value = 1;
                      Timer(const Duration(milliseconds: 500), () {
                        controller.getListTerminate();
                      });
                    });
                  },
                  terminateModel: controller.listTerminate.value[index]!,
                  isApproved: controller.listTerminate.value[index]!.reviewer != null ? true : false,
                ),
                index == controller.listTerminate.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
              ],
            );
          },
        ),
          ),
        ),
        
        
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          title: "Tugas",
          onBack: () {},
          isBack: false,
        ),
      ),
      body: Column(
        children: [
          tabBar(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  Obx(
                    () => controller.isLoadingStock.isTrue
                        ? const Center(
                            child: ProgressLoading(),
                          )
                        : controller.listStock.value.isEmpty
                            ? Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                  child: Text(
                                    "Data Stock Perlu Persetujuan Belum Ada",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : tabViewStockOpname(),
                  ),
                  Obx(() => controller.isLoadingTerminate.isTrue
                      ? const Center(
                          child: ProgressLoading(),
                        )
                      : controller.listTerminate.value.isEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: Text(
                                  "Data Pemusnahan Perlu Persetujuan Belum Ada",
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : tabViewTerminate()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
