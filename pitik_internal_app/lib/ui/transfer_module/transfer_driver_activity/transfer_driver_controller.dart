import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/convert.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/profile.dart';
import 'package:model/response/internal_app/list_driver_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class TransferDriverController extends GetxController {
    BuildContext context;

    TransferDriverController({required this.context});
    late ButtonFill yesSendButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesSendButton"), label: "Ya", onClick: (){
        Get.back();
        isLoading.value = true;
        updateStatus();
    });
    ButtonOutline noSendButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("NoSendButton"), label: "Tidak", onClick: (){
        Get.back();        
    });

    SpinnerSearch assignDriver = SpinnerSearch(controller: GetXCreator.putSpinnerSearchController("assignDriver"), label: "Driver*", hint: "Pilih salah satu", alertText: "Driver harus dipilih!", items: {}, onSpinnerSelected: (value){});

    var isLoading = false.obs;
    var isEdit = false.obs;
    late TransferModel transferModel;
    late DateTime createdDate;
    Rx<List<Profile?>> listDriver = Rx<List<Profile?>>([]);
    @override
    void onInit() {
        super.onInit();
        transferModel = Get.arguments[0];
        isEdit.value = Get.arguments[1];
        createdDate = Convert.getDatetime(transferModel.createdDate!);

    }
    @override
    void onReady() {
        super.onReady();
        if(isEdit.isTrue) {
            assignDriver.controller.textSelected.value = transferModel.driver!.fullName!;
        }
        isLoading.value = true;
        getListDriver();
    }

    void getListDriver(){
        Service.push(
            service: ListApi.getListDriver,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, "driver",1,50],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    (body as ListDriverResponse).data.forEach((units) => mapList[units!.fullName!] = false);
                    print(mapList);
                    assignDriver.controller.generateItems(mapList);
                    for (var result in body.data) {
                        listDriver.value.add(result);
                    }             
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

    void updateStatus(){
        if(validation()){
            Service.push(
                service: ListApi.transferStatusDriver,
                context: context,
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathTransferSetDriver(transferModel.id!), Mapper.asJsonString(generatePayload())],
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
        } else {
            isLoading.value =false;
        }

    }

    bool validation(){
        if (assignDriver.controller.textSelected.value.isEmpty) {
            assignDriver.controller.showAlert();
            Scrollable.ensureVisible(assignDriver.controller.formKey.currentContext!);
            return false;
        }  

        return true;
    }

    TransferModel generatePayload(){
        Profile? selectDriver = listDriver.value.firstWhere((element) => element!.fullName == assignDriver.controller.textSelected.value);
        
        return TransferModel(
            driverId: selectDriver!.id,
        );
    }
}
class TransferDriverBindings extends Bindings {
    BuildContext context;
    TransferDriverBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => TransferDriverController(context: context));
    }
}