import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/order_request.dart';
import 'package:model/profile.dart';
import 'package:model/response/internal_app/list_driver_response.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class AssignDriverController extends GetxController{
  BuildContext context;
  AssignDriverController({required this.context});

  Rxn<Order> orderDetail = Rxn<Order>();
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var sumChick = 0.obs;
    var sumKg =0.0.obs;
    var sumPrice = 0.0.obs;

  late SpinnerSearch spinnerDriver  = SpinnerSearch(
    controller: GetXCreator.putSpinnerSearchController("driverList"),
    label: "Driver*",
    hint: "Pilih salah satu",
    alertText: "Driver harus dipilih!",
    items: const {
    },
    onSpinnerSelected: (text) {
    },
  );

  late ButtonFill bfYesAssign;
  late ButtonOutline boNoAssign;

  Rx<List<OperationUnitModel?>> listSource = Rx<List<OperationUnitModel>>([]);
  Rx<List<Profile?>> listDriver = Rx<List<Profile?>>([]);

  @override
  void onInit() {
    super.onInit();
    orderDetail.value = Get.arguments as Order;
    isLoading.value = true;
    boNoAssign = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noAssign"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );

  }


  @override
  void onReady() {
    getListDriver();
    super.onReady();
    bfYesAssign = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesAssign"),
      label: "Ya",
      onClick: () {
        assignToDriver();
      },
    );
    getTotalQuantity(orderDetail.value);
  }

  void getDetailOrder(){
    Service.push(
        service: ListApi.detailOrderById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, ListApi.pathDetailOrderById(orderDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet){
              orderDetail.value = (body as OrderResponse).data;
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet){
                Get.snackbar(
                    "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
              isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = false;
            },  onTokenInvalid: Constant.invalidResponse())
    );
  }

    void getTotalQuantity(Order? data){
        sumChick.value =0;
        sumKg.value =0;
        sumPrice.value =0;
        for(var product in data!.products!) {
            if(product!.returnWeight == null ) {
            if (product.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
                sumChick.value += product.quantity!;
                sumKg.value += product.weight!;
                sumPrice.value += product.weight! * product.price!;
                } else {
                sumKg.value += product.weight!;
                sumPrice.value += product.weight! * product.price!;
            }
            } else {
            if (product.category!.name! == AppStrings.LIVE_BIRD ||product.category!.name! == AppStrings.AYAM_UTUH ||product.category!.name! == AppStrings.BRANGKAS){
                sumChick.value += product.quantity! - product.returnQuantity!;
                sumKg.value += (product.weight! - product.returnWeight!);
                sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
                } else {
                sumKg.value += (product.weight! - product.returnWeight!);
                sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
            }
            }
        }
    }

  void getListDriver(){
    Service.push(
        service: ListApi.getListDriver,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, "driver",1,50],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListDriverResponse).data) {
                mapList[units!.fullName!] = false;
              }
              Timer(const Duration(milliseconds: 100), () {
                spinnerDriver.controller.generateItems(mapList);
              });
              for (var result in body.data) {
                listDriver.value.add(result);
              }
            if (orderDetail.value!.driver != null ) {
                spinnerDriver.controller.setTextSelected(orderDetail.value!.driver!.fullName!);
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

  void assignToDriver(){
    Profile? driverSelected = listDriver.value.firstWhere(
          (element) => element!.fullName == spinnerDriver.controller.textSelected.value,
    );

    OrderRequest orderRequest = OrderRequest(
      driverId: driverSelected!.id!,
    );

    Service.push(
        service: ListApi.transferStatusDriver,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, ListApi.pathOrderSetDriver(orderDetail.value!.id!), Mapper.asJsonString(orderRequest)],
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

    Get.back();
  }


}

class AssignDriverBindings extends Bindings {
  BuildContext context;
  AssignDriverBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => AssignDriverController(context: context));
  }


}