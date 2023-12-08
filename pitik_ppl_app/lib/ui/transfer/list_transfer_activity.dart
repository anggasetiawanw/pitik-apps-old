
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:components/app_bar_form_for_coop.dart';
import 'package:pitik_ppl_app/ui/transfer/list_transfer_controller.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ListTransferActivity extends GetView<ListTransferController> {
    const ListTransferActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Obx(() =>
                Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(110),
                        child: AppBarFormForCoop(
                            title: 'Transfer',
                            coop: controller.coop,
                        ),
                    ),
                    floatingActionButton: controller.tabController.index == 0 ? Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: FloatingActionButton(
                            elevation: 12,
                            onPressed: () => Get.toNamed(RoutePage.transferRequestPage, arguments: [controller.coop, false])!.then((value) => controller.refreshTransferList()),
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
                                    indicatorColor: GlobalVar.primaryOrange,
                                    labelColor: GlobalVar.primaryOrange,
                                    unselectedLabelColor: GlobalVar.gray,
                                    labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                    unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                    tabs: const [
                                        Tab(text: "Kirim"),
                                        Tab(text: "Terima")
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
                                                    const Duration(milliseconds: 200), () => TransferCommon.getListSend(coop: controller.coop, isLoading: controller.isLoading, destinationTransferList: controller.transferList)
                                                ),
                                                child: ListView.builder(
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    itemCount: controller.transferList.length,
                                                    itemBuilder: (context, index) => TransferCommon.createTransferCard(
                                                        coop: controller.coop,
                                                        procurement: controller.transferList[index],
                                                        onRefreshData: () => controller.refreshTransferList()
                                                    )
                                                )
                                            )
                                        ),
                                        RawScrollbar(
                                            thumbColor: GlobalVar.primaryOrange,
                                            radius: const Radius.circular(8),
                                            child: RefreshIndicator(
                                                onRefresh: () => Future.delayed(
                                                    const Duration(milliseconds: 200), () => TransferCommon.getListReceived(coop: controller.coop, isLoading: controller.isLoading, destinationTransferList: controller.transferList)
                                                ),
                                                child: ListView.builder(
                                                    physics: const AlwaysScrollableScrollPhysics(),
                                                    itemCount: controller.transferList.length,
                                                    itemBuilder: (context, index) => TransferCommon.createTransferCard(
                                                        isGrTransfer: true,
                                                        coop: controller.coop,
                                                        procurement: controller.transferList[index],
                                                        onRefreshData: () => controller.refreshTransferList()
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
            )
        );
    }
}