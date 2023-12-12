
import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/gr_confirmation/gr_confirmation_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 27/10/2023

class GrConfirmationActivity extends GetView<GrConfirmationController> {
    const GrConfirmationActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(95),
                    child: AppBarFormForCoop(
                        title: 'Konfirmasi Penerimaan',
                        coop: controller.coop,
                    ),
                ),
                bottomNavigationBar: controller.isLoading.isTrue ? const Center(child: ProgressLoading()) :
                controller.procurement.statusText != GlobalVar.DIPROSES && controller.procurement.statusText != GlobalVar.DITOLAK && controller.procurement.statusText != GlobalVar.ABORT &&
                    controller.procurement.statusText != GlobalVar.LENGKAP && controller.procurement.statusText != GlobalVar.DITERIMA ? Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnGrConfirmation"), label: "Konfirmasi", onClick: () => controller.sendConfirmation()),
                ) : const SizedBox(),
                body: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: controller.isLoading.isFalse ? ListView(
                        children: [
                            Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                    color: GlobalVar.grayBackground,
                                    border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Column(
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Detail ${controller.isFromTransfer ? 'Transfer' : 'Order'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.black)),
                                                controller.getStatus()
                                            ]
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Kode Pesanan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(
                                                    controller.procurement.erpCode ?? '-',
                                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                )
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Kode Pembelian', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(
                                                    controller.procurement.purchaseRequestErpCode ?? '-',
                                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                )
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jenis Order', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                Text(
                                                    controller.procurement.type == null ? '-' : controller.procurement.type == 'pakan' ? 'Pakan' : 'OVK',
                                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                )
                                            ]
                                        ),
                                        controller.procurement.type != null && controller.procurement.type == 'pakan' ?
                                        Column(
                                            children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Digabung?', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        Text(
                                                            controller.procurement.mergedLogistic == null ? '-' : controller.procurement.mergedLogistic! ? 'Ya' : 'Tidak',
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        )
                                                    ]
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Nama Kandang', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        Text(
                                                            controller.procurement.mergedLogisticCoopName == null ? '-' : controller.procurement.mergedLogisticCoopName!,
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        )
                                                    ]
                                                )
                                            ],
                                        ) : controller.procurement.type != null && controller.procurement.type == 'pakan' && controller.isOwnFarm() ?
                                        Column(
                                            children: [
                                                const SizedBox(height: 8),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text('Asal Sumber', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                                        Text(
                                                            controller.procurement.isTransferRequest != null && controller.procurement.isTransferRequest! ? 'Unit' :
                                                            controller.procurement.details.isEmpty && controller.procurement.internalOvkTransferRequest != null ? 'Vendor' :
                                                            '-',
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                        )
                                                    ]
                                                ),
                                            ],
                                        ) : const SizedBox()
                                    ]
                                )
                            ),
                            const SizedBox(height: 8),
                            controller.procurement.statusText == GlobalVar.DIPROSES || controller.procurement.statusText == GlobalVar.DITOLAK ?
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        controller.procurement.type == null ? '-' : controller.procurement.type == 'pakan' ? 'Detail Pakan' : 'Detail OVK',
                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                    ),
                                    const SizedBox(height: 12),
                                    controller.createProductCards(productList: controller.procurement.details, isFeed: controller.procurement.type == 'pakan')
                                ],
                            ) :
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const SizedBox(height: 8),
                                    controller.isAlreadyReturned() ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Container(
                                                width: MediaQuery.of(context).size.width - 32,
                                                padding: const EdgeInsets.all(16),
                                                decoration: const BoxDecoration(
                                                    color: GlobalVar.blueBackground,
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        SvgPicture.asset('images/information_blue_icon.svg'),
                                                        const SizedBox(width: 8),
                                                        Expanded(child: Text(
                                                            'Ada pengurangan jumlah ${controller.procurement.type == 'pakan' ? 'Pakan' : 'OVK'} pada proses Retur',
                                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.blue)
                                                        ))
                                                    ]
                                                )
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                                '${controller.procurement.type == 'pakan' ? 'Pakan' : 'OVK'} Diretur',
                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                            ),
                                            const SizedBox(height: 8),
                                            controller.createProductForReturnedCards(goodReceipt: controller.procurement.goodsReceipts, isFeed: controller.procurement.type == 'pakan')
                                        ],
                                    ) : const SizedBox(),
                                    controller.procurement.goodsReceipts.isNotEmpty && controller.isGrNotAllReturned() ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                                controller.procurement.statusText == GlobalVar.SEBAGIAN ? 'Penerimaan Sebelumnya' :
                                                controller.procurement.statusText == GlobalVar.LENGKAP ? '${controller.procurement.type == 'pakan' ? 'Pakan' : 'OVK'} Diterima' :
                                                'Detail ${controller.procurement.type == 'pakan' ? 'Pakan' : 'OVK'}',
                                                style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black),
                                            ),
                                            const SizedBox(height: 8),
                                            controller.createProductsDetailOrPreviousReceivedCards(goodReceipts: controller.procurement.goodsReceipts, isFeed: controller.procurement.type == 'pakan'),
                                        ],
                                    ) : const SizedBox(),
                                    controller.procurement.statusText != GlobalVar.LENGKAP  && controller.procurement.statusText != GlobalVar.DITERIMA &&
                                        controller.procurement.statusText != GlobalVar.DIPROSES && controller.procurement.statusText != GlobalVar.DITOLAK && controller.procurement.statusText != GlobalVar.ABORT &&
                                        controller.procurement.details.isNotEmpty ?
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Sisa Belum Diterima', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                                            const SizedBox(height: 8),
                                            controller.createProductReceivedCards(productList: controller.procurement.details),
                                            controller.grReceivedDateField,
                                            controller.grNotesField,
                                            controller.isLoadingPicture.isTrue ? SizedBox(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width - 32,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(top: 16),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                            const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                                            const SizedBox(width: 16),
                                                            Text('Upload bukti foto...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                                        ],
                                                    ),
                                                )
                                            ) : controller.grPhotoField,
                                            const SizedBox(height: 32)
                                        ],
                                    ) : const SizedBox(),
                                ]
                            )
                        ]
                    ) : const SizedBox()
                )
            )
        );
    }
}