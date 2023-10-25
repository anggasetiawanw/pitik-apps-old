import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/convert.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/visit_customer_model.dart';
import 'package:model/response/internal_app/customer_response.dart';
import 'package:model/response/internal_app/visit_list_customer_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

class CustomerDetailController extends GetxController {
  BuildContext context;

  CustomerDetailController({required this.context});

  Rx<List<VisitCustomer?>> visitCustomer = Rx<List<VisitCustomer>>([]);

  ScrollController scrollController = ScrollController();
  Rxn<Customer> customerDetail = Rxn<Customer>();
  Rxn<Customer> customer = Rxn<Customer>();
  Rxn<DateTime> dateCustomer = Rxn<DateTime>();

  var isLoadingDetails = false.obs;
  var isLoadingKunjungan = false.obs;
  var isLoadMore = false.obs;
  var archiveDisable = true.obs;
  var page = 1.obs;
  var limit = 10.obs;

  late ButtonFill kunjunganButton = ButtonFill(
    controller: GetXCreator.putButtonFillController("kunjunganDetail"),
    label: "Kunjungan",
    onClick: () => Get.toNamed(
      RoutePage.visitCustomer,
      arguments: [
        RoutePage.fromDetailCustomer,
        customerDetail.value,
      ],
    )!.then((value) => getData()),
  );

  late ButtonOutline editButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("editDetail"),
      label: "Edit",
      onClick: () =>
          Get.toNamed(RoutePage.editCustomer, arguments: customerDetail.value)!
              .then((value) {
            Timer(const Duration(milliseconds: 100), () {
              getData();
            });
          }));

  late ButtonFill iyaArchiveButton;

  ButtonOutline tidakArchiveButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("tidakArchive"),
    label: "Tidak",
    onClick: () => Get.back(),
  );

  @override
  void onInit() {
    super.onInit();
    isLoadingDetails.value = true;
    customer.value = Get.arguments as Customer;
  }

  @override
  void onReady() {
    super.onReady();
    getData();
    getTime(false);
    iyaArchiveButton = ButtonFill(
        controller: GetXCreator.putButtonFillController("IyaArchive"),
        label: "Ya",
        onClick: () => archivedCustomer(context));
  }


  void archivedCustomer(BuildContext context) {
    String custId = customerDetail.value!.id!;
    isLoadingDetails.value = true;
    if (customerDetail.value!.isArchived! == true) {
      Service.push(
          apiKey: 'userApi',
          service: ListApi.archiveCustomer,
          context: context,
          body: [
            Constant.auth!.token,
            Constant.auth!.id,
            Constant.xAppId,
            ListApi.pathUnarchiveCustomer(custId)
          ],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Service.push(
                    apiKey: 'userApi',
                    service: ListApi.detailCustomerById,
                    context: context,
                    body: [
                      Constant.auth!.token,
                      Constant.auth!.id,
                      Constant.xAppId,
                      ListApi.pathGetDetailCustomerById(custId)
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                      customerDetail.value = (body as CustomerResponse).data;
                      isLoadingDetails.value = false;
                    }, onResponseFail: (code, message, body, id, packet) {
                      Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                      );
                    }, onResponseError: (exception, stacktrace, id, packet) {
                      Get.snackbar(
                        "Pesan",
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                      );
                      //  isLoading.value = false;
                    }, onTokenInvalid:Constant.invalidResponse()));

                kunjunganButton.controller.enable();
                editButton.controller.enable();
              },
              onResponseFail: (code, message, body, id, packet) {},
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
              onTokenInvalid: Constant.invalidResponse()));
    } else {
      Service.push(
          apiKey: 'userApi',
          service: ListApi.archiveCustomer,
          context: context,
          body: [
            Constant.auth!.token,
            Constant.auth!.id,
            Constant.xAppId,
            ListApi.pathArchiveCustomer(custId)
          ],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Service.push(
                    apiKey: 'userApi',
                    service: ListApi.detailCustomerById,
                    context: context,
                    body: [
                      Constant.auth!.token,
                      Constant.auth!.id,
                      Constant.xAppId,
                      ListApi.pathGetDetailCustomerById(custId)
                    ],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                          customerDetail.value =
                              (body as CustomerResponse).data;
                          isLoadingDetails.value = false;
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
                        onTokenInvalid: Constant.invalidResponse()));

                kunjunganButton.controller.disable();
                editButton.controller.disable();
              },
              onResponseFail: (code, message, body, id, packet) {},
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
              onTokenInvalid: Constant.invalidResponse()));
    }

    Get.back();
    Get.back();
  }

  void getTime(bool isRefresh) {
    if(isRefresh){ 
        if (customerDetail.value!.latestVisit != null) {
            dateCustomer.value =
                Convert.getDatetime(customerDetail.value!.latestVisit!.createdDate!);
        }
    } else {
        if (customer.value!.latestVisit != null) {
            dateCustomer.value =
                Convert.getDatetime(customer.value!.latestVisit!.createdDate!);
        }
    }
   
  }

  void getData() {
    try {
      String custId = customer.value!.id!;
      isLoadingKunjungan.value = true;
      isLoadingDetails.value = true;
      visitCustomer.value.clear();
      Service.push(
          apiKey: 'userApi',
          service: ListApi.detailCustomerById,
          context: context,
          body: [
            Constant.auth!.token,
            Constant.auth!.id,
            Constant.xAppId,
            ListApi.pathGetDetailCustomerById(custId)
          ],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                customerDetail.value = (body as CustomerResponse).data;
                getTime(true);
                isLoadingDetails.value = false;
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

                isLoadingDetails.value = false;
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
              onTokenInvalid: Constant.invalidResponse()));

      Service.push(
          service: ListApi.getListVisit,
          context: context,
          body: [
            Constant.auth!.token,
            Constant.auth!.id,
            Constant.xAppId,
            page.value,
            limit.value,
            ListApi.pathGetListVisit(custId)
          ],
          listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as ListVisitCustomerResponse).data) {
              visitCustomer.value.add(result);
            }

            isLoadingKunjungan.value = false;
          }, onResponseFail: (code, message, body, id, packet) {
            Get.snackbar(
              "Pesan",
              "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
          }, onResponseError: (exception, stacktrace, id, packet) {
            Get.snackbar(
              "Pesan",
              "Terjadi kesalahan internal",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            //  isLoading.value = false;
          }, onTokenInvalid: Constant.invalidResponse()));
    } catch (e) {
        Get.snackbar(
            "Pesan",
            "Terjadi kesalahan internal",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
        );
    }
  }

  addItems() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        page.value++;
        String custId = customerDetail.value!.id!;
        Service.push(
            service: ListApi.getListVisit,
            context: context,
            body: [
              Constant.auth!.token,
              Constant.auth!.id,
              Constant.xAppId,
              page.value,
              limit.value,
              ListApi.pathGetListVisit(custId)
            ],
            listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
              for (var result in (body as ListVisitCustomerResponse).data) {
                visitCustomer.value.add(result);
              }

              isLoadingKunjungan.value = false;
            }, onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            }, onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              //  isLoading.value = false;
            }, onTokenInvalid: () {
              Constant.invalidResponse();
            }));
      }
    });
  }
}

class CustomerDetailBindings extends Bindings {
  BuildContext context;
  CustomerDetailBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => CustomerDetailController(context: context));
  }
}
