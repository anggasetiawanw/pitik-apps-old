import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';

import '../../../utils/constant.dart';
import '../../../widget/common/loading.dart';
import 'stock_opname_controller.dart';

class StockOpnameActivity extends StatelessWidget {
  const StockOpnameActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final StockOpnameController controller = Get.put(StockOpnameController(context: context));
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
          'Stock Opname',
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ButtonFill(
                      controller: GetXCreator.putButtonFillController('saveButton'),
                      label: 'Simpan',
                      onClick: () {
                        Constant.track('Click_Simpan_Stock_Opname');
                        if (controller.isEdit.isTrue) {
                          controller.updateStock('DRAFT');
                        } else {
                          controller.createStockOpname('DRAFT');
                        }
                      })),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: ButtonOutline(
                      controller: GetXCreator.putButtonOutlineController('confirmButtin'),
                      label: 'Konfirmasi',
                      onClick: () {
                        _showBottomDialog(context, controller);
                      }))
            ],
          ),
        ),
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
                          children: [
                            controller.sourceStock,
                            if (controller.listStockField.value.isNotEmpty) ...controller.listStockField.value,
                            if (controller.efTotal.controller.showField.isTrue)
                              Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: AppColors.outlineColor, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: controller.efTotal),
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

  Future<void> _showBottomDialog(BuildContext context, StockOpnameController controller) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
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
                    'Apakah kamu yakin data yang dimasukan sudah benar?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan semua data yang kamu masukan semua sudah benar', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/visit_customer.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: controller.noButton),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Constant.bottomSheetMargin,
                )
              ],
            ),
          );
        });
  }
}
