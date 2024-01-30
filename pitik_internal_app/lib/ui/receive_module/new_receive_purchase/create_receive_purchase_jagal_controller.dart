import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/response/internal_app/purchase_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card_gr/sku_card_gr.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 29/05/23

class CreateGrPurchaseJagalController extends GetxController {
  BuildContext context;
  CreateGrPurchaseJagalController({required this.context});

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
  var isOutStandingQuantity = false.obs;
  late SkuCardGr skuCard;

  late ButtonOutline cancelButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("cancelPurchase"),
    label: "Batal",
    onClick: () => null,
  );

  EditField efRemark = EditField(controller: GetXCreator.putEditFieldController("efRemarkGR PO"), label: "Catatan Penerimaan", hint: "Ketik disini", alertText: "", textUnit: "", maxInput: 500, inputType: TextInputType.multiline, height: 160, onTyping: (value, editField) {});
  EditField efTotalKG = EditField(controller: GetXCreator.putEditFieldController("efTotalKGPOGR"), label: "Total/Global(Kg)*", hint: "Ketik di sini", alertText: "Total Kg harus diisi", textUnit: "Kg", maxInput: 20, inputType: TextInputType.number, onTyping: (value, editField) {});

  late ButtonFill bfYesGrPurchase;
  late ButtonOutline boNoGrPurchase;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    purchaseDetail.value = Get.arguments as Purchase;

    skuCard = SkuCardGr(
      controller: InternalControllerCreator.putSkuCardGrOrder("skuGrJagalPurchase", purchaseDetail.value!.products!),
    );
    boNoGrPurchase = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noJagalGrPurchase"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    getTotalQuantity();
    bfYesGrPurchase = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesJagalGrPurchase"),
      label: "Ya",
      onClick: () {
        GlobalVar.track("Click_Konfirmasi_Penerimaan_Pembelian");
        Get.back();
        saveGrPurchase();
      },
    );
    timeEnd = DateTime.now();
    Duration totalTime = timeEnd.difference(timeStart);
    GlobalVar.trackRenderTime("Buat_Penerimaan_Pembelian", totalTime);
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

  bool isValid() {
    if (efTotalKG.getInput().isEmpty) {
      efTotalKG.controller.showAlert();
      Scrollable.ensureVisible(efTotalKG.controller.formKey.currentContext!);

      return false;
    }
    return true;
  }

  void saveGrPurchase() {
    isLoading.value = true;
    Purchase purchasePayload = generatePayload();
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
        Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      }, onResponseError: (exception, stacktrace, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      }, onTokenInvalid: () {
        Constant.invalidResponse();
      }),
    );
  }

  Purchase generatePayload() {
    List<Products?> listProductPayload = [];
    for (int i = 0; i < purchaseDetail.value!.products!.length; i++) {
      listProductPayload.add(Products(
        productItemId: purchaseDetail.value!.products![i]!.id!,
        quantity: purchaseDetail.value!.products![i]!.quantity!,
        weight: purchaseDetail.value!.products![i]!.weight!,
        price: purchaseDetail.value!.products![i]!.price,
      ));
    }

    return Purchase(products: listProductPayload, purchaseOrderId: purchaseDetail.value!.id!, remarks: Uri.encodeFull(efRemark.getInput()), totalWeight: efTotalKG.getInputNumber());
  }
}

class CreateGrJagalPurchaseBindings extends Bindings {
  BuildContext context;
  CreateGrJagalPurchaseBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => CreateGrPurchaseJagalController(context: context));
  }
}
