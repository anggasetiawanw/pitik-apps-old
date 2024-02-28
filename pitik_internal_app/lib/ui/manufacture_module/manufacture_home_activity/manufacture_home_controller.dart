
import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/manufacture_model.dart';
import 'package:model/response/internal_app/manufacture_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
class ManufactureHomeController extends GetxController {
    BuildContext context;
    ManufactureHomeController({required this.context});

    ScrollController scrollController = ScrollController();

    var page = 1.obs;
    var limit = 10.obs;

    Rx<List<ManufactureModel?>> listManufacture = Rx<List<ManufactureModel>>([]);
    var isLoading = false.obs;
    var isLoadMore = false.obs;

    late ButtonFill createManufacture = ButtonFill(controller: GetXCreator.putButtonFillController("createManufacture"), label: "Buat Manufaktur", onClick: (){
        Constant.track("Click_Buat_Manufaktur");
        Get.toNamed(RoutePage.manufactureForm)!.then((value) {
            isLoading.value =true;
            listManufacture.value.clear();
            page.value = 0;
            Timer(const Duration(milliseconds: 500), () {
                getListManufacture();
             });
        });
    });

    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

    @override
    void onInit() {
        super.onInit();
        scrollListener();
    }

    @override
    void onReady() {
        super.onReady();

        isLoading.value = true;
        getListManufacture();
    }


    scrollListener() async {
        scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
                isLoadMore.value = true;
                page++;
                getListManufacture();
            }
        });
    }

    void getListManufacture() {
        Service.push(
            service: ListApi.getListManufacture,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    if ((body as ListManufactureResponse).data.isNotEmpty){
                        for (var result in body.data){
                            listManufacture.value.add(result as ManufactureModel);
                        }
                        isLoading.value  = false;
                        if(isLoadMore.isTrue){
                            isLoadMore.value = false;
                        }
                    } else {
                        if(isLoadMore.isTrue){
                            page.value = (listManufacture.value.length ~/ 10).toInt() + 1;
                            isLoadMore.value = false;
                        } else {
                            isLoading.value = false;
                        }
                    }
                    timeEnd = DateTime.now();
                    Duration totalTime = timeEnd.difference(timeStart);
                    Constant.trackRenderTime("Manufacture_Home", totalTime);
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );

                    isLoading.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }
}
class ManufactureHomeBindings extends Bindings {
    BuildContext context;
    ManufactureHomeBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => ManufactureHomeController(context: context));
    }
}