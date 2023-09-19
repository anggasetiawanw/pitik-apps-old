

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
class StockDetailController extends GetxController {
    BuildContext context;
    StockDetailController({required this.context});
    late ButtonFill yesButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesButton"), label: "Ya", onClick: (){
        updateStock("CANCELLED");
        Get.back();
    });
    ButtonOutline noButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("No Button"), label: "Tidak", onClick: (){
        Get.back();
    });
  
    late OpnameModel opnameModel;
    late DateTime createdDate;
    var isLoading = false.obs;

    @override
    void onInit() {
        opnameModel = Get.arguments;
        createdDate = Convert.getDatetime(opnameModel.createdDate!);
        isLoading.value = true;
        getDetailStock();
        super.onInit();
    }
     void getDetailStock(){
        Service.push(
            service: ListApi.detailOpnameById,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailOpanameById(opnameModel.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    opnameModel = body.data;
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
                },
                onTokenInvalid: Constant.invalidResponse()));
    }

    void updateStock(String status){
        isLoading.value = true;
        Service.push(
            service: ListApi.updateOpnameById,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateOpnameById(opnameModel.id!), Mapper.asJsonString(generatePayload(status))],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    isLoading.value =false;
                    Get.back();
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);

                    isLoading.value =false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value =false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }
    
    OpnameModel generatePayload(String status){
        List<Products?> products = [];

        for (var element in opnameModel.products!) {
          products.add(Products(
            productCategoryId: element!.id,
            quantity: element.quantity,
            weight: element.weight
        ));
        }
        return OpnameModel(
            operationUnitId: opnameModel.operationUnit!.id,
            status: status,
            products: products
        );
    }
}
class StockDetailBindings extends Bindings {
    BuildContext context;
    StockDetailBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => StockDetailController(context: context));
    }
}