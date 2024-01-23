
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/farm_closing/farm_closing_controller.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_common.dart';
import 'package:pitik_ppl_app/ui/transfer/transfer_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/12/2023

class FarmClosingActivity extends GetView<FarmClosingController> {
    const FarmClosingActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            WillPopScope(
                onWillPop: () async {
                    controller.previousPage();
                    return false;
                },
                child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(120),
                        child: AppBarFormForCoop(
                            title: 'Farm Closing',
                            coop: controller.coop,
                            onBackPressed: () => controller.previousPage(),
                        ),
                    ),
                    bottomNavigationBar: controller.isLoading.isTrue ? const SizedBox() : Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                        ),
                        child: controller.isClosingButton.isFalse ? controller.bfNext : controller.bfCloseFarm,
                    ),
                    body: Column(
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
                                child: Row(
                                    children: [
                                        Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                                controller.barList[0],
                                                controller.pointList[0]
                                            ]
                                        ),
                                        Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                                controller.barList[1],
                                                controller.pointList[1]
                                            ]
                                        ),
                                        Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                                controller.isOwnFarm() ? controller.barList[2] : const SizedBox(),
                                                controller.pointList[2]
                                            ]
                                        ),
                                        controller.isOwnFarm() ? controller.pointList[3] : const SizedBox()
                                    ]
                                ),
                            ),
                            const SizedBox(height: 8),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: controller.getLabelPoint()),
                            const SizedBox(height: 16),
                            Expanded(
                                child: controller.state.value == 0 ? Column(
                                    children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: TabBar(
                                                controller: controller.harvestTabController,
                                                indicatorColor: GlobalVar.primaryOrange,
                                                labelColor: GlobalVar.primaryOrange,
                                                unselectedLabelColor: GlobalVar.gray,
                                                labelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                                unselectedLabelStyle: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                                                tabs: const [
                                                    Tab(text: "Deal"),
                                                    Tab(text: "Realisasi")
                                                ]
                                            )
                                        ),
                                        const SizedBox(height: 8),
                                        controller.isLoading.isTrue ? const Padding(padding: EdgeInsets.only(top: 100), child: Center(child: ProgressLoading())) :
                                        Expanded(
                                            child: TabBarView(
                                                controller: controller.harvestTabController,
                                                children: [
                                                    RawScrollbar(
                                                        thumbColor: GlobalVar.primaryOrange,
                                                        radius: const Radius.circular(8),
                                                        child: RefreshIndicator(
                                                            onRefresh: () => Future.delayed(
                                                                const Duration(milliseconds: 200), () => HarvestCommon.getDealList(isLoading: controller.isLoading, coop: controller.coop, harvestList: controller.harvestList)
                                                            ),
                                                            child: ListView.builder(
                                                                physics: const AlwaysScrollableScrollPhysics(),
                                                                itemCount: controller.harvestList.length,
                                                                itemBuilder: (context, index) => HarvestCommon.createDealHarvestCard(
                                                                    coop: controller.coop,
                                                                    harvest: controller.harvestList[index],
                                                                    onRefreshData: () => controller.refreshHarvestList())
                                                            ),
                                                        )
                                                    ),
                                                    RawScrollbar(
                                                        thumbColor: GlobalVar.primaryOrange,
                                                        radius: const Radius.circular(8),
                                                        child: RefreshIndicator(
                                                            onRefresh: () => Future.delayed(
                                                                const Duration(milliseconds: 200), () => HarvestCommon.getRealizationList(isLoading: controller.isLoading, coop: controller.coop, realizationList: controller.realizationList)
                                                            ),
                                                            child: ListView.builder(
                                                                physics: const AlwaysScrollableScrollPhysics(),
                                                                itemCount: controller.realizationList.length,
                                                                itemBuilder: (context, index) => HarvestCommon.createRealizationHarvestCard(
                                                                    coop: controller.coop,
                                                                    realization: controller.realizationList[index],
                                                                    onRefreshData: () => controller.refreshHarvestList()
                                                                )
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    ]
                                ) : controller.state.value == 1 ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: controller.isLoading.isTrue ? const Padding(padding: EdgeInsets.only(top: 100), child: Center(child: ProgressLoading())) : ListView(
                                        children: [
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                decoration: const BoxDecoration(
                                                    color: GlobalVar.grayBackground,
                                                    border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Perkiraan Sisa Populasi', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black)),
                                                        Text(controller.populationPrediction.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                                    ],
                                                )
                                            ),
                                            const SizedBox(height: 12),
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                decoration: const BoxDecoration(
                                                    color: GlobalVar.blueBackground,
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                        SvgPicture.asset('images/information_blue_icon.svg'),
                                                        const SizedBox(width: 12),
                                                        Text('Pencatatan sisa ayam yang ada di kandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.blue)),
                                                    ],
                                                )
                                            ),
                                            controller.efTotalMortality,
                                            controller.eaRemarks
                                        ]
                                    )
                                ) : controller.state.value == 2 ? controller.isLoading.isTrue ? const Padding(padding: EdgeInsets.only(top: 100), child: Center(child: ProgressLoading())) : RawScrollbar(
                                    thumbColor: GlobalVar.primaryOrange,
                                    radius: const Radius.circular(8),
                                    child: RefreshIndicator(
                                        onRefresh: () => Future.delayed(
                                            const Duration(milliseconds: 200), () => controller.toCheckFeed()
                                        ),
                                        child: ListView(
                                            children: [
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: GestureDetector(
                                                        onTap: () => controller.showAdjustmentDialog(isFeed: true),
                                                        child: Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                            decoration: const BoxDecoration(
                                                                color: GlobalVar.grayBackground,
                                                                border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                                            ),
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Detail Pakan', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                            const Icon(Icons.arrow_forward, color: GlobalVar.primaryOrange, size: 24)
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total Pakan Diterima', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                            Text(controller.totalFeedReceived.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total Konsumsi Pakan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                            Text(controller.totalFeedConsumption.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Text('Total Pakan Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(height: 8),
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(left: 8),
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Text('Terkonfirmasi', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                                Text(controller.feedConfirmed.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                            ]
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Sisa Pakan Dikandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                            Text(controller.feedOutstandingOnCoop.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 16),
                                                                    Text('Total Pakan Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(height: 8),
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(left: 8),
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Text('Belum Diterima', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                                Text(controller.totalFeedNotReceived.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                            ]
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total Pakan Disesuaikan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                            Text(controller.totalFeedCustomize.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 16),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total Sisa Pakan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                            Text(controller.totalFeedOutstanding.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                ),
                                                const SizedBox(height: 16),
                                                const Divider(height: 2, color: GlobalVar.gray),
                                                const SizedBox(height: 16),
                                                controller.showFeedInformationBanner.isTrue ? Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                        decoration: const BoxDecoration(
                                                            color: GlobalVar.blueBackground,
                                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                                        ),
                                                        child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                                SvgPicture.asset('images/information_blue_icon.svg'),
                                                                const SizedBox(width: 12),
                                                                Text('Transfer pakan belum diterima oleh kandang tujuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.blue)),
                                                            ]
                                                        )
                                                    ),
                                                ) : const SizedBox(),
                                                const SizedBox(height: 16),
                                                Column(
                                                    children: List.generate(controller.feedTransferList.length, (index) => TransferCommon.createTransferCard(
                                                        coop: controller.coop,
                                                        procurement: controller.feedTransferList[index],
                                                        onRefreshData: () => controller.toCheckFeed()
                                                    ))
                                                )
                                            ]
                                        )
                                    )
                                ) : controller.state.value == 3 ? controller.isLoading.isTrue ? const Padding(padding: EdgeInsets.only(top: 100), child: Center(child: ProgressLoading())) : RawScrollbar(
                                    thumbColor: GlobalVar.primaryOrange,
                                    radius: const Radius.circular(8),
                                    child: RefreshIndicator(
                                        onRefresh: () => Future.delayed(
                                            const Duration(milliseconds: 200), () => controller.toCheckOvk()
                                        ),
                                        child: ListView(
                                            children: [
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: GestureDetector(
                                                        onTap: () => controller.showAdjustmentDialog(),
                                                        child: Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                            decoration: const BoxDecoration(
                                                                color: GlobalVar.grayBackground,
                                                                border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                                            ),
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Detail OVK', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                            const Icon(Icons.arrow_forward, color: GlobalVar.primaryOrange, size: 24)
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total OVK Diterima', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                            Text(controller.totalOvkReceived.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total Konsumsi OVK', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                            Text(controller.totalOvkConsumption.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Text('Total OVK Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(height: 8),
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(left: 8),
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Text('Terkonfirmasi', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                                Text(controller.ovkConfirmed.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                            ]
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Sisa OVK Dikandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                            Text(controller.ovkOutstandingOnCoop.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 16),
                                                                    Text('Total OVK Transfer', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                    const SizedBox(height: 8),
                                                                    Padding(
                                                                        padding: const EdgeInsets.only(left: 8),
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                                Text('Belum Diterima', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                                Text(controller.totalOvkNotReceived.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                            ]
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total OVK Disesuaikan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                                            Text(controller.totalOvkCustomize.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    ),
                                                                    const SizedBox(height: 16),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            Text('Total Sisa OVK', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                                                            Text(controller.totalOvkOutstanding.value, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        ),
                                                    ),
                                                ),
                                                const SizedBox(height: 16),
                                                const Divider(height: 2, color: GlobalVar.gray),
                                                const SizedBox(height: 16),
                                                controller.showOvkInformationBanner.isTrue ? Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                        decoration: const BoxDecoration(
                                                            color: GlobalVar.blueBackground,
                                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                                        ),
                                                        child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                                SvgPicture.asset('images/information_blue_icon.svg'),
                                                                const SizedBox(width: 12),
                                                                Text('Transfer OVK belum diterima oleh kandang tujuan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.blue)),
                                                            ],
                                                        )
                                                    ),
                                                ) : const SizedBox(),
                                                const SizedBox(height: 16),
                                                Column(
                                                    children: List.generate(controller.ovkTransferList.length, (index) => TransferCommon.createTransferCard(
                                                        coop: controller.coop,
                                                        procurement: controller.ovkTransferList[index],
                                                        onRefreshData: () => controller.toCheckOvk()
                                                    ))
                                                )
                                            ]
                                        )
                                    )
                                ) : const SizedBox()
                            )
                        ]
                    )
                )
            )
        );
    }
}