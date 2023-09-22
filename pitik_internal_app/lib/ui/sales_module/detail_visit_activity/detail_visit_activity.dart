import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/ui/sales_module/detail_visit_activity/detail_visit_controller.dart';
import 'package:pitik_internal_app/widget/common/lead_status.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-16 08:43:14
/// @modify date 2023-02-16 08:43:14
/// @desc [description]

class DetailVisitCustomer extends GetView<DetailVisitController> {
  const DetailVisitCustomer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DetailVisitController controller =
        Get.put(DetailVisitController(context: context));

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
          "Detail Kunjungan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget detailKunjungan() {
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(
              width: 1,
              color: AppColors.outlineColor,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detail Kunjungan",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                ),
                Text(
                  controller.dateCustomer.value != null
                      ? "${controller.dateCustomer.value!.day} ${DateFormat.MMM().format(controller.dateCustomer.value!)} ${controller.dateCustomer.value!.year} - ${controller.dateCustomer.value!.hour}:${controller.dateCustomer.value!.minute}"
                      : "-",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PIC Sales",
                  style: AppTextStyle.greyTextStyle.copyWith(
                    fontSize: 10,
                  ),
                ),
                Text(
                  controller.salerPerson != null
                      ? "${controller.salerPerson}"
                      : "-",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget listDetail(String label, String value, bool isLeadStatus) {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            isLeadStatus
                ? LeadStatus(
                    leadStatus: controller.customer.value != null
                        ? controller.customer.value!.leadStatus
                        : null)
                : Expanded(
                    flex: 2,
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.blackTextStyle
                          .copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                      overflow: TextOverflow.clip,
                    ),
                  ),
          ],
        ),
      );
    }

    Widget customExpandalbe(Products products) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Expandable(
            controller: GetXCreator.putAccordionController(products.id!),
            headerText: products.name!,
            child: Column(
              children: [
                listDetail("Jenis Kebutuhan", products.category!.name!, false),
                listDetail("Ukuran","${ products.value ?? "-"} ${products.uom ?? ""}", false),
                listDetail("Kebutuhan Kg/Hari","${products.dailyQuantity} Kg/Hari", false),
                listDetail("Harga /Kg ", "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(products.price!)} /Kg",false),
             ],
            )),
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
                child: ProgressLoading()
              )
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        detailKunjungan(),
                        listDetail("Lead Status", "", true),
                        listDetail(
                            "Apakah ada issue terkait harga yang kita tawarkan?",
                            controller.customer.value!.orderIssue!
                                ? "Ya"
                                : "Tidak",
                            false),
                        controller.customer.value!.orderIssue!
                            ? listDetail(
                                "Jenis Kendala",
                                controller.customer.value!.orderIssueCategories !=
                                        null
                                    ? controller.customer.value!.orderIssueCategories!.map((e) => e!.title.toString()).reduce((a, b) =>'$a , $b')
                                    : "-",
                                false)
                            : const SizedBox(),
                        listDetail(
                            "Keterangan",
                            controller.customer.value!.remarks != null
                                ? controller.customer.value!.remarks!
                                : "-",
                            false),
                        listDetail(
                            "Prospek Pembelian",
                            controller.customer.value!.prospect !=
                                    null
                                ? "${controller.customer.value!.prospect}"
                                : "-",
                            false),
                        Container(
                          margin: const EdgeInsets.only(top: 24, bottom: 8),
                          child: const Divider(
                            thickness: 2,
                            color: AppColors.outlineColor,
                          ),
                        ),
                        controller.customer.value!.products != null
                            ? Column(
                                children: (controller.customer.value!.products
                                        as List<Products?>)
                                    .map((Products? products) =>
                                        customExpandalbe(products!))
                                    .toList())
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
