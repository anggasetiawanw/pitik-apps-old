
import 'package:common_page/library/component_library.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/good_receipt_model.dart';
import 'package:model/procurement_model.dart';
import 'package:model/product_model.dart';
import 'package:model/response/procurement_detail_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 27/10/2023

class GrConfirmationController extends GetxController {
    BuildContext context;
    GrConfirmationController({required this.context});

    late Coop coop;
    late Procurement procurement;
    late bool isFeed;
    late bool isFromTransfer;

    late DateTimeField grReceivedDateField;
    late EditAreaField grNotesField;

    var isLoading = false.obs;
    RxList<Product?> productList = <Product?>[].obs;
    RxMap<EditField, bool> efProductReceivedList = <EditField, bool>{}.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        procurement = Get.arguments[1];
        isFeed = Get.arguments[2];
        isFromTransfer = Get.arguments[3];

        grReceivedDateField = DateTimeField(controller: GetXCreator.putDateTimeFieldController("grReceivedDateField$isFromTransfer"), label: "Tanggal Penerimaan", hint: "2022-12-31", alertText: "Tanggal Penerimaan harus diisi..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        grNotesField = EditAreaField(controller: GetXCreator.putEditAreaFieldController("grNotesField$isFromTransfer"), label: "Keterangan", hint: "Tulis Keterangan disini...", alertText: "Keterangan belum diisi..!", maxInput: 250,
            onTyping: (text, field) {}
        );

