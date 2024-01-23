import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/convert.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
class TransferDetailController extends GetxController {
    BuildContext context;

    TransferDetailController({required this.context});
    late ButtonFill yesCancelButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesButton"), label: "Ya", onClick: (){
        Get.back();
        isLoading.value = true;
        if(transferModel.status == "BOOKED"){
            updateStatus(ListApi.pathTransferCancelBookStock(transferModel.id!));
        }
        else if(transferModel.status == "READY_TO_DELIVER"){
            updateStatus(ListApi.pathTransferReadyToDeliver(transferModel.id!));
        }
        else {
            updateStatus(ListApi.pathTransferCancel(transferModel.id!));
        }
    });
    ButtonOutline noCancelButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("No Button"), label: "Tidak", onClick: (){
        Get.back();
    });
    late ButtonFill yesSendButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesSendButton"), label: "Ya", onClick: (){
        isLoading.value = true;
        Get.back();
        updateStatus(ListApi.pathTransferBookStock(transferModel.id!));
    });
    ButtonOutline noSendButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("NoSendButton"), label: "Tidak", onClick: (){
        Get.back();        
    });

    SpinnerField assignDriver = SpinnerField(controller: GetXCreator.putSpinnerFieldController("assignDriver"), label: "Driver*", hint: "Pilih salah satu", alertText: "Driver harus dipilih!", items: const {}, onSpinnerSelected: (value){});

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
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, path, Mapper.asJsonString(null)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Get.back();
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body).error!.message}",
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
class TransferDetailBindings extends Bindings {
    BuildContext context;
    TransferDetailBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => TransferDetailController(context: context));
    }
}