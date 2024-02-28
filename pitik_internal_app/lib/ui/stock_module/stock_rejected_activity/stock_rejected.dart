import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';

import '../../../widget/common/loading.dart';
import '../../../widget/common/stock_status.dart';
import 'stock_rejected_controller.dart';

class StockRejectedActivity extends StatelessWidget {
  const StockRejectedActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final StockRejectedController controller = Get.put(StockRejectedController(context: context));
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
          'Tolak Stock Opname',
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
              boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: controller.btConfirmed),
      );
    }

    Widget infoDetailHeader(String title, String name) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
          ),
          Text(
            name,
            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
          )
        ],
      );
    }

    Widget detailInformation() {
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Stock Opname',
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${controller.opnameModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}',
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                StockStatus(
                  stockStatus: '${controller.opnameModel.status}',
                  isApprove: controller.opnameModel.reviewer != null ? true : false,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader('Sumber', '${controller.opnameModel.operationUnit!.operationUnitName}'),
          ],
        ),
      );
    }

    Widget detailSKU(Products product) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller: GetXCreator.putAccordionController('${product.name!}Rejected'),
            headerText: product.name!,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.productItems!
                    .map((item) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item!.name!,
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jumlah sebelum',
                                        style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        item.previousQuantity == null && item.previousWeight == null ? '-' : '${item.previousQuantity ?? item.previousWeight ?? 0} ${product.quantityUOM ?? product.weightUOM}',
                                        style: item.previousQuantity == null && item.previousWeight == null
                                            ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.previousWeight == 0 || item.previousQuantity == 0
                                                ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : item.quantity == item.previousQuantity
                                                    ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                    : item.weight == item.previousWeight
                                                        ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                        : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jumlah Sesudah',
                                        style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${item.quantity ?? item.weight ?? 0} ${product.quantityUOM ?? product.weightUOM}',
                                        style: item.quantity == null && item.weight == null
                                            ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.weight == 0 || item.quantity == 0
                                                ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : item.quantity == item.previousQuantity
                                                    ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                    : item.weight == item.previousWeight
                                                        ? AppTextStyle.greenTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                        : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jumlah Selisih',
                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    item.previousQuantity == null && item.previousWeight == null
                                        ? '-'
                                        : item.quantity != null
                                            ? item.quantity! > item.previousQuantity!
                                                ? '> ${item.quantity! - item.previousQuantity!} ${product.quantityUOM ?? product.weightUOM}'
                                                : item.quantity! < item.previousQuantity!
                                                    ? '< ${item.previousQuantity! - item.quantity!} ${product.quantityUOM ?? product.weightUOM}'
                                                    : item.previousQuantity! - item.quantity! == 0
                                                        ? '-'
                                                        : '-'
                                            : item.weight! > item.previousWeight!
                                                ? '> ${item.weight! - item.previousQuantity!} ${product.quantityUOM ?? product.weightUOM}'
                                                : item.weight! < item.previousWeight!
                                                    ? '< ${item.previousQuantity! - item.weight!} ${product.quantityUOM ?? product.weightUOM}'
                                                    : item.previousQuantity! - item.weight! == 0
                                                        ? '-'
                                                        : '-',
                                    style: item.previousQuantity == null && item.previousWeight == null
                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                        : item.quantity != null
                                            ? item.quantity! > item.previousQuantity!
                                                ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : item.quantity! < item.previousQuantity!
                                                    ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                    : item.previousQuantity! - item.quantity! == 0
                                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                        : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                            : item.weight! > item.previousWeight!
                                                ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                : item.weight! < item.previousWeight!
                                                    ? AppTextStyle.redTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                    : item.weight! - item.previousWeight! == 0
                                                        ? AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium)
                                                        : AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
                                  )
                                ],
                              ),
                              if (product.productItems!.last != item && product.productItems!.length > 1) ...[
                                const SizedBox(
                                  height: 24,
                                ),
                                const Divider(
                                  color: AppColors.outlineColor,
                                  thickness: 1,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ]
                            ],
                          ),
                        ))
                    .toList())),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Obx(
          () => controller.isLoading.isTrue
              ? const Center(
                  child: ProgressLoading(),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailInformation(),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Detail SKU',
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Column(children: controller.opnameModel.products!.map((e) => detailSKU(e!)).toList()),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.outlineColor, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total/Global(kg)',
                                    style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    '${controller.opnameModel.totalWeight ?? 0} Kg',
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                    bottomNavbar()
                  ],
                ),
        ));
  }
}
