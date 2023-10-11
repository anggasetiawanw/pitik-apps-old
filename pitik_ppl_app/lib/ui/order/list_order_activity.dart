
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/order/list_order_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ListOrderActivity extends GetView<ListOrderController> {
    const ListOrderActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            color: GlobalVar.primaryOrange
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        GestureDetector(
                                            onTap: () => Get.back(),
                                            child: const Icon(Icons.arrow_back, color: Colors.white),
                                        ),
                                        Text('Order', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: Colors.white)),
                                        const SizedBox()
                                    ],
                                ),
                                const SizedBox(height: 16),
                                Text(controller.coop.coopName ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text('DOC-In ${controller.coop.startDate ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.white))
                            ],
                        ),
                    ),
                ),
                body: Obx( () =>
                    Column(
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: TabBar(
                                    controller: controller.tabController,
                                    indicatorColor: GlobalVar.primaryOrange,
                                    labelColor: GlobalVar.primaryOrange,
                                    unselectedLabelColor: GlobalVar.gray,
                                    labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                    unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                    tabs: const [
                                        Tab(text: "Pengajuan"),
                                        Tab(text: "Diproses"),
                                        Tab(text: "Penerimaan")
                                    ]
                                ),
                            ),
                            controller.isLoading.isTrue ? Padding(padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - 80) / 3), child: const ProgressLoading()) :
                            Expanded(
                                child: TabBarView(
                                    controller: controller.tabController,
                                    children: [
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            child: RefreshIndicator(
                                                onRefresh: () => Future.delayed(
                                                    const Duration(milliseconds: 200), () => controller.getListRequested()
                                                ),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    itemCount: controller.orderList.length,
                                                    itemBuilder: (context, index) => controller.createOrderCard(
                                                        typePosition: 0,
                                                        procurement: controller.orderList[index]
                                                    )
                                                ),
                                            )
                                        ),
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            child: RefreshIndicator(
                                                onRefresh: () => Future.delayed(
                                                    const Duration(milliseconds: 200), () => controller.getListProcessed()
                                                ),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    itemCount: controller.orderList.length,
                                                    itemBuilder: (context, index) => controller.createOrderCard(
                                                        typePosition: 1,
                                                        procurement: controller.orderList[index]
                                                    )
                                                ),
                                            )
                                        ),
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            child: RefreshIndicator(
                                                onRefresh: () => Future.delayed(
                                                    const Duration(milliseconds: 200), () => controller.getListReceived()
                                                ),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    itemCount: controller.orderList.length,
                                                    itemBuilder: (context, index) => controller.createOrderCard(
                                                        typePosition: 2,
                                                        procurement: controller.orderList[index]
                                                    )
                                                ),
                                            )
                                        )
                                    ]
                                )
                            )
                        ],
                    )
                ),
            )
        );
    }
}