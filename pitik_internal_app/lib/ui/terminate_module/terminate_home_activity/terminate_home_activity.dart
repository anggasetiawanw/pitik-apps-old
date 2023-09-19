import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_home_activity/terminate_home_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_terminate.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class TerminateHomeAcitivity extends StatelessWidget {
  const TerminateHomeAcitivity({super.key});

  @override
  Widget build(BuildContext context) {
    final TerminateHomeController controller =Get.put(TerminateHomeController(context: context));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          "Pemusnahan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
          Obx(() => controller.isLoading.isTrue
              ? const Center(child: ProgressLoading() )
              : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.listTerminate.value.isEmpty ?
                    Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                    child: Text(
                                        "Pemusnahan Belum Ada Data!",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                        textAlign: TextAlign.center,
                                    ),
                                ),
                    ):    
                    ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.isLoadMore.isTrue ? controller.listTerminate.value.length + 1 : controller.listTerminate.value.length,
                        itemBuilder: (context, index) {
                        int length = controller.listTerminate.value.length;
                        if (index >= length) {
                            return const Column(
                            children: [
                                Center(
                                    child: ProgressLoading()
                                ),
                                SizedBox(height: 100),
                                ],);
                        }
                        return Column(
                            children: [
                                CardListTerminate(
                                    onTap: () {
                                        Get.toNamed(RoutePage.terminateDetail, arguments: controller.listTerminate.value[index]!)!.then((value) {
                                            controller.isLoading.value =true;
                                            controller.listTerminate.value.clear();
                                            controller.page.value = 0;
                                            Timer(const Duration(milliseconds: 500), () {
                                                controller.getListTerminate();
                                            });
                                        });
                                    },
                                    terminateModel: controller.listTerminate.value[index]!,
                                ),
                                index == controller.listTerminate.value.length - 1 ? const SizedBox(height: 120): Container(),
                            ],
                        );
                        },
                    ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(20, 158, 157, 157),
                            blurRadius: 5,
                            offset: Offset(0.75, 0.0))],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: controller.createTerminate,
                ),
            ),
            ],
        ),
    );
  }
}
