import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/sales_module/data_visit_activity/data_visit_controller.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class VisitActivity extends GetView<VisitController> {
  const VisitActivity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    VisitController controller = Get.put(
      VisitController(context: context),
    );

    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          "Data Kunjungan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
      );
    }

    Widget tileDetail(String label, String value) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyle.subTextStyle.copyWith(fontSize: 10),
            ),
            Text(
              value,
              style: AppTextStyle.blackTextStyle
                  .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
            )
          ],
        ),
      );
    }

    Widget detailBisnis() {
      return Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(width: 1, color: AppColors.grey),
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Detail Bisnis",
                    style: AppTextStyle.blackTextStyle
                        .copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  ),
                  Text(
                    "${controller.dateNow.day}/${controller.dateNow.month}/${controller.dateNow.year}",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10),
                  )
                ],
              ),
            ),
            tileDetail(
              "Nama Bisnis",
              controller.customer.value != null &&
                      controller.customer.value!.businessName != null
                  ? "${controller.customer.value!.businessName}"
                  : "-",
            ),
            tileDetail(
              "Tipe Bisnis",
              controller.customer.value != null &&
                      controller.customer.value!.businessType != null
                  ? "${controller.customer.value!.businessType}"
                  : "-",
            ),
            tileDetail(
              "Nama Pemilik",
              controller.customer.value != null &&
                      controller.customer.value!.ownerName != null
                  ? "${controller.customer.value!.ownerName}"
                  : "-",
            ),
            tileDetail(
                "Nomor Telepon ",
                controller.customer.value != null &&
                        controller.customer.value!.phoneNumber != null
                    ? "${controller.customer.value!.phoneNumber}"
                    : "-"),
            tileDetail(
                "Kota",
                controller.customer.value != null &&
                        controller.customer.value!.city != null
                    ? "${controller.customer.value!.city!.name}"
                    : "-"),
            tileDetail(
                "Kecamatan",
                controller.customer.value != null &&
                        controller.customer.value!.district != null
                    ? "${controller.customer.value!.district!.name}"
                    : "-"),
          ],
        ),
      );
    }

    Widget bottonNavbar() {
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
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Obx(() => controller.isLoading.isTrue
                ? const SizedBox()
                : controller.customer.value != null
                    ? controller.buttonFillSelesai
                    : controller.buttonFillCariDetailBisnis)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: appBar(),
      ),
      body: Stack(
        children: [
          Obx(() => controller.isLoading.isTrue
              ? const Center(
                  child: ProgressLoading()
                )
              : controller.customer.value != null
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          detailBisnis(),
                          controller.spinnerLead,
                          controller.spinnerKendala,
                          Obx(() => controller.isLoadKendala.isTrue? const Center(
                            child: ProgressLoading()
                          ): controller.spinnerMulti,),
                          Obx(() => controller.isLoadApi.isTrue? const Center(
                            child: ProgressLoading()
                          ): controller.skuCard),
                          controller.editAlasan,
                          controller.spinnerProspek,
                          const Divider(
                            thickness: 1,
                            color: AppColors.grey,
                          ),
                          controller.isLoadCheckin.isFalse? controller.checkinButton : const Center(
                            child: ProgressLoading()
                          ),
                          controller.showErrorCheckin.isTrue
                              ? Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: controller.isSuccessCheckin.isTrue
                                          ? const Color(0xFFECFDF3)
                                          : const Color(0xFFFEF3F2),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    children: [
                                      
                              SvgPicture.asset(controller.isSuccessCheckin.isTrue ? "images/success_checkin.svg" : "images/failed_checkin.svg", height: 14),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.isSuccessCheckin.isTrue
                                              ? "Selamat kamu berhasil melakukan Check in"
                                              : "Checkin Gagal ${controller.error.value}, coba Kembali",
                                          style: TextStyle(
                                              color: controller
                                                      .isSuccessCheckin.isTrue
                                                  ? const Color(0xFF12B76A)
                                                  : const Color(0xFFF04438),
                                              fontSize: 10),
                                              overflow: TextOverflow.clip,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    )
                  : Align(
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
                              "Belum ada data bisnis\nsilahkan pilih detail bisnis \nterlebih dahulu",
                              style: AppTextStyle.greyTextStyle.copyWith(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    )),
          bottonNavbar()
        ],
      ),
    );
  }

  void openModalBottom() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
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
              Text(
                "Silahkan pilih nama bisnis yang akan dilakukan kunjungan",
                style: AppTextStyle.primaryTextStyle
                    .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
              ),
              controller.spinnerProvince,
              controller.spinnerKota,
              controller.spinnerKecamatan,
              controller.spinnerNamaBisnis,
              controller.buttonIsiKunjungan,
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      //   ignoreSafeArea: false,
      //   useRootNavigator: true,
      enableDrag: false,
    );
  }
}