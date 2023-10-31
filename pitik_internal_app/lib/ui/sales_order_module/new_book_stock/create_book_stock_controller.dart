import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/so_status.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_book_so/sku_book_so.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class CreateBookStockController extends GetxController {
  BuildContext context;
  CreateBookStockController({required this.context});

  Rxn<Order> orderDetail = Rxn<Order>();
  ScrollController scrollController = ScrollController();
  late SkuBookSO skuBookSO;
  late SkuBookSO skuBookSOLB;
  var isLoading = false.obs;
  var isAllocated = false.obs;

  late ButtonFill bookStockButton = ButtonFill(controller: GetXCreator.putButtonFillController("bookStocked"), label: "Pesan Stock", onClick: () {});

  late SpinnerField spinnerSource = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("sumberPenjualan"),
    label: "Sumber*",
    hint: "Pilih salah satu",
    alertText: "Sumber harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {
        bookStockButton.controller.enable();
      }
    },
  );

  late SpinnerField spinnerCustomer = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("customerPenjualan"),
    label: "Customer*",
    hint: "Pilih salah satu",
    alertText: "Customer harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {
        bookStockButton.controller.enable();
      }
    },
  );

  late ButtonFill bfYesBook;
  late ButtonOutline boNoBook;

  Rx<List<OperationUnitModel?>> listSource = Rx<List<OperationUnitModel>>([]);

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    orderDetail.value = Get.arguments[0] as Order;
    isAllocated.value = Get.arguments[1] as bool;
    getDetailOrder();
    spinnerCustomer.controller.disable();
    bookStockButton.controller.disable();
    boNoBook = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noBookStock"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );
    skuBookSO = SkuBookSO(controller: InternalControllerCreator.putSkuBookSOController("skuBookSO", orderDetail.value!.products!));
    if (orderDetail.value!.type! == "LB") {
      skuBookSOLB = SkuBookSO(controller: InternalControllerCreator.putSkuBookSOController("LBSKUSTOCK", orderDetail.value!.productNotes!));
    }
  }

  @override
  void onReady() {
    super.onReady();
    bfYesBook = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesBookStock"),
      label: "Ya",
      onClick: () {
        Get.back();
        updateBookStock();
      },
    );
    if (isAllocated.isTrue) {
      bookStockButton.controller.changeLabel("Konfirmasi");
    }
    if (orderDetail.value!.customer != null) {
      spinnerCustomer.controller.setTextSelected(orderDetail.value!.customer!.businessName!);
    }
    if (orderDetail.value!.operationUnit != null) {
      print("operationUnitName : ${orderDetail.value!.operationUnit!.operationUnitName}");
      spinnerSource.controller.setTextSelected(orderDetail.value!.operationUnit!.operationUnitName!);
      spinnerSource.controller.disable();
      bookStockButton.controller.enable();
    } else {
      getListSource();
    }
  }

  void getDetailOrder() {
    isLoading.value = true;
    Service.push(
        service: ListApi.detailOrderById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathDetailOrderById(orderDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              isLoading.value = false;
              orderDetail.value = (body as OrderResponse).data;
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = false;
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
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getListSource() {
    spinnerSource.controller
      ..disable()
      ..setTextSelected("Loading...")
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              Timer(const Duration(milliseconds: 500), () {
                spinnerSource.controller.generateItems(mapList);
              });
              for (var result in body.data) {
                listSource.value.add(result);
              }
              spinnerSource.controller
                ..enable()
                ..setTextSelected("")
                ..hideLoading();
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
              spinnerSource.controller
                ..setTextSelected("")
                ..hideLoading();
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
              spinnerSource.controller
                ..setTextSelected("")
                ..hideLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void updateBookStock() {
    OperationUnitModel? sourceSelected = listSource.value.firstWhereOrNull((element) => element!.operationUnitName == spinnerSource.controller.textSelected.value);

    if (isAllocated.isFalse) {
      List<Products?> products = [];
      List<Products?> productNote = [];
      for (int i = 0; i < skuBookSO.controller.itemCount.value; i++) {
        products.add(Products(productItemId: orderDetail.value!.products![i]!.id, quantity: (skuBookSO.controller.jumlahEkor.value[i].getInputNumber() ?? 0).toInt(), weight: skuBookSO.controller.jumlahkg.value[i].getInputNumber() ?? 0, price: orderDetail.value!.products![i]!.price));
      }
      if (orderDetail.value!.type == "LB") {
        for (int i = 0; i < skuBookSOLB.controller.itemCount.value; i++) {
          productNote.add(Products(productItemId: orderDetail.value!.products![i]!.id, quantity: (skuBookSOLB.controller.jumlahEkor.value[i].getInputNumber() ?? 0).toInt(), weight: skuBookSOLB.controller.jumlahkg.value[i].getInputNumber() ?? 0, price: orderDetail.value!.products![i]!.price));
        }
      }
      Order orderRequest = Order(
        customerId: orderDetail.value!.customer!.id!,
        operationUnitId: sourceSelected != null ? sourceSelected.id : orderDetail.value!.operationUnit!.id!,
        products: products,
        productNotes: productNote,
        type: orderDetail.value!.type,
        category: orderDetail.value!.category,
      );
      Service.push(
          service: ListApi.bookStockSalesOrder,
          context: context,
          body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, ListApi.pathBookStock(orderDetail.value!.id!), Mapper.asJsonString(orderRequest)],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Get.back();
                isLoading.value = false;
                Get.back();
              },
              onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                  "Pesan",
                  "Terjadi Kesalahan, ${(body).error!.message}",
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
                  "Terjadi kesalahan internal",
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                isLoading.value = false;
              },
              onTokenInvalid: Constant.invalidResponse()));
    } else {
      updateAllocated(sourceSelected!.id!);
    }
  }

  void updateAllocated(String idJagal) {
    isLoading.value = true;
    Order orderPayload = Order(
      customerId: orderDetail.value!.customerId,
      operationUnitId: idJagal,
      products: orderDetail.value!.products,
      productNotes: orderDetail.value!.productNotes,
      type: orderDetail.value!.type,
      status: EnumSO.allocated,
      category: orderDetail.value!.category,
      remarks: orderDetail.value!.remarks,
    );
    Service.push(
      service: ListApi.editSalesOrder,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathEditSalesOrder(orderDetail.value!.id!), Mapper.asJsonString(orderPayload)],
      listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.back();
        Get.back();
      }, onResponseFail: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      }, onResponseError: (exception, stacktrace, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
      }, onTokenInvalid: () {
        Constant.invalidResponse();
      }),
    );
  }
}

class BookStockBindings extends Bindings {
  BuildContext context;
  BookStockBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => CreateBookStockController(context: context));
  }
}
