import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/goods_received_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/response/internal_app/good_receive_response.dart';
import 'package:model/response/internal_app/purchase_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 29/05/23

class DetailGrPurchaseController extends GetxController {
  BuildContext context;
  DetailGrPurchaseController({required this.context});

  Rxn<Purchase> purchaseDetail = Rxn<Purchase>();
  Rxn<GoodsReceived> goodReceiptDetail = Rxn<GoodsReceived>();
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  late ButtonFill bfMakePurchase = ButtonFill(
    controller: GetXCreator.putButtonFillController("makePurchase"),
    label: "Buat Penerimaan",
      onClick: () =>
          Get.toNamed(purchaseDetail.value!.vendor!= null ? RoutePage.createGrPurchasePage : RoutePage.createGrJagalPurchasePage , arguments: purchaseDetail.value)!.then((value) {
            isLoading.value =true;
            Timer(const Duration(milliseconds: 500), () {
              getDetailConfirmed();
        });
      })
  );
  late ButtonOutline cancelButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("cancelPurchase"),
    label: "Batal",
    onClick: () => null,
  );

  late ButtonFill bfYesCancel;
  late ButtonOutline boNoCancel;

  @override
  void onInit() {
    super.onInit();
    purchaseDetail.value = Get.arguments as Purchase;
    purchaseDetail.value!.status == "CONFIRMED" ? getDetailConfirmed() : getDetailReceived();
    // purchaseDetail.value!.status == "CONFIRMED" ?  bfMakePurchase.controller.disable() : bfMakePurchase.controller.enable();

    boNoCancel = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noCancelGrPurchase"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );

  }


  @override
  void onReady() {
    super.onReady();
    bfYesCancel = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesCancelGrPurchase"),
      label: "Ya",
      onClick: () {
        cancelGRPurchase(context);
      },
    );
  }

  void getDetailConfirmed(){
    isLoading.value = true;
    Service.push(
        service: ListApi.detailPurchaseById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathDetailPurchaseById(purchaseDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet){
              purchaseDetail.value = (body as PurchaseResponse).data;

              if(purchaseDetail.value!.status == "RECEIVED") {
                getDetailReceived();
              } else {
                getTotalQuantity();
                isLoading.value = false;
                
              }
            },
            onResponseFail: (code, message, body, id, packet){

            },
            onResponseError: (exception, stacktrace, id, packet) {

            },  onTokenInvalid: Constant.invalidResponse())
    );
  }


  void getDetailReceived(){ 
    isLoading.value = true;
    Service.push(
      service: ListApi.detailReceivedById,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathDetailGrByPurchaseById(purchaseDetail.value!.goodsReceived!.id!)],
      listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet){
              goodReceiptDetail.value = (body as GoodReceiveReponse).data;
            //   print(Mapper.asJsonString(goodReceiptDetail.value));
              getTotalQuantity();
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet){
              isLoading.value = false;
                 Get.snackbar("Alert","Terjadi kesalahan ${message.toString()}",
                  snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = false;
                Get.snackbar("Alert","Terjadi kesalahan internal",
                  snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            }, onTokenInvalid: (){
              Constant.invalidResponse();
        })
    );
  }

  void getTotalQuantity(){

    sumNeededMin.value = 0;
    sumNeededMax.value =0;
    sumChick.value =0;
    sumPriceMax.value =0;
    sumPriceMin.value =0;
    if(purchaseDetail.value!.status == "RECEIVED" || purchaseDetail.value!.status == "CONFIRMED" ) {
        for(var product in goodReceiptDetail.value!.products!) {
            if (product!.productItem!.name! == AppStrings.HATI_AMPELA ||product.productItem!.name! == AppStrings.CEKER ||product.productItem!.name!.contains(AppStrings.KARKAS) || product.productItem!.name! == AppStrings.KEPALA){
                    sumNeededMin.value += product.weight!;
                    sumNeededMax.value += product.weight!;
                    sumPriceMin.value += product.weight! * product.price!;
                    sumPriceMax.value +=  product.weight! * product.price!;
                }
            else {
                sumNeededMin.value += product.quantity! * product.productItem!.minValue!;
                sumNeededMax.value += product.quantity! * product.productItem!.maxValue!;
                sumChick.value += product.quantity!;
                sumPriceMin.value += product.price! * (product.productItem!.minValue! * product.quantity!);
                sumPriceMax.value += product.price! * (product.productItem!.maxValue! * product.quantity!);
            } 
        }    
    }
    else if(purchaseDetail.value!.goodsReceived != null && purchaseDetail.value!.goodsReceived!.status == "CONFIRMED") {
        for(var product in purchaseDetail.value!.goodsReceived!.products!) {
            if (product!.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
                sumNeededMin.value += product.quantity! * product.productItem!.minValue!;
                sumNeededMax.value += product.quantity! * product.productItem!.maxValue!;
                sumChick.value += product.quantity!;
                sumPriceMin.value += product.price! * (product.productItem!.minValue! * product.quantity!);
                sumPriceMax.value += product.price! * (product.productItem!.maxValue! * product.quantity!);
                } else {
                    sumNeededMin.value += product.weight!;
                    sumNeededMax.value += product.weight!;
                    sumPriceMin.value += product.weight! * product.price!;
                    sumPriceMax.value +=  product.weight! * product.price!;
            }
        }    
    }
    else {
     for(var product in purchaseDetail.value!.products!) {
        if (product!.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
            sumNeededMin.value += product.quantity! * product.minValue!;
            sumNeededMax.value += product.quantity! * product.maxValue!;
            sumChick.value += product.quantity!;
            sumPriceMin.value += product.price! * (product.minValue! * product.quantity!);
            sumPriceMax.value += product.price! * (product.maxValue! * product.quantity!);
            } else {
                sumNeededMin.value += product.weight!;
                sumNeededMax.value += product.weight!;
                sumPriceMin.value += product.weight! * product.price!;
                sumPriceMax.value +=  product.weight! * product.price!;
        }
    }       
    }
  }

  void cancelGRPurchase(BuildContext context) {
    String purchaseid = goodReceiptDetail.value!.id!;
    isLoading.value = true;
      Service.push(
          service: ListApi.cancelGr,
          context: context,
          body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathCancelGr(purchaseid),""],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Get.back();
                isLoading.value = false;
              },
              onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                  "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                  snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              },
                onResponseError: (exception, stacktrace, id, packet) {            
                Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
                );
                //  isLoading.value = false;
                },
              onTokenInvalid: Constant.invalidResponse()
          )
      );
    Get.back();
  }

}

class DetailGrPurchaseBindings extends Bindings {
  BuildContext context;
  DetailGrPurchaseBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailGrPurchaseController(context: context));
  }


}