import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/purchase_response.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../widget/internal_controller_creator.dart';
import '../../../widget/sku_card_purchase/sku_card_purchase.dart';
import '../../../widget/sku_card_purchase/sku_card_purchase_controller.dart';
import '../../../widget/sku_card_purchase_internal/sku_card_purchase_internal.dart';
import '../../../widget/sku_card_purchase_internal/sku_card_purchase_internal_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 29/05/23

class CreateGrPurchaseController extends GetxController {
  BuildContext context;
  CreateGrPurchaseController({required this.context});

  Rxn<Purchase> purchaseDetail = Rxn<Purchase>();
  ScrollController scrollController = ScrollController();
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  var isLoading = false.obs;
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  var isInternal = false.obs;
  var isOutStandingQuantity = false.obs;
  late SkuCardPurchase skuCard;

  late SkuCardPurchaseInternal skuCardInternal;

  late ButtonOutline cancelButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController('cancelPurchase'),
    label: 'Batal',
    onClick: () => null,
  );
  EditField efRemark = EditField(
      controller: GetXCreator.putEditFieldController('efRemarkGR POVENDFOR'),
      label: 'Catatan Penerimaan',
      hint: 'Ketik disini',
      alertText: '',
      textUnit: '',
      maxInput: 500,
      inputType: TextInputType.multiline,
      height: 160,
      onTyping: (value, editField) {});
  EditField efTotalKG = EditField(
      controller: GetXCreator.putEditFieldController('efTotalKGPOGRVENDOR'),
      label: 'Total/Global(Kg)*',
      hint: 'Ketik di sini',
      alertText: 'Total Kg harus diisi',
      textUnit: 'Kg',
      maxInput: 20,
      inputType: TextInputType.number,
      onTyping: (value, editField) {});

  late ButtonFill bfYesGrPurchase;
  late ButtonOutline boNoGrPurchase;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  @override
  void onInit() {
    super.onInit();
    purchaseDetail.value = Get.arguments as Purchase;
    isLoading.value = true;
    skuCard = SkuCardPurchase(
      controller: InternalControllerCreator.putSkuCardPurchaseController('skuGrPurchase', context),
    );
    skuCardInternal = SkuCardPurchaseInternal(controller: InternalControllerCreator.putSkuCardPurchaseInternalController('skuInternalPuchar', context));

    boNoGrPurchase = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('noGrPurchase'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      },
    );
    skuCard.controller.invisibleCard();
    skuCardInternal.controller.invisibleCard();
  }

  @override
  void onReady() {
    timeStart = DateTime.now();
    if (purchaseDetail.value!.vendor!.type == AppStrings.INTERNAL) {
      getCategorySkuInternal();
      skuCardInternal.controller.visibleCard();
      isInternal.value = true;
    } else {
      getCategorySku();
      skuCard.controller.visibleCard();
      isInternal.value = false;
    }
    super.onReady();
    Get.find<SkuCardPurchaseController>(tag: 'skuGrPurchase').itemCount.listen((p0) {
      generateListProduct(p0);
    });
    Get.find<SkuCardPurchaseInternalController>(tag: 'skuInternalPuchar').idx.listen((p0) {
      generateListProductInternal(p0);
    });
    bfYesGrPurchase = ButtonFill(
      controller: GetXCreator.putButtonFillController('yesGrPurchase'),
      label: 'Ya',
      onClick: () {
        Constant.track('Click_Konfirmasi_Penerimaan_Pembelian');
        saveGrPurchase();
      },
    );
    getTotalQuantity();
  }

  void generateListProduct(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx = idx - 1;
      skuCard.controller.spinnerCategories.value[idx].controller.generateItems(mapList.value);
    });
  }

  void generateListProductInternal(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx -= 1;
      skuCardInternal.controller.spinnerCategories.value[idx].controller.generateItems(mapList.value);
    });
  }

  void getDetailPurchase() {
    Service.push(
        service: ListApi.detailPurchaseById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathDetailPurchaseById(purchaseDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              purchaseDetail.value = (body as PurchaseResponse).data;
            },
            onResponseFail: (code, message, body, id, packet) {},
            onResponseError: (exception, stacktrace, id, packet) {},
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getTotalQuantity() {
    sumNeededMin.value = 0;
    sumNeededMax.value = 0;
    sumChick.value = 0;
    sumPriceMax.value = 0;
    sumPriceMin.value = 0;
    for (var product in purchaseDetail.value!.products!) {
      if (product!.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS) {
        sumNeededMin.value += product.quantity! * product.minValue!;
        sumNeededMax.value += product.quantity! * product.maxValue!;
        sumChick.value += product.quantity!;
        sumPriceMin.value += product.price! * (product.minValue! * product.quantity!);
        sumPriceMax.value += product.price! * (product.maxValue! * product.quantity!);
      } else {
        sumNeededMin.value += product.weight!;
        sumNeededMax.value += product.weight!;
        sumPriceMin.value += product.weight! * product.price!;
        sumPriceMax.value += product.weight! * product.price!;
      }
    }
  }

  void showAlertDialog() {
    Get.dialog(Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'images/failed_checkin.svg',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  'Perhatian !',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.bold, decoration: TextDecoration.none),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              skuCard.controller.sumChick.value > sumChick.value
                  ? 'Jumlah Ekor Melebihi Permintaan Pembelian, Apakah Kamu Yakin Ingin Melanjutkan Penerimaan?'
                  : 'Jumlah Ekor Kurang dari Permintaan Pembelian, Apakah Kamu Yakin Ingin Melanjutkan Penerimaan?',
              style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 32,
                  width: 100,
                  color: Colors.transparent,
                ),
                SizedBox(
                  width: 100,
                  child: ButtonFill(controller: GetXCreator.putButtonFillController('Dialog'), label: 'OK', onClick: () => {Get.back(), saveGrPurchase()}),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  bool isValid() {
    final List<dynamic> ret = validation();
    if (ret[0]) {
      isOutStandingQuantity.value = false;
      return true;
    } else {
      return false;
    }
  }

  void saveGrPurchase() {
    isLoading.value = true;
    final Purchase purchasePayload = generatePayload();
    Service.push(
      service: ListApi.createGoodReceived,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, Mapper.asJsonString(purchasePayload)],
      listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.back();
        Get.back();
      }, onResponseFail: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.snackbar('Alert', (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      }, onResponseError: (exception, stacktrace, id, packet) {
        isLoading.value = false;
        Get.snackbar('Alert', 'Terjadi kesalahan internal', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      }, onTokenInvalid: () {
        Constant.invalidResponse();
      }),
    );
    Get.back();
    Get.back();
  }

  List<dynamic> validation() {
    List<dynamic> ret = [true, ''];
    if (purchaseDetail.value!.vendor!.type == AppStrings.INTERNAL) {
      ret = skuCardInternal.controller.validation();
    } else {
      ret = skuCard.controller.validation();
    }
    if (efTotalKG.getInput().isEmpty) {
      efTotalKG.controller.showAlert();
      Scrollable.ensureVisible(efTotalKG.controller.formKey.currentContext!);

      ret = [false, ''];
    }
    return ret;
  }

  Purchase generatePayload() {
    final List<Products?> listProductPayload = [];
    if (purchaseDetail.value!.vendor!.type == AppStrings.INTERNAL) {
      for (int i = 0; i < skuCardInternal.controller.itemCount.value; i++) {
        final int whichItem = skuCardInternal.controller.index.value[i];
        final listProductTemp = skuCardInternal.controller.listSku.value.values.toList();
        final Products? productSelected = listProductTemp[whichItem].firstWhereOrNull((element) => element!.name! == skuCardInternal.controller.spinnerSku.value[whichItem].controller.textSelected.value);
        listProductPayload.add(Products(
          productItemId: productSelected!.id,
          quantity: skuCardInternal.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCardInternal.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
          price: skuCardInternal.controller.editFieldHarga.value[whichItem].getInputNumber() ?? 0,
          weight: skuCardInternal.controller.editFieldKebutuhan.value[whichItem].getInputNumber() ?? 0,
        ));
      }
    } else {
      for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
        final int whichItem = skuCard.controller.index.value[i];
        final listProductTemp = skuCard.controller.listSku.value.values.toList();
        final Products? productSelected = listProductTemp[whichItem].firstWhereOrNull((element) => element!.name! == skuCard.controller.spinnerSku.value[whichItem].controller.textSelected.value);
        listProductPayload.add(Products(
          productItemId: productSelected!.id,
          quantity: skuCard.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCard.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
          price: skuCard.controller.editFieldHarga.value[whichItem].getInputNumber() ?? 0,
          weight: skuCard.controller.editFieldKebutuhan.value[whichItem].getInputNumber() ?? 0,
        ));
      }
    }
    return Purchase(
      products: listProductPayload,
      purchaseOrderId: purchaseDetail.value!.id,
      remarks: Uri.encodeFull(efRemark.getInput()),
      totalWeight: efTotalKG.getInputNumber(),
    );
  }

  void getCategorySku() {
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as CategoryListResponse).data) {
              listCategories.value.add(result);
            }
            final Map<String, bool> mapListValue = {};
            for (var product in body.data) {
              mapListValue[product!.name!] = false;
            }
            //Generate Card SKU
            Timer(const Duration(milliseconds: 100), () {
              skuCard.controller.spinnerCategories.value[0].controller.generateItems(mapListValue);

              skuCard.controller.setMaplist(listCategories.value);
              mapList.value = mapListValue;
            });

            isLoading.value = false;

            timeEnd = DateTime.now();
            final Duration totalTime = timeEnd.difference(timeStart);
            Constant.trackRenderTime('Buat_Penerimaan_Pembelian', totalTime);
          },
          onResponseFail: (code, message, body, id, packet) {
            Get.snackbar(
              'Pesan',
              'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            isLoading.value = false;
          },
          onResponseError: (exception, stacktrace, id, packet) {},
          onTokenInvalid: Constant.invalidResponse()),
    );
  }

  void getCategorySkuInternal() {
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            listCategories.value.clear();
            for (var result in (body as CategoryListResponse).data) {
              listCategories.value.add(result);
            }
            final Map<String, bool> mapList = {};
            for (var product in body.data) {
              mapList[product!.name!] = false;
            }
            skuCardInternal.controller.spinnerCategories.value[0].controller.generateItems(mapList);

            skuCardInternal.controller.setMaplist(listCategories.value);

            skuCardInternal.controller.visibleCard();
            skuCardInternal.controller.idx.refresh();
            this.mapList.value = mapList;
            isLoading.value = false;
            timeEnd = DateTime.now();
            final Duration totalTime = timeEnd.difference(timeStart);
            Constant.trackRenderTime('Buat_Penerimaan_Pembelian', totalTime);
          },
          onResponseFail: (code, message, body, id, packet) {
            Get.snackbar(
              'Pesan',
              'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            isLoading.value = false;
          },
          onResponseError: (exception, stacktrace, id, packet) {},
          onTokenInvalid: Constant.invalidResponse()),
    );
  }
}

class CreateGrPurchaseBindings extends Bindings {
  BuildContext context;
  CreateGrPurchaseBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => CreateGrPurchaseController(context: context));
  }
}
