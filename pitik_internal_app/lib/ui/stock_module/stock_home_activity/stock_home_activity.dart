import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/stock_module/stock_home_activity/stock_home_controller.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/list_card_stock.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockHomeActivity extends GetView<StockHomeController> {
  const StockHomeActivity({super.key});
  @override
  Widget build(BuildContext context) {
    final StockHomeController controller = Get.put(StockHomeController(context: context,));
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
          "Persediaan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget tabBar() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              controller: controller.tabController.controller,
              tabs: const [
                Tab(
                  text: "Stock Opname",
                ),
                Tab(
                  text: "Persediaan",
                )
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

    Widget listExpand(String tille, String text){
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(
                tille,
                style:AppTextStyle.grayTextStyle.copyWith(fontSize: 10),
            ),
            Text(
                text,
                style: AppTextStyle.blackTextStyle
                    .copyWith(fontWeight: FontWeight.w500,fontSize: 10),
            )
            ],
        );
    }

    Widget detailListExpand(ChartData pieData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const SizedBox(height: 8,),
            Row(
                children: [
                    Container(
                        width: 22,
                        height: 8,
                        decoration: BoxDecoration(
                            color: pieData.color,
                            borderRadius: BorderRadius.circular(8)
                        ),
                    ),
                    const SizedBox(width: 8,),
                Text(
                    pieData.x,
                    style:
                        AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                ],
            ),
            if(pieData.y1 == AppStrings.LIVE_BIRD ||pieData.y1 == AppStrings.AYAM_UTUH||pieData.y1 == AppStrings.BRANGKAS)  ...[
                listExpand("Total Ekor", "${pieData.y ==0 ? "-" : pieData.y} Ekor"),
                const SizedBox(height: 4,),
                listExpand("Total Kg", "${pieData.y == 0?"-":pieData.y2} Kg"),
            ]else         
                listExpand("Total Kg", "${pieData.y2 ==0 ? "-": pieData.y2} Kg"),

        ],
      );
    }
    
    Widget generateLegend(List<ChartData> data){
        List<ChartData> dataSort = List.from(data);
        dataSort.sort((a,b)=>a.x.compareTo(b.x));
        return Column(
            children: 
            dataSort.map((e) => detailListExpand(e)).toList(),
        );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body: Obx(() => controller.isLoading.isTrue ? 
            const Center(child: ProgressLoading())
            :Stack(
        children: [
             Column(
            children: [
              tabBar(),
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBarView(
                          controller: controller.tabController.controller,
                          children: [
                            Column(
                              children: [
                                controller.sourceOpname,
                                 controller.isLoadingOpname.isTrue ? const Expanded(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: ProgressLoading())
                                )
                                : 
                                controller.listOpname.value.isEmpty ?
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                            SvgPicture.asset("images/empty_icon.svg"),
                                            const SizedBox(
                                                height: 16,
                                            ),
                                            Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Text(
                                                "Belum ada data,\nsilahkan pilih sumber\nterlebih dahulu",
                                                style: AppTextStyle.greyTextStyle.copyWith(
                                                    fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                                ),
                                            )
                                            ],
                                        ),
                                      ),
                                    ):    
                                    Expanded(
                                      child: ListView.builder(
                                          controller: controller.scrollController,
                                          itemCount: controller.isLoadMore.isTrue ? controller.listOpname.value.length + 1 : controller.listOpname.value.length,
                                          itemBuilder: (context, index) {
                                          int length = controller.listOpname.value.length;
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
                                               controller.listOpname.value[index]!.products!.isNotEmpty ? CardListStock(
                                                    opnameModel: controller.listOpname.value[index]!,
                                                    onTap: () {
                                                        Get.toNamed(RoutePage.stockDetail, arguments: controller.listOpname.value[index]!)!.then((value) {
                                                            Timer(const Duration(milliseconds: 500), () {
                                                                if(controller.selectSourceOpname != null){
                                                                    controller.isLoadingOpname.value = true;
                                                                    controller.listOpname.value.clear();
                                                                    controller.page.value = 0;
                                                                    controller.getListOpname();
                                                                }
                                                            });
                                                        });
                                                    },
                                                    isApprove: controller.listOpname.value[index]!.reviewer != null ? true :false,
                                                ) : const SizedBox(),
                                                  index == controller.listOpname.value.length - 1 ? const SizedBox(height: 120): const SizedBox(),
                                              ],
                                          );
                                          },
                                      ),
                                    ),
                                // ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: AppColors.outlineColor)
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                              "Filter Persediaan",
                                              style:
                                                  AppTextStyle.blackTextStyle.copyWith(
                                              fontWeight: AppTextStyle.bold,
                                              ),
                                          ),
                                          controller.sourceLatestStock,
                                          controller.categoryStock,
                                      ]),
                                  ),
                                  
                                  controller.isLoadingStock.isTrue ? const Expanded(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child:ProgressLoading(),),
                                  )
                                  : 
                                   controller.chartData.value.isEmpty ?
                                          Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              SvgPicture.asset("images/empty_icon.svg"),
                                              const SizedBox(
                                                  height: 16,
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text(
                                                  "Belum ada data,\nsilahkan pilih sumber\nterlebih dahulu yang tersedia \n",
                                                  style: AppTextStyle.greyTextStyle.copyWith(
                                                      fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  ),
                                              )
                                              ],
                                          ),
                                          ) :
                                          Container(
                                            margin: const EdgeInsets.only(top: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "Prosentase Persediaan",
                                                      style:
                                                          AppTextStyle.blackTextStyle.copyWith(
                                                      fontWeight: AppTextStyle.bold,
                                                      ),
                                                  ),
                                                SizedBox(
                                                    height: MediaQuery.of(context).size.height * 0.6,
                                                    width:  double.infinity,
                                                  child: SfCartesianChart(
                                                      primaryXAxis: CategoryAxis(
                                                        
                                                        isVisible: false
                                                      ),
                                                        // primaryYAxis: CategoryAxis(),
                                                      tooltipBehavior: controller.tooltip,
                                                      series: <ChartSeries<ChartData, String>>[
                                                            BarSeries<ChartData, String>(
                                                                dataSource: controller.chartData.value,
                                                                xValueMapper: (ChartData data, _) => data.x,
                                                                yValueMapper: (ChartData data, _) => controller.categoryStock.controller.textSelected.value == AppStrings.LIVE_BIRD ||controller.categoryStock.controller.textSelected.value  == AppStrings.AYAM_UTUH||controller.categoryStock.controller.textSelected.value  == AppStrings.BRANGKAS ?data.y : data.y2,
                                                                pointColorMapper:(ChartData data,_) => data.color,
                                                                dataLabelMapper: (ChartData data,_) => data.x,
                                                                name: controller.chartData.value[0].y1,            //         ),
                                                                enableTooltip: true,
                                                                dataLabelSettings: DataLabelSettings(
                                                                    alignment: ChartAlignment.near,
                                                                    labelAlignment: ChartDataLabelAlignment.middle,
                                                                    isVisible: true, 
                                                                    textStyle: AppTextStyle.whiteTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500,),
                                                                    showCumulativeValues: true,
                                                                    labelIntersectAction: LabelIntersectAction.none
                                                                  ),
                                                          )
                                                      ]
                                                  ),
                                                ),                                    
                                                Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(width: 1,color: AppColors.grey)
                                                ),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(controller.chartData.value[0].y1,style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),),
                                                    // Column(
                                                    //     children: 
                                                        
                                                    //     controller.chartDataLegend.map((e) => detailListExpand(e)).toList(),
                                                    // ),
                                                    generateLegend(controller.chartData.value)
                                                  ],
                                                ),
                                                ),
                                                const SizedBox(
                                                    height: 150,
                                                )
                                                ],
                                            ),
                                          ),
                                ],
                              ),
                            ),
                          ]))),
            ],
          ),
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
                      offset: Offset(0.75, 0.0))
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: controller.stockOpnameButton,
            ),
          ),
        ],
      ),
    ));
  }
}
