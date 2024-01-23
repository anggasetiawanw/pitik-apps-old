
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pitik_ppl_app/ui/order/list_order_controller.dart';
import 'package:components/app_bar_form_for_coop.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ListOrderActivity extends GetView<ListOrderController> {
    const ListOrderActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(120),
                    child: AppBarFormForCoop(
                        title: 'Order',
                        coop: controller.coop,
                    ),
                ),
                floatingActionButton: controller.tabController.index == 0 ? Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: FloatingActionButton(
                        elevation: 12,
                        onPressed: () => Get.toNamed(RoutePage.orderRequestPage, arguments: [controller.coop, false, controller.fromCoopRest])!.then((value) => controller.refreshOrderList()),
                        backgroundColor: GlobalVar.primaryOrange,
                        child: const Icon(Icons.add, color: Colors.white),
                    ),
                ) : const SizedBox(),
                body: Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TabBar(
                                controller: controller.tabController,
                                dividerColor: Colors.white,
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
                        const SizedBox(height: 8),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Text('Daftar Order', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                    GestureDetector(
                                        onTap: () => controller.showMenuBottomSheet(),
                                        child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                                color: GlobalVar.primaryLight
                                            ),
                                            child: SvgPicture.asset('images/filter_icon.svg'),
                                        ),
                                    )
                                ],
                            ),
                        ),
                        const SizedBox(height: 8),
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
                ),
            )
        );
    }
}