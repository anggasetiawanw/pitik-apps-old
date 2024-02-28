import 'dart:convert';

import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/check_box/check_box_field.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/media_field/media_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/good_receipt_model.dart';
import 'package:model/internal_app/media_upload_model.dart';
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
  late bool isFromTransfer;
  late bool fromCoopRest;

  late DateTimeField grReceivedDateField;
  late EditAreaField grNotesField;
  late MediaField grPhotoField;

  var isLoading = false.obs;
  var isLoadingPicture = false.obs;

  RxMap<EditField, Product> efProductReceivedMap = <EditField, Product>{}.obs;
  RxList<MediaUploadModel?> grPhotoList = <MediaUploadModel?>[].obs;
  Rx<Column> outstandingGrInputWidget = const Column().obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    procurement = Get.arguments[1];
    isFromTransfer = Get.arguments[2];
    fromCoopRest = Get.arguments[3];

    GlobalVar.track(isFromTransfer ? 'Open_detail_terima_transfer_page' : 'Open_detail_terima_order_page');

    grReceivedDateField = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController('grReceivedDateField$isFromTransfer'),
        label: 'Tanggal Penerimaan',
        hint: '2022-12-31',
        alertText: 'Tanggal Penerimaan harus diisi..!',
        flag: DateTimeField.DATE_FLAG,
        onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}'));

    grNotesField =
        EditAreaField(controller: GetXCreator.putEditAreaFieldController('grNotesField$isFromTransfer'), label: 'Keterangan', hint: 'Tulis Keterangan disini...', alertText: 'Keterangan belum diisi..!', maxInput: 250, onTyping: (text, field) {});

    grPhotoField = MediaField(
        controller: GetXCreator.putMediaFieldController('grConfirmationPhotoField'),
        label: 'Upload bukti foto',
        hideLabel: true,
        hint: 'Upload bukti foto',
        alertText: 'Harus diisi..!',
        type: MediaField.PHOTO,
        onMediaResult: (file) => AuthImpl().get().then((auth) {
              if (auth != null) {
                if (file != null) {
                  isLoadingPicture.value = true;
                  Service.push(
                      service: ListApi.uploadImage,
                      context: Get.context!,
                      body: ['Bearer ${auth.token}', auth.id, 'goods-receipt-purchase-order', file],
                      listener: ResponseListener(
                          onResponseDone: (code, message, body, id, packet) {
                            grPhotoList.add(body.data);
                            grPhotoField.getController().setInformasiText('File telah terupload');
                            grPhotoField.getController().showInformation();
                            isLoadingPicture.value = false;
                          },
                          onResponseFail: (code, message, body, id, packet) {
                            Get.snackbar('Pesan', 'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);

                            isLoadingPicture.value = false;
                          },
                          onResponseError: (exception, stacktrace, id, packet) {
                            Get.snackbar('Pesan', 'Terjadi kesalahan internal', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);

                            isLoadingPicture.value = false;
                          },
                          onTokenInvalid: () => GlobalVar.invalidResponse()));
                }
              } else {
                GlobalVar.invalidResponse();
              }
            }));

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

                      // fill photo confirmation
                      // grPhotoList.value = body.data!.photos;
                      // if (grPhotoList.isNotEmpty) {
                      //     grPhotoField.getController().setInformasiText("File telah terupload");
                      //     grPhotoField.getController().showInformation();
                      //     grPhotoField.getController().setFileName(grPhotoList[0]!.id!);
                      // }
                    }

                    _createProductReceivedCards(productList: procurement.details);
                    isLoading.value = false;
                  },
                  onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar('Pesan', '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                    isLoading.value = false;
                  },
                  onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar('Pesan', exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                    isLoading.value = false;
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });

  bool _isProductNotAllReturned(GoodReceipt goodReceipt) {
    for (var product in goodReceipt.details) {
      if (product!.isReturned == null || !product.isReturned!) {
        return true;
      }
    }
    return false;
  }

  bool isGrNotAllReturned() {
    for (var goodReceipt in procurement.goodsReceipts) {
      for (var product in goodReceipt!.details) {
        if (product!.isReturned == null || !product.isReturned!) {
          return true;
        }
      }
    }

    return false;
  }

  bool isGrNotAllReturnedField() {
    for (var entry in efProductReceivedMap.entries) {
      if (entry.value.isReturned == null || !entry.value.isReturned!) {
        return true;
      }
    }

    return false;
  }

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

  bool isAlreadyReturnedField() {
    for (var entry in efProductReceivedMap.entries) {
      if (entry.value.isReturned != null && entry.value.isReturned!) {
        return true;
      }
    }

    return false;
  }

  Column createProductCards({required List<Product?> productList, bool isFeed = false}) {
    return Column(
      children: List.generate(productList.length, (index) {
        if (productList[index] != null) {
          final Product product = productList[index]!;
          return Container(
            width: MediaQuery.of(Get.context!).size.width,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merek', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                const SizedBox(height: 4),
                Text(isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? '', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
                const SizedBox(height: 12),
                Text('Total', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                const SizedBox(height: 4),
                Text('${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''}', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
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
    return Column(
      children: List.generate(goodReceipt.length, (index) {
        if (goodReceipt[index] != null) {
          final GoodReceipt gr = goodReceipt[index]!;
          final DateTime receivedDate = Convert.getDatetime(gr.receivedDate!);

          final List<Product?> returnedData = [];
          for (var product in gr.details) {
            if (product != null && product.isReturned != null && product.isReturned!) {
              returnedData.add(product);
            }
          }

          if (returnedData.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tanggal Retur', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                    Text('${Convert.getYear(receivedDate)}-${Convert.getMonthNumber(receivedDate)}-${Convert.getDay(receivedDate)}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(returnedData.length, (index) {
                    if (returnedData[index] != null) {
                      final Product product = returnedData[index]!;
                      return Column(
                        children: [
                          Container(
                              width: MediaQuery.of(Get.context!).size.width,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: const BoxDecoration(color: GlobalVar.redBackground, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                  '${isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? ''} - (${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''})',
                                  style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)))
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                )
              ],
            );
          } else {
            return const SizedBox();
          }
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
          final GoodReceipt goodReceipt = goodReceipts[index]!;
          final DateTime receivedDate = Convert.getDatetime(goodReceipt.receivedDate!);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isProductNotAllReturned(goodReceipt)
                  ? Column(
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
                      ],
                    )
                  : const SizedBox(),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(goodReceipt.details.length, (index) {
                    final Product product = goodReceipt.details[index]!;
                    if (product.isReturned == null || !product.isReturned!) {
                      return Container(
                          width: MediaQuery.of(Get.context!).size.width,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Text(
                              '${isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? ''} - (${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''})',
                              style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)));
                    } else {
                      return const SizedBox();
                    }
                  })),
              procurement.statusText == GlobalVar.LENGKAP || procurement.statusText == GlobalVar.DITERIMA
                  ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Keterangan', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)),
                      Text(goodReceipt.remarks ?? '-', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black))
                    ])
                  : const SizedBox(),
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
                        height: MediaQuery.of(context).size.width / 2,
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

  void showReturnedConfirmation({required Function(bool) onResult}) {
    showModalBottomSheet(
        useSafeArea: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) => Container(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                      const SizedBox(height: 16),
                      Text('Apakah yakin kamu ingin melakukan retur?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                      const SizedBox(height: 16),
                      Text('Pastikan barang sudah sesuai dan benar sebelum melakukan penolakan', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                      const SizedBox(height: 16),
                      Center(child: SvgPicture.asset('images/people_confirm_icon.svg')),
                      const SizedBox(height: 32),
                      SizedBox(
                          width: MediaQuery.of(Get.context!).size.width - 32,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Expanded(
                                child: ButtonFill(
                                    controller: GetXCreator.putButtonFillController('btnReturnedYes'),
                                    label: 'Yakin',
                                    onClick: () {
                                      Navigator.pop(Get.context!);
                                      onResult(true);
                                    })),
                            const SizedBox(width: 16),
                            Expanded(
                                child: ButtonOutline(
                                    controller: GetXCreator.putButtonOutlineController('btnCancelGrConfirmation'),
                                    label: 'Tidak Yakin',
                                    onClick: () {
                                      Navigator.pop(Get.context!);
                                      onResult(false);
                                    }))
                          ])),
                      const SizedBox(height: 32)
                    ])))));
  }

  void _createProductReceivedCards({required List<Product?> productList}) {
    efProductReceivedMap.clear();
    outstandingGrInputWidget.value = Column(
        children: List.generate(procurement.details.length, (index) {
      if (procurement.details[index] == null) {
        return const SizedBox();
      } else {
        final Product product = procurement.details[index]!;

        final EditField editField = EditField(
            controller: GetXCreator.putEditFieldController('efProductReceived${product.id}'),
            label: 'Total Diterima',
            hint: 'Ketik di sini',
            alertText: 'Harus diisi..!',
            inputType: TextInputType.number,
            textUnit: product.purchaseUom ?? product.uom ?? '',
            maxInput: 50,
            onTyping: (text, field) {
              product.quantity = field.getInputNumber();
              efProductReceivedMap.putIfAbsent(field, () => product);
            });

        final CheckBoxField checkBoxField = CheckBoxField(
            controller: GetXCreator.putCheckBoxFieldController('checkBoxReceived${product.id}'),
            title: 'Retur',
            onTap: (controller) {
              if (controller.isChecked.isFalse) {
                showReturnedConfirmation(onResult: (isAgree) {
                  product.isReturned = isAgree;
                  efProductReceivedMap.putIfAbsent(editField, () => product);
                  if (isAgree) {
                    editField.getController().invisibleField();
                    controller.checked();
                  } else {
                    editField.getController().visibleField();
                    controller.unchecked();
                  }
                });
              } else {
                product.isReturned = false;
                efProductReceivedMap.putIfAbsent(editField, () => product);
                editField.getController().visibleField();
              }
            });

        if (isFromTransfer) {
          editField.setInput(product.remaining!.toStringAsFixed(0));
          editField.getController().disable();
        }

        // checking is can returned
        bool isCanReturned = true;
        stop:
        for (var goodReceipts in procurement.goodsReceipts) {
          for (var p in goodReceipts!.details) {
            if (p!.productCode == product.productCode && (p.quantity != null && p.quantity! > 0.0)) {
              isCanReturned = false;
              break stop;
            }
          }
        }

        efProductReceivedMap[editField] = product;
        return Container(
            width: MediaQuery.of(Get.context!).size.width,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(color: Colors.white, border: Border.fromBorderSide(BorderSide(color: GlobalVar.outlineColor, width: 2)), borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              isCanReturned ? checkBoxField : const SizedBox(),
              const SizedBox(height: 16),
              Text(
                  '${procurement.type == 'pakan' ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? ''} - (${product.remaining == null ? '' : product.remaining!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''})',
                  style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)),
              editField
            ]));
      }
    }));
  }

  Container getStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: procurement.statusText == null
              ? Colors.transparent
              : procurement.statusText == GlobalVar.PENGAJUAN || procurement.statusText == GlobalVar.SEBAGIAN || procurement.statusText == GlobalVar.NEED_APPROVAL || procurement.statusText == GlobalVar.SUBMITTED
                  ? GlobalVar.primaryLight2
                  : procurement.statusText == GlobalVar.DIPROSES
                      ? GlobalVar.primaryLight3
                      : procurement.statusText == GlobalVar.DITOLAK || procurement.statusText == GlobalVar.ABORT
                          ? GlobalVar.redBackground
                          : procurement.statusText == GlobalVar.LENGKAP || procurement.statusText == GlobalVar.DITERIMA
                              ? GlobalVar.greenBackground
                              : procurement.statusText == GlobalVar.DIKIRIM || procurement.statusText == GlobalVar.DISETUJUI
                                  ? GlobalVar.blueBackground
                                  : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(7))),
      child: Text(procurement.statusText == null ? '-' : procurement.statusText!,
          style: GlobalVar.subTextStyle.copyWith(
              fontSize: 12,
              fontWeight: GlobalVar.medium,
              color: procurement.statusText == null
                  ? Colors.transparent
                  : procurement.statusText == GlobalVar.PENGAJUAN || procurement.statusText == GlobalVar.SEBAGIAN || procurement.statusText == GlobalVar.NEED_APPROVAL || procurement.statusText == GlobalVar.SUBMITTED
                      ? GlobalVar.primaryOrange
                      : procurement.statusText == GlobalVar.DIPROSES
                          ? GlobalVar.yellow
                          : procurement.statusText == GlobalVar.DITOLAK || procurement.statusText == GlobalVar.ABORT
                              ? GlobalVar.red
                              : procurement.statusText == GlobalVar.LENGKAP || procurement.statusText == GlobalVar.DITERIMA
                                  ? GlobalVar.green
                                  : procurement.statusText == GlobalVar.DIKIRIM || procurement.statusText == GlobalVar.DISETUJUI
                                      ? GlobalVar.blue
                                      : GlobalVar.black)),
    );
  }

  bool _validation() {
    bool isPass = true;

    if (grReceivedDateField.getController().textSelected.isEmpty) {
      grReceivedDateField.getController().showAlert();
      isPass = false;
    }
    if (grNotesField.getInput().isEmpty) {
      grNotesField.getController().showAlert();
      isPass = false;
    }
    if (grPhotoList.isEmpty) {
      grPhotoField.getController().showAlert();
      isPass = false;
    }

    efProductReceivedMap.forEach((key, value) {
      if (value.isReturned == null || !value.isReturned!) {
        if (key.controller.showField.isTrue && key.getInput().isEmpty) {
          key.getController().alertText.value = 'Harus diisi..!';
          key.getController().showAlert();
          isPass = false;
        } else if (key.getInputNumber()!.toInt() > value.remaining!) {
          key.getController().alertText.value = 'Jumlah penerimaan lebih dari permintaan';
          key.getController().showAlert();
          isPass = false;
        }
      }
    });

    return isPass;
  }

  void sendConfirmation() {
    if (_validation()) {
      showModalBottomSheet(
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
          isScrollControlled: true,
          context: Get.context!,
          builder: (context) => Container(
              color: Colors.transparent,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                        const SizedBox(height: 16),
                        Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                        const SizedBox(height: 16),
                        Text('Detail ${procurement.type == 'pakan' ? 'Pakan' : 'OVK'}', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Kode Pesanan', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(procurement.erpCode ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ],
                        ),
                        if (!isFromTransfer) ...[
                          const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('Kode Pembelian', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(procurement.purchaseRequestErpCode ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ])
                        ],
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Tanggal Pengiriman', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                          Text(procurement.deliveryDate ?? '-', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                        ]),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tanggal Penerimaan', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                            Text(grReceivedDateField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 2, color: GlobalVar.gray),
                        const SizedBox(height: 16),
                        if (isAlreadyReturnedField()) ...[
                          Text('${procurement.type == 'pakan' ? 'Pakan' : 'OVK'} Diretur', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 4),
                          Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: efProductReceivedMap.entries.map((entry) {
                                    if (entry.value.isReturned != null && entry.value.isReturned!) {
                                      final String quantity = efProductReceivedMap[entry.key]!.remaining == null ? '-' : efProductReceivedMap[entry.key]!.remaining!.toStringAsFixed(0);
                                      return Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Expanded(child: Text(getProductName(product: efProductReceivedMap[entry.key], isFeed: procurement.type == 'pakan'), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                                            Text('${Convert.toCurrencyWithoutDecimal(quantity, '', '.')} ${entry.key.getController().textUnit}', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                          ]));
                                    } else {
                                      return const SizedBox();
                                    }
                                  }).toList()))
                        ] else ...[
                          const SizedBox()
                        ],
                        if (isGrNotAllReturnedField()) ...[
                          const SizedBox(height: 8),
                          Text('${procurement.type == 'pakan' ? 'Pakan' : 'OVK'} Diterima', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                                children: efProductReceivedMap.entries.map((entry) {
                              if (entry.value.isReturned == null || !entry.value.isReturned!) {
                                return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Expanded(child: Text(getProductName(product: efProductReceivedMap[entry.key], isFeed: procurement.type == 'pakan'), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                                      Text('${Convert.toCurrencyWithoutDecimal(entry.key.getInput(), '', '.')} ${entry.key.getController().textUnit}', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                    ]));
                              } else {
                                return const SizedBox();
                              }
                            }).toList()),
                          )
                        ] else ...[
                          const SizedBox()
                        ],
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(Get.context!).size.width - 32,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Keterangan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                            const SizedBox(width: 16),
                            Expanded(child: Text(grNotesField.getInput(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium), textAlign: TextAlign.right))
                          ]),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: MediaQuery.of(Get.context!).size.width - 32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: ButtonFill(
                                      controller: GetXCreator.putButtonFillController('btnSubmitGrConfirmation'),
                                      label: 'Yakin',
                                      onClick: () {
                                        Navigator.pop(Get.context!);
                                        GlobalVar.track(isFromTransfer ? 'Click_konfirmasi_button_terima_transfer' : 'Click_konfirmasi_button_penerimaan');
                                        isLoading.value = true;

                                        AuthImpl().get().then((auth) {
                                          if (auth != null) {
                                            final String? productListJson = Mapper.asJsonString(efProductReceivedMap.entries.map((entry) => entry.value).toList());
                                            final String? photoListJson = Mapper.asJsonString(grPhotoList);

                                            final Map<String, dynamic> bodyRequest = {
                                              'purchaseOrderId': procurement.id,
                                              'transferRequestId': procurement.id,
                                              'receivedDate': grReceivedDateField.getLastTimeSelectedText(),
                                              'remarks': grNotesField.getInput(),
                                              'details': json.decode(productListJson ?? '[]'),
                                              'photos': json.decode(photoListJson ?? '[]')
                                            };

                                            Service.push(
                                                apiKey: 'productReportApi',
                                                service: isFromTransfer ? ListApi.createReceiptTransfer : ListApi.createReceiptOrder,
                                                context: Get.context!,
                                                body: ['Bearer ${auth.token}', auth.id, json.encode(bodyRequest)],
                                                listener: ResponseListener(
                                                    onResponseDone: (code, message, body, id, packet) {
                                                      isLoading.value = false;
                                                      GlobalVar.track(isFromTransfer ? 'Open_success_terima_transfer_page' : 'Open_success_penerimaan_page');
                                                      Get.off(TransactionSuccessActivity(
                                                          keyPage: 'grConfirmationSaved', message: 'Kamu telah berhasil melakukan penerimaan sapronak', showButtonHome: false, onTapClose: () => Get.back(result: true), onTapHome: () {}));
                                                    },
                                                    onResponseFail: (code, message, body, id, packet) {
                                                      isLoading.value = false;
                                                      Get.snackbar(
                                                        'Pesan',
                                                        'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                                                        snackPosition: SnackPosition.TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors.red,
                                                      );
                                                    },
                                                    onResponseError: (exception, stacktrace, id, packet) {
                                                      isLoading.value = false;
                                                      Get.snackbar(
                                                        'Pesan',
                                                        'Terjadi Kesalahan, $exception',
                                                        snackPosition: SnackPosition.TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors.red,
                                                      );
                                                    },
                                                    onTokenInvalid: () => GlobalVar.invalidResponse()));
                                          } else {
                                            GlobalVar.invalidResponse();
                                          }
                                        });
                                      })),
                              const SizedBox(width: 16),
                              Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController('btnCancelGrConfirmation'), label: 'Tidak Yakin', onClick: () => Navigator.pop(Get.context!)))
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ])))));
    }
  }

  String getProductName({Product? product, bool isFeed = true}) {
    if (product != null) {
      return isFeed ? '${product.subcategoryName ?? ''} - ${product.productName ?? ''}' : product.productName ?? '';
    } else {
      return '-';
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
