 import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
class DeliveryDetailTransferController extends GetxController {
    BuildContext context;

  var isSendItem = false.obs;
    DeliveryDetailTransferController({required this.context});
    late ButtonFill doneSendButton = ButtonFill(controller: GetXCreator.putButtonFillController("doneSendButton"), label: "Terkirim", onClick: (){
        Get.toNamed(RoutePage.deliveryConfirmTransfer, arguments: transferModel)!.then((value) {
            isLoading.value = true;
            Timer(const Duration(milliseconds: 500), () {
                getDetailTransfer();
            });
        });
    });

    late ButtonFill yesSendButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesSendButton"), label: "Ya", onClick: (){
        isLoading.value = true;
        Get.back();
        updateStatus(ListApi.pathTransferPickUp(transferModel.id!));
    });
    ButtonOutline noSendButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("NoSendButton"), label: "Tidak", onClick: (){
        Get.back();        
    }); 
    EditField efRemark = EditField(controller: GetXCreator.putEditFieldController("efRemarkDeliveryTransfer"), label: "Catatan", hint: "Ketik disini", alertText: "", textUnit: "", maxInput: 500, inputType: TextInputType.multiline, height: 160, onTyping: (value, editField) {});


    var isLoading = false.obs;
    late TransferModel transferModel;
    late DateTime createdDate;

    @override
    void onInit() {
        super.onInit();
        transferModel = Get.arguments;
        createdDate = Convert.getDatetime(transferModel.createdDate!);
    }

    void getDetailTransfer(){
        Service.push(
            service: ListApi.getDetailTransfer,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetTransferDetailById(transferModel.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    transferModel = body.data;
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = true;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = true;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }

    void updateStatus(String path){
        Service.push(
            service: ListApi.transferEditStatus,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, path, isSendItem.isTrue ? Mapper.asJsonString(TransferModel(driverRemarks: Uri.decodeFull(efRemark.getInput()))):""],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Get.back();
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
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
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }
}

class DeliveryDetailTransferBindings extends Bindings {
    BuildContext context;
    DeliveryDetailTransferBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DeliveryDetailTransferController(context: context));
    }
}