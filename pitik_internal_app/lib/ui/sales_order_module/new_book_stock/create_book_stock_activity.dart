import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/sales_order_module/new_book_stock/create_book_stock_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class CreateBookStockPage extends StatelessWidget {
  const CreateBookStockPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    CreateBookStockController controller = Get.put(CreateBookStockController(context: context));

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
          "Detail Penjualan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget bottonNavBar() {
      return Align(
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
            padding: const EdgeInsets.only(left: 16, bottom: 16,right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonFill(
                    controller: GetXCreator.putButtonFillController("bookStocked"),
                    label: "Pesan Stock",
                    onClick: () {
                      showBottomDialog(context, controller);
                    },
                  ),
                ),
              ],
            ),
          ));
    }



    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: appBar(),
        ),
        body: Stack(
          children: [
            Obx(() => controller.isLoading.isTrue ?
            const Center(
              child: ProgressLoading(),
            )
                :
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.spinnerSource,
                    controller.spinnerCustomer,
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Detail SKU",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                      overflow: TextOverflow.clip,
                    ),
                    controller.skuBookSO,
                    if(controller.orderDetail.value!.type =="LB")...[
                        const SizedBox(height: 16,),
                        Text(
                            "Detail Catatan SKU",
                            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                            overflow: TextOverflow.clip,
                        ),
                        controller.skuBookSOLB,
                    ],
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppColors.outlineColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Column(
                        children: [
                            Row(
                                children: [
                                Expanded(
                                    child: Text(
                                    "Total Penjualan",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                                    overflow: TextOverflow.clip,
                                    ),
                                ),
                                ],
                            ),
                            const SizedBox(
                                height: 20,
                            ),
                            Row(
                                children: [
                                Expanded(
                                    child: Text(
                                    "Total Kg",
                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip,
                                    ),
                                ),
                                Text("${controller.skuBookSO.controller.sumKg.value}kg",
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip,),
                                ],
                            ),
                            const SizedBox(
                                height: 8,
                            ),
                            Row(
                                children: [
                                Expanded(
                                    child: Text(
                                    "Total Rp",
                                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip,
                                    ),
                                ),
                                Text(NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits:2).format(controller.skuBookSO.controller.sumPrice.value),
                                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                                    overflow: TextOverflow.clip),
                                ],
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    )],
                ),
              ),
            )
            ),
            bottonNavBar()
          ],

        ));

  }

  showBottomDialog(BuildContext context, CreateBookStockController controller) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text(
                    "Apakah kamu yakin untuk melakukan pemesanan stok?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan semua data yang akan dipesan stok sudah sesuai",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/stock_icon.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.bfYesBook),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.boNoBook,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }
}
