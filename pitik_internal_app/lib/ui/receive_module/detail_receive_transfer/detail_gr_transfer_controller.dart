import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/goods_received_model.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/response/internal_app/good_receive_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/06/23

class DetailGRTransferController extends GetxController {
    BuildContext context;

    DetailGRTransferController({required this.context});
    late ButtonFill yesCancelButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesButton"), label: "Ya", onClick: (){

        Get.back();
        cancelGRTransfer(context);
    });
    ButtonOutline noCancelButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("No Button"), label: "Tidak", onClick: (){
        Get.back();
    });

    SpinnerField assignDriver = SpinnerField(controller: GetXCreator.putSpinnerFieldController("assignDriver"), label: "Driver*", hint: "Pilih salah satu", alertText: "Driver harus dipilih!", items: const {}, onSpinnerSelected: (value){});

    var isLoading = false.obs;
    late TransferModel transferModel;
    late DateTime createdDate;

    Rxn<GoodsReceived> goodReceiptDetail = Rxn<GoodsReceived>();

    @override
    void onInit() {
        super.onInit();
        transferModel = Get.arguments;
        transferModel.status == "DELIVERED" ? getDetailTransfer() : getDetailReceived();
        createdDate = Convert.getDatetime(transferModel.createdDate!);
    }

    void getDetailTransfer(){
        Service.push(
            service: ListApi.getDetailTransfer,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, ListApi.pathGetTransferDetailById(transferModel.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    transferModel = body.data;
                    if(transferModel.status == "RECEIVED"){
                        getDetailReceived();
                    }
                    else {
                        isLoading.value = false;
                    }
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = true;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = true;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        duration: const Duration(seconds: 5),
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }

    void getDetailReceived(){
    isLoading.value = true;
    Service.push(
      service: ListApi.detailReceivedById,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathDetailGrByPurchaseById(transferModel.goodsReceived!.id!)],
      listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet){
              goodReceiptDetail.value = (body as GoodReceiveReponse).data;
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

    void cancelGRTransfer(BuildContext context) {
        String grTransferId = transferModel.goodsReceived!.id!;
        isLoading.value = true;
        Service.push(
            service: ListApi.cancelGr,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathCancelGr(grTransferId),""],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.back();
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
    }
}
class DetailGRTransferBindings extends Bindings {
    BuildContext context;
    DetailGRTransferBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DetailGRTransferController(context: context));
    }
}