        _getDetailReceived();
    }

    bool isOwnFarm() {
        return coop.isOwnFarm != null && coop.isOwnFarm!;
    }

    void _getDetailReceived() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getDetailReceived,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, '${isFromTransfer ? 'v2/transfer-requests/' : 'v2/purchase-orders/'}${procurement.id}'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as ProcurementDetailResponse).data != null) {
                            procurement = body.data!;
                            productList.value = body.data!.details;
                        }

                        isLoading.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar("Pesan", '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                        isLoading.value = false;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar("Pesan", exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                        isLoading.value = false;
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    bool isAlreadyReturned() {
        bool isReturned = false;
        returned:
        for (var gr in procurement.goodsReceipts) {
            if (gr != null) {
                for (var p in gr.details) {
                    if (p!.isReturned != null && p.isReturned!) {
                        isReturned = true;
                        break returned;
                    }
                }
            }
        }

        return isReturned;
    }

    Column createProductCards({required List<Product?> productList, bool isFeed = false}) {
        return Column(
            children: List.generate(productList.length, (index) {
                if (productList[index] != null) {
                    Product product = productList[index]!;
                    return Container(
                        width: MediaQuery.of(Get.context!).size.width,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Merek', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 4),
                                Text(
                                    isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? '',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                                const SizedBox(height: 12),
                                Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 4),
                                Text(
                                    '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                            ],
                        ),
                    );
                } else {
                    return const SizedBox();
                }
            }),
        );
    }

    Column createProductForReturnedCards({required List<GoodReceipt?> goodReceipt, bool isFeed = false}) {
        List<Product?> returnedData = [];
        for (var gr in goodReceipt) {
            if (gr != null) {
                for (var product in gr.details) {
                    if (product != null && product.isReturned != null && product.isReturned!) {
                        returnedData.add(product);
                    }
                }
            }
        }

        return Column(
            children: List.generate(returnedData.length, (index) {
                if (goodReceipt[index] != null) {
                    Product product = returnedData[index]!;
                    return Container(
                        width: MediaQuery.of(Get.context!).size.width,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                            color: GlobalVar.grayBackground,
                            border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Merek', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 4),
                                Text(
                                    isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? '',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                                const SizedBox(height: 12),
                                Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                const SizedBox(height: 4),
                                Text(
                                    '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                            ],
                        ),
                    );
                } else {
                    return const SizedBox();
                }
            }),
        );
    }

    Column createProductsDetailOrPreviousReceivedCards({required List<GoodReceipt?> goodReceipts, bool isFeed = false}) {
        return Column(
            children: List.generate(goodReceipts.length, (index) {
                if (goodReceipts[index] != null) {
                    GoodReceipt goodReceipt = goodReceipts[index]!;
                    DateTime receivedDate = Convert.getDatetime(goodReceipt.receivedDate!);

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Text('Tanggal Penerimaan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                    Text('${Convert.getYear(receivedDate)}-${Convert.getMonthNumber(receivedDate)}-${Convert.getDay(receivedDate)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                                ],
                            ),
                            const SizedBox(height: 4),
                            Text('Total Masuk', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                            const SizedBox(height: 8),
                            Column(
                                children: List.generate(goodReceipt.details.length, (index) {
                                    Product product = goodReceipt.details[index]!;
                                    return Container(
                                        width: MediaQuery.of(Get.context!).size.width,
                                        padding: const EdgeInsets.all(16),
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                        child: Text(
                                            '${isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? ''} - (${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''})',
                                            style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                        )
                                    );
                                }),
                            ),
                            procurement.statusText == GlobalVar.LENGKAP || procurement.statusText == GlobalVar.DITERIMA ?
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Text('Keterangan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                                    Text(
                                        goodReceipt.remarks ?? '-',
                                        style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                    )
                                ]
                            ) : const SizedBox(),
                            const SizedBox(height: 8),
                            Column(
                                children: List.generate(goodReceipt.photos.length, (index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Image.network(
                                                goodReceipt.photos[index] != null ? goodReceipt.photos[index]!.url! : '',
                                                width: MediaQuery.of(context).size.width - 36,
                                                height: MediaQuery.of(context).size.width /2,
                                                fit: BoxFit.fill,
                                            ),
                                        ),
                                    );
                                }),
                            ),
                            const SizedBox(height: 8),
                            const Divider(color: GlobalVar.grayBackground, height: 2),
                        ],
                    );
                } else {
                    return const SizedBox();
                }
            }),
        );
    }

    Column createProductReceivedCards({required List<Product?> productList}) {
        efProductReceivedList.clear();
        return Column(
            children: List.generate(procurement.details.length, (index) {
                if (procurement.details[index] == null) {
                    return const SizedBox();
                } else {
                    Product product = procurement.details[index]!;
                    EditField editField = EditField(
                        controller: GetXCreator.putEditFieldController('efProductReceived${product.id}'),
                        label: 'Total Diterima',
                        hint: 'Ketik di sini',
                        alertText: 'Harus diisi..!',
                        textUnit: product.uom ?? product.purchaseUom ?? '',
                        maxInput: 50,
                        onTyping: (text, field) {}
                    );

                    efProductReceivedList[editField] = false;
                    return Container(
                        width: MediaQuery.of(Get.context!).size.width,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                // Row(
                                //     children: [
                                //         GestureDetector(
                                //             onTap: () {
                                //                 print('checked -> ${efProductReceivedList.value[editField]}');
                                //                 if (efProductReceivedList[editField] == null || !efProductReceivedList[editField]!) {
                                //                     efProductReceivedList.update(editField, (value) => true);
                                //                 } else {
                                //                     efProductReceivedList.update(editField, (value) => false);
                                //                 }
                                //             },
                                //             child: Container(
                                //                 width: 24,
                                //                 height: 24,
                                //                 decoration: BoxDecoration(
                                //                     border: Border.fromBorderSide(BorderSide(color: efProductReceivedList[editField] != null && efProductReceivedList[editField]! ? GlobalVar.primaryOrange : GlobalVar.gray, width: 2)),
                                //                     color: efProductReceivedList[editField] != null && efProductReceivedList[editField]! ? GlobalVar.primaryOrange : GlobalVar.gray
                                //                 ),
                                //             ),
                                //         ),
                                //         const SizedBox(width: 8),
                                //         Text('Retur', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                                //     ],
                                // ),
                                // const SizedBox(height: 8),
                                Text(
                                    '${isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? ''} - (${product.remaining == null ? '' : product.remaining!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''})',
                                    style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                ),
                                editField
                            ],
                        ),
                    );
                }
            })
        );
    }

    Container getStatus() {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: procurement.statusText == null ? Colors.transparent :
                       procurement.statusText == GlobalVar.PENGAJUAN || procurement.statusText == GlobalVar.SEBAGIAN || procurement.statusText == GlobalVar.NEED_APPROVAL || procurement.statusText == GlobalVar.SUBMITTED ? GlobalVar.primaryLight2 :
                       procurement.statusText == GlobalVar.DIPROSES ? GlobalVar.primaryLight3 :
                       procurement.statusText == GlobalVar.DITOLAK || procurement.statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                       procurement.statusText == GlobalVar.LENGKAP || procurement.statusText == GlobalVar.DITERIMA ? GlobalVar.greenBackground :
                       procurement.statusText == GlobalVar.DIKIRIM || procurement.statusText == GlobalVar.DISETUJUI ? GlobalVar.blueBackground :
                       Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(7))
            ),
            child: Text(
                procurement.statusText == null ? '-' : procurement.statusText!,
                style: GlobalVar.subTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: GlobalVar.medium,
                    color: procurement.statusText == null ? Colors.transparent :
                           procurement.statusText == GlobalVar.PENGAJUAN || procurement.statusText == GlobalVar.SEBAGIAN || procurement.statusText == GlobalVar.NEED_APPROVAL || procurement.statusText == GlobalVar.SUBMITTED ? GlobalVar.primaryOrange :
                           procurement.statusText == GlobalVar.DIPROSES ? GlobalVar.yellow :
                           procurement.statusText == GlobalVar.DITOLAK || procurement.statusText == GlobalVar.ABORT ? GlobalVar.red :
                           procurement.statusText == GlobalVar.LENGKAP || procurement.statusText == GlobalVar.DITERIMA ? GlobalVar.green :
                           procurement.statusText == GlobalVar.DIKIRIM || procurement.statusText == GlobalVar.DISETUJUI ? GlobalVar.blue :
                           GlobalVar.black
                )
            ),
        );
    }

    void sendConfirmation() {
        for (var data in efProductReceivedList.keys) {
            print('ef data -> ${data.getInputNumber()} => key : ${data.getController().tag}}');
        }
    }
}

class GrConfirmationBinding extends Bindings {
    BuildContext context;
    GrConfirmationBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<GrConfirmationController>(() => GrConfirmationController(context: context));
    }
}