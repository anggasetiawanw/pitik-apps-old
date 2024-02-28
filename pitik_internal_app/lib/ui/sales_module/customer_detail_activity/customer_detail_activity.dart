/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-08 11:50:45
/// @modify date 2023-02-08 11:51:03
/// @desc [description]

import 'dart:async';

import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/product_model.dart';

import '../../../utils/constant.dart';
import '../../../utils/route.dart';
import '../../../widget/common/lead_status.dart';
import '../../../widget/common/list_card_detail.dart';
import '../../../widget/common/loading.dart';
import '../../../widget/controllers/tab_detail_controller.dart';
import 'customer_detail_controller.dart';

class CustomerDetail extends GetView<CustomerDetailController> {
  const CustomerDetail({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final CustomerDetailController controller = Get.put(CustomerDetailController(
      context: context,
    ));

    final TabDetailController tabController = Get.put(TabDetailController());

    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          'Detail Customer',
          style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _showButtonDialog(context, controller);
            },
            child: Container(
              color: Colors.transparent,
              height: 32,
              width: 32,
              margin: const EdgeInsets.only(right: 20, top: 13, bottom: 13),
              child: SvgPicture.asset('images/dot_icon.svg'),
            ),
          ),
        ],
      );
    }

    Widget header() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: const BoxDecoration(color: AppColors.primaryLight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'images/pitik_avatar.svg',
              width: 56,
              height: 56,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.customer.value!.businessName}',
                    style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Kunjungan Terakhir',
                    style: AppTextStyle.subTextStyle.copyWith(fontSize: 10),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    controller.customer.value!.latestVisit != null
                        ? '${controller.dateCustomer.value!.day}/${controller.dateCustomer.value!.month}/${controller.dateCustomer.value!.year} - ${controller.dateCustomer.value!.hour}:${controller.dateCustomer.value!.minute}'
                        : '-',
                    style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 10),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
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
              boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: controller.kunjunganButton,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: controller.editButton,
                ),
              ],
            ),
          ));
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
                ? LeadStatus(leadStatus: controller.customerDetail.value?.latestVisit?.leadStatus)
                : Expanded(
                    flex: 2,
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
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
                listDetail('Jenis Kebutuhan', products.category!.name!, false),
                listDetail('Ukuran', "${products.value ?? "-"} ${products.uom ?? ""}", false),
                listDetail('Kebutuhan Kg/Hari', '${products.dailyQuantity} Kg/Hari', false),
                listDetail('Harga /Kg ', "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(products.price!)} /Kg", false),
              ],
            )),
      );
    }

    Widget listExpandadle(List<Products?> products) {
      return Column(children: products.map((Products? products) => customExpandalbe(products!)).toList());
    }

    Widget tabViewDetail() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            listDetail('Tipe Bisnis', controller.customerDetail.value!.businessType != null ? '${controller.customerDetail.value!.businessType}' : '-', false),
            listDetail('Nama Pemilik', controller.customerDetail.value!.ownerName != null ? '${controller.customerDetail.value!.ownerName}' : '-', false),
            listDetail('Nomor Telepon', controller.customerDetail.value!.phoneNumber != null ? '${controller.customerDetail.value!.phoneNumber}' : '-', false),
            listDetail('PIC Sales', controller.customerDetail.value!.salesperson!.email != null ? '${controller.customerDetail.value!.salesperson!.email}' : '-', false),
            listDetail('Branch', controller.customerDetail.value!.branch != null ? '${controller.customerDetail.value!.branch!.name}' : '-', false),
            listDetail('Lokasi Google Plus Code', controller.customerDetail.value!.plusCode != null ? '${controller.customerDetail.value!.plusCode}' : '-', false),
            listDetail('Kota', controller.customerDetail.value!.city!.name != null ? '${controller.customerDetail.value!.city!.name}' : '-', false),
            listDetail('Kecamatan', controller.customerDetail.value!.district!.name != null ? '${controller.customerDetail.value!.district!.name}' : '-', false),
            listDetail(
                'Supplier',
                controller.customerDetail.value!.supplierDetail != null
                    ? '${controller.customerDetail.value!.supplierDetail}'
                    : controller.customerDetail.value!.supplier != null
                        ? '${controller.customerDetail.value!.supplier}'
                        : '-',
                false),
            listDetail('LeadStatus', '', true),
            listDetail('Keterangan', controller.customerDetail.value!.latestVisit != null && controller.customerDetail.value!.latestVisit!.remarks != null ? Uri.decodeFull(controller.customerDetail.value!.latestVisit!.remarks!) : '-', false),
            listDetail('Prospek Pembelian', controller.customerDetail.value!.latestVisit != null && controller.customerDetail.value!.latestVisit!.prospect != null ? '${controller.customerDetail.value!.latestVisit!.prospect}' : '-', false),
            controller.customerDetail.value!.products != null ? listExpandadle(controller.customerDetail.value!.products as List<Products?>) : const SizedBox(),
            const SizedBox(
              height: 120,
            ),
          ],
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
              controller: tabController.controller,
              tabs: const [
                Tab(
                  text: 'Details',
                ),
                Tab(
                  text: 'Kunjungan',
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: appBar(),
      ),
      body: Stack(
        children: [
          Obx(
            () => controller.isLoadingDetails.isTrue
                ? const SizedBox()
                : Column(children: [
                    header(),
                    tabBar(),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: TabBarView(
                          controller: tabController.controller,
                          children: [
                            tabViewDetail(),
                            controller.isLoadingKunjungan.isTrue
                                ? const Center(
                                    child: ProgressLoading(),
                                  )
                                : controller.visitCustomer.value.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Belom Ada Data, Silahkan Lakukan Visit Customer',
                                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: controller.scrollController,
                                        itemCount: controller.isLoadMore.isTrue ? controller.visitCustomer.value.length + 1 : controller.visitCustomer.value.length,
                                        itemBuilder: (context, index) {
                                          final int length = controller.visitCustomer.value.length;
                                          if (index >= length) {
                                            return const Column(
                                              children: [
                                                Center(child: ProgressLoading()),
                                                SizedBox(
                                                  height: 120,
                                                ),
                                              ],
                                            );
                                          }
                                          return Column(
                                            children: [
                                              CardListDetail(
                                                customer: controller.visitCustomer.value[index]!,
                                                onTap: () {
                                                  Get.toNamed(RoutePage.visitDetailPage, arguments: [
                                                    controller.customerDetail.value!.id!,
                                                    controller.visitCustomer.value[index]!.id,
                                                    controller.visitCustomer.value[index]!.salesperson!.email,
                                                    controller.dateCustomer.value,
                                                  ])!
                                                      .then((value) {
                                                    Timer(const Duration(milliseconds: 500), () {
                                                      controller.getData();
                                                    });
                                                  });
                                                },
                                              ),
                                              index == controller.visitCustomer.value.length - 1
                                                  ? const SizedBox(
                                                      height: 120,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          );
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ]),
          ),
          bottonNavBar(),
          Obx(
            () => controller.isLoadingDetails.isTrue
                ? Center(
                    child: Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, color: Colors.black54, child: const Center(child: ProgressLoading())),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _showButtonDialog(BuildContext context, CustomerDetailController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
            alignment: const Alignment(1, -1),
            child: GestureDetector(
              onTap: () {
                _showBottomDialog(context, controller);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 50, right: 30),
                width: 135,
                height: 44,
                child: Stack(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => controller.isLoadingDetails.isTrue ? const SizedBox() : SvgPicture.asset(controller.customerDetail.value!.isArchived! ? 'images/unarchive_data.svg' : 'images/archive_data.svg'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Obx(
                          () => controller.isLoadingDetails.isTrue
                              ? const SizedBox()
                              : Text(
                                  controller.customerDetail.value!.isArchived! ? 'Pulihkan Data' : 'Arsipkan Data',
                                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                                ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: const Alignment(1, -1),
                    child: Image.asset(
                      'images/triangle_icon.png',
                      height: 17,
                      width: 17,
                    ),
                  )
                ]),
              ),
            ));
      },
    );
  }

  Future<void> _showBottomDialog(BuildContext context, CustomerDetailController controller) {
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
                  child: Obx(
                    () => controller.isLoadingDetails.isTrue
                        ? const SizedBox()
                        : Text(
                            controller.customerDetail.value!.isArchived! ? 'Apakah Kamu yakin untuk memulihkan data ini?' : 'Apakah Kamu yakin untuk mengarsipkan data ini?',
                            style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: Obx(
                    () => controller.isLoadingDetails.isTrue
                        ? const SizedBox()
                        : Text(controller.customerDetail.value!.isArchived! ? 'Data yang kamu kembalikan akan dapat digunakan kembali' : 'Data yang kamu arsipkan tidak akan muncul di kolom pilihan nama bisnis pada form kunjungan',
                            style: const TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/unarchive.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: controller.iyaArchiveButton,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.tidakArchiveButton,
                      ),
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
