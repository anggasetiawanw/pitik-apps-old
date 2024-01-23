import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_approve_activity/terminate_approve_controller.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';
import 'package:pitik_internal_app/widget/common/transfer_terminate.dart';

class TerminateApproveActivity extends StatelessWidget {
  const TerminateApproveActivity({super.key});

  @override
  Widget build(BuildContext context) {
    TerminateApproveController controller = Get.put(TerminateApproveController(context: context));
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
          "Setujui Pemusnahan",
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget bottomNavbar() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: controller.btConfirmed),
          ],
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
                        "Informasi Pemusnahan",
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.terminateModel.code} - ${controller.createdDate.day} ${DateFormat.MMM().format(controller.createdDate)} ${controller.createdDate.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                TerminateStatus(terminateStatus: controller.terminateModel.status, isApproved: controller.terminateModel.reviewer != null ? true : false,),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            infoDetailHeader("Sumber", "${controller.terminateModel.operationUnit!.operationUnitName}"),
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
            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
          )
        ],
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
              ? const Center(child: ProgressLoading())
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
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "Detail SKU",
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: const BoxDecoration(color: AppColors.headerSku, borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                              child: Text(
                                "${controller.terminateModel.product!.productItem!.name}",
                                style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(color: AppColors.outlineColor, width: 1),
                                  left: BorderSide(color: AppColors.outlineColor, width: 1),
                                  right: BorderSide(color: AppColors.outlineColor, width: 1),
                                  top: BorderSide(color: AppColors.outlineColor, width: 0.1),
                                ),
                                // border: Border.all(color: AppColors.grey, width: 1),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                              child: Column(
                                children: [
                                  infoDetailSKU("Kategori SKU", "${controller.terminateModel.product!.name}"),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  controller.terminateModel.product!.productItem!.quantity != null ? infoDetailSKU("Jumlah Ekor", "${controller.terminateModel.product!.productItem!.quantity} Ekor") : const SizedBox(),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  infoDetailSKU("Total", "${controller.terminateModel.product!.productItem!.weight} Kg"),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Image.network(
                              controller.terminateModel.imageLink!,
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryOrange,
                                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                  ),
                                );
                              },
                            ),
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
                                  Text("Berita Acara", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.w700)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  controller.efName,
                                  controller.efMail,
                                  Row(
                                    children: [
                                      Obx(() => Checkbox(
                                          value: controller.isSelectedBox.value,
                                          activeColor: AppColors.primaryOrange,
                                          side: const BorderSide(color: AppColors.primaryOrange, width: 2),
                                          onChanged: (isSelect) {
                                            controller.isSelectedBox.value = isSelect!;
                                            controller.isSelectedBox.refresh();
                                            if (controller.isSelectedBox.isTrue) {
                                              controller.btConfirmed.controller.enable();
                                            } else {
                                              controller.btConfirmed.controller.disable();
                                            }
                                          })),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "Saya dengan teliti dan sadar sudah memeriksa hasil Pemusnahan diatas",
                                        style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                        overflow: TextOverflow.clip,
                                      ))
                                    ],
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
