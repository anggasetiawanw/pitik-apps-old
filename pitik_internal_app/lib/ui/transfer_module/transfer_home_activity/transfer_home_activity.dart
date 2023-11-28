import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/transfer_module/transfer_home_activity/transfer_home_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_transfer.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class TransferHomeActivity extends StatelessWidget {
  const TransferHomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final TransferHomeController controller = Get.put(TransferHomeController(context: context));
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
          "Transfer",
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body: Stack(
        children: [
          Obx(
            () => controller.isLoading.isTrue
                ? const Center(child: ProgressLoading())
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.listTransfer.value.isEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                "List Transfer Belum Ada Data!",
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
                              onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () => controller.pullRefresh()),
                              color: AppColors.primaryOrange,
                              child: ListView.builder(
                                controller: controller.scrollController,
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
                                          Get.toNamed(RoutePage.transferDetail, arguments: controller.listTransfer.value[index]!)!.then((value) {
                                            controller.isLoading.value = true;
                                            controller.listTransfer.value.clear();
                                            controller.page.value = 1;
                                            Timer(const Duration(milliseconds: 500), () {
                                              controller.getListTransfer();
                                            });
                                          });
                                        },
                                        transferModel: controller.listTransfer.value[index]!,
                                        isGoodReceipts: false,
                                      ),
                                      index == controller.listTransfer.value.length - 1 ? const SizedBox(height: 120) : const SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: controller.createTransfer,
            ),
          ),
        ],
      ),
    );
  }
}
