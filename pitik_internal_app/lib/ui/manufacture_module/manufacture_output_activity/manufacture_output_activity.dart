import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/manufacture_module/manufacture_output_activity/manufacture_output_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/manufacture_status.dart';

class ManufactureOutputActivity extends StatelessWidget {
  const ManufactureOutputActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final ManufactureOutputController controller =
        Get.put(ManufactureOutputController(context: context));
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
          "Output Manufaktur",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
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
            style: AppTextStyle.blackTextStyle
                .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
          )
        ],
      );
    }

    Widget detailInformation() {
      return Container(
        margin: const EdgeInsets.only(top: 16, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8)),
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
                        "${controller.manufactureModel.input!.name}",
                        style: AppTextStyle.blackTextStyle.copyWith(
                            fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.manufactureModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ManufactureStatus(
                    manufactureStatus: controller.manufactureModel.status),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader(
                "Sumber", controller.manufactureModel.operationUnit!.operationUnitName!),
          ],
        ),
      );
    }

    Widget infoDetailSKU(String title, String name) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
          ),
          Text(
            name,
            style: AppTextStyle.blackTextStyle
                .copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
          )
        ],
      );
    }

    List<Widget> detailSku() {
      return [
        Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: const BoxDecoration(
              color: AppColors.headerSku,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Text(
            "${controller.manufactureModel.input!.productItems![0]!.name}",
            style:
                AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.outlineColor, width: 1),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8))),
          child: Column(
            children: [
              infoDetailSKU(
                  "Kategori SKU", controller.manufactureModel.input!.name!),
              const SizedBox(
                height: 14,
              ),
                infoDetailSKU("Jumlah Ekor","${controller.manufactureModel.input!.productItems![0]!.quantity} Ekor"),
                if(controller.manufactureModel.input!.productItems![0]!.weight !=0 && controller.manufactureModel.input!.productItems![0]!.weight != null)...[
                const SizedBox(
                    height: 14,
                ),
                infoDetailSKU( "Total", "${controller.manufactureModel.input!.productItems![0]!.weight} Kg"),
                ],
            ],
          ),
        ),
      ];
    }

    Widget bottomNavbar() {
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(child:ButtonFill(controller: GetXCreator.putButtonFillController("saveButton"), label: "Simpan", onClick: (){
                                    controller.updateManufacture("OUTPUT_DRAFT");
                                })),
                            const SizedBox(width: 16,),
                            Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("confirmButtin"), label: "Konfirmasi", onClick: (){_showBottomDialog(context,controller);}))
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
      body:Obx(() => controller.isLoading.isTrue || controller.isLoadData.isTrue ? const Center(child: ProgressLoading()): Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailInformation(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Detail SKU",
                      style: AppTextStyle.blackTextStyle
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ...detailSku(),
                  controller.typeOutput,
                  Obx(() =>controller.showSKUCard.isTrue ? controller.skuCard:const SizedBox()),
                  const SizedBox(height: 100,)
                ],
              ),
            ),
          ),
          bottomNavbar()
        ],
      ),
    ));
  }
  
  _showBottomDialog(BuildContext context, ManufactureOutputController controller) {
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
                    "Apakah kamu yakin data yang dimasukan sudah benar?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan semua data yang kamu masukan semua sudah benar",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/visit_customer.svg",
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
                      Expanded(
                        child: controller.noButton
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
