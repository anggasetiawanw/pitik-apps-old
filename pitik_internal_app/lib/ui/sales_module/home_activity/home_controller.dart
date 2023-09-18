import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/response/internal_app/customer_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class HomePageCustomerController extends GetxController {
    BuildContext context;
    HomePageCustomerController({required this.context});
    var page = 1.obs;
    var limit = 10.obs;
    Rx<List<Customer?>> listCustomer = Rx<List<Customer>>([]);
    Rx<List<Customer?>> searchCustomer = Rx<List<Customer>>([]);

    var isLoading = false.obs;
    var isLoadMore = false.obs;
    var isSearch = false.obs;
    var searchValue = "".obs;
    ScrollController scrollController = ScrollController();

    late ButtonOutline kunjunganModalButton = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("lamaKunjungan"),
        label: "Lama",
        onClick: () { 
            Get.back();
            Get.toNamed(
            RoutePage.visitCustomer,
            arguments: [RoutePage.fromHomePage],
        )!.then((value) {
            isLoading.value =true;
            listCustomer.value.clear();
            Timer(const Duration(milliseconds: 500), () {
                getListCustomer();
             });
        });}
    );

    late ButtonFill dataBaruModalButton = ButtonFill(
        controller: GetXCreator.putButtonFillController("baruKunjungan"),
        label: "Baru",
        onClick: () {
            Get.back();
            Get.toNamed(RoutePage.newDataCustomer)!.then((value) {
            isLoading.value =true;
            listCustomer.value.clear();
            Timer(const Duration(milliseconds: 500), () {
                getListCustomer();
             });
        });}
    );

    @override
    void onInit() {
        super.onInit();
        addItems();
    }

    @override
    void onReady() {
        super.onReady();
        isLoading.value = true;
        getListCustomer();
    }


    void getListCustomer() {
          Service.pushWithIdAndPacket(
              apiKey: 'userApi',
              service: ListApi.getListCustomer,
              context: context,
              id: 1,
              packet: [listCustomer, isLoading, isLoadMore, searchCustomer, context, page],
              body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, page.value, limit.value],
              listener: _getListCustomerListener
          );
    }

    void getSearchCustomer() {
        try {
            isLoading.value = true;
            Service.pushWithIdAndPacket(
                apiKey: 'userApi',
                service: ListApi.searchCustomer,
                context: context,
                id: 2,
                packet: [listCustomer, isLoading, isLoadMore, searchCustomer, context, page],
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, searchValue, page.value, limit.value],
                listener: _getListCustomerListener
            );
        } catch (e) {}
    }

    addItems() async {
        scrollController.addListener(() {
            if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
                isLoadMore.value = true;
                if (isSearch.isFalse) {
                    page++;
                    getListCustomer();
                } else {
                    page++;
                    getSearchCustomer();
                }
              // update();
            }
        });
    }


    final _getListCustomerListener = ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
            if (id == 1) {
                if ((body as ListCustomerResponse).data.isNotEmpty) {
                    for (var result in body.data) {
                        (packet[0] as Rx<List<Customer?>>).value.add(result);
                    }
                    if ((packet[2] as RxBool).isTrue) {
                        (packet[1]).value = false;
                        (packet[2] as RxBool).value = false;
                    } else {
                        (packet[1]).value = false;
                    }
                } else {
                    if ((packet[2] as RxBool).isTrue) {
                        int length = ((packet[0] as Rx<List<Customer?>>).value.length ~/ 10).toInt();
                        packet[5].value = length + 1;
                        (packet[1]).value = false;
                        (packet[2] as RxBool).value = false;
                    } else {
                        (packet[1]).value = false;
                    }
                }
            } else if (id == 2) {
                if ((body as ListCustomerResponse).data.isNotEmpty) {
                    if ((packet[2] as RxBool).isTrue) {
                        for (var result in body.data) {
                            (packet[3] as Rx<List<Customer?>>).value.add(result);
                        }
                        (packet[2] as RxBool).value = false;
                        (packet[1]).value = false;
                    } else {
                        (packet[3] as Rx<List<Customer?>>).value.clear();
                        if (body.data.isNotEmpty) {
                            for (var result in body.data) {
                                (packet[3] as Rx<List<Customer?>>).value.add(result);
                            }
                        }
                        (packet[1]).value = false;
                    }
                }
                else if (body.data.isEmpty) {
                    (packet[3] as Rx<List<Customer?>>).value.clear();
                    (packet[2] as RxBool).value = false;
                    (packet[1]).value = false;
                }
                else {
                    if ((packet[2] as RxBool).isTrue) {
                        int length = ((packet[3] as Rx<List<Customer?>>).value.length ~/ 10).toInt();
                        packet[5].value = length + 1;
                        (packet[2] as RxBool).value = false;

                        (packet[1]).value = false;
                    }
                }
            }
        },
        onResponseFail: (code, message, body, id, packet) {
            Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
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
    );
}

class HomePageBindings extends Bindings {
    BuildContext context;
    HomePageBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => HomePageCustomerController(context: context));
    }
}
