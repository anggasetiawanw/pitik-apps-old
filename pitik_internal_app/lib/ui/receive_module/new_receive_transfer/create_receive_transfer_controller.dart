import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_request.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/06/23

class CreateGrTransferController extends GetxController {
    BuildContext context;

    CreateGrTransferController({required this.context});

    late ButtonFill yesSendButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesSendGrTransferButton"), label: "Ya", onClick: (){
        Get.back();
        saveGrTransfer();
    });
    ButtonOutline noSendButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("noSendGrTransferButton"), label: "Tidak", onClick: (){
        Get.back();
    });

    EditField efChickReceived = EditField(controller: GetXCreator.putEditFieldController("sumChickReceived"), label: "Jumlah Ekor Diterima*", hint: "Ketik disini", alertText: "Jumlah Ekor harus diisi!", textUnit: "Ekor", maxInput: 20, onTyping: (value,controller){}, inputType: TextInputType.number,);
    EditField efWeightReceived = EditField(controller: GetXCreator.putEditFieldController("totalWeightReceived"), label: "Jumlah Kg Diterima*", hint: "Ketik disini", alertText: "Total Kg harus diisi!", textUnit: "Kg", maxInput: 20, onTyping: (value,controller){}, inputType: TextInputType.number,);

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
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, ListApi.pathGetTransferDetailById(transferModel.id!)],
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

    void saveGrTransfer() {
        isLoading.value = true;
        PurchaseRequest transferPayload = generatePayload();
        Service.push(
            service: ListApi.createGoodReceived,
            context: context,
            body: [
                Constant.auth!.token,
                Constant.auth!.id,
                Constant.xAppId,
                Mapper.asJsonString(transferPayload)
            ],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.back();
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Alert", (body as ErrorResponse).error!.message!,
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
                },
                onTokenInvalid: Constant.invalidResponse()
            ),
        );

    }

    PurchaseRequest generatePayload() {
        List<Products?> listProductPayload = [];
        listProductPayload.add(Products(
            productItemId: transferModel.products![0]!.productItems![0]!.id,
            quantity:  transferModel.products![0]!.name == AppStrings.AYAM_UTUH ||  transferModel.products![0]!.name== AppStrings.BRANGKAS ||  transferModel.products![0]!.name == AppStrings.LIVE_BIRD ? int.parse(efChickReceived.getInput()) : null,
            weight: efWeightReceived.getInputNumber(),
        ));
        return PurchaseRequest(
            products: listProductPayload,
            internalTransferId: transferModel.id!,
        );
    }

    bool isValid(){
        if(transferModel.products![0]!.name == AppStrings.AYAM_UTUH || transferModel.products![0]!.name == AppStrings.BRANGKAS || transferModel.products![0]!.name  == AppStrings.LIVE_BIRD){
            if(efChickReceived.getInput().isEmpty){
                efChickReceived.controller.showAlert();
                Scrollable.ensureVisible(efChickReceived.controller.formKey.currentContext!);
                return false;
            }
        }

        if(efWeightReceived.getInput().isEmpty){
            efWeightReceived.controller.showAlert();
            Scrollable.ensureVisible(efWeightReceived.controller.formKey.currentContext!);
            return false;
        }
        return true;
    }


}
class CreateGrTransferBindings extends Bindings {
    BuildContext context;
    CreateGrTransferBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => CreateGrTransferController(context: context));
    }
}