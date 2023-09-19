import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/location_permission.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/convert.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/checkin_model.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/checkin_component.dart';
class DeliveryConfirmTransferController extends GetxController {
    BuildContext context;

    DeliveryConfirmTransferController({required this.context});
    late ButtonFill confirmButton = ButtonFill(controller: GetXCreator.putButtonFillController("confirmButton"), label: "Konfirmasi", onClick: (){
      isLoading.value = true;
        Get.back();
        konfirmasi();
    });

    double? latitude;
    double? longitude;
    var isLoading = false.obs;   
    var isLoadCheckin = false.obs; 
    var showErrorCheckin = false.obs;
    var isSuccessCheckin = false.obs;
    var error = "".obs;
    late TransferModel transferModel;
    late DateTime createdDate;


    late ButtonOutline checkinButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("ButtonCheckin"),
    label: "Checkin",
    isHaveIcon: true,
    onClick: () async {
        isLoadCheckin.value = true;
        final hasPermission = await handleLocationPermission();
        if (hasPermission){
            const timeLimit = Duration(seconds: 5);
            await FlLocation.getLocation(timeLimit: timeLimit).then((position) {
                if(position.isMock) {
                    Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, Gps Mock Detected",
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    isLoadCheckin.value = false;
                } else {
                    Service.push(
                        service: ListApi.visitCheckin,
                        context: context,
                        body: [
                            Constant.auth!.token,
                            Constant.auth!.id,
                            Constant.xAppId!,
                            ListApi.pathCheckinDeliveryTransfer(transferModel.targetOperationUnit!.id!),
                            Mapper.asJsonString(CheckInModel(latitude:position.latitude, longitude: position.longitude ))
                        ],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                latitude = position.latitude;
                                longitude = position.longitude;
                                GpsComponent.checkinSuccess();
                                isLoadCheckin.value = false;
                                confirmButton.controller.enable();
                                isSuccessCheckin.value = true;
                                showErrorCheckin.value = true;
                            },
                            onResponseFail: (code, message, body, id, packet) {
                                error.value = (body as ErrorResponse).error!.message!;
                                GpsComponent.failedCheckin(error.value);
                                isLoadCheckin.value = false;
                                isSuccessCheckin.value = false;
                                showErrorCheckin.value = true;
                            },
                            onResponseError: (exception, stacktrace, id, packet) {
                                isLoadCheckin.value = false;
                                isSuccessCheckin.value = false;
                                showErrorCheckin.value = true;

                            },
                            onTokenInvalid: Constant.invalidResponse())
                    );
                }
                }).onError((error, stackTrace) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${error.toString()}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                    isLoadCheckin.value = false;    
                });
        } else {
            isLoadCheckin.value = false;            
        }
        }
    );


    @override
    void onInit() {
        super.onInit();
        transferModel = Get.arguments;
        createdDate = Convert.getDatetime(transferModel.createdDate!);
    }
    @override
    void onReady() {
        super.onReady();
        confirmButton.controller.disable();
    }

    void konfirmasi(){
        isLoading.value = true;
        Service.push(
            service: ListApi.transferStatusDriver,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathTransferConfirmed(transferModel.id!), Mapper.asJsonString(CheckInModel(
                latitude: latitude,
                longitude: longitude,
            ))],
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

class DeliveryConfirmTransferBindings extends Bindings {
    BuildContext context;
    DeliveryConfirmTransferBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DeliveryConfirmTransferController(context: context));
    }
}