import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/switch_linear/switch_linear.dart';
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
  var isSwitchOn = false.obs;
  RxInt deliveryFee = RxInt(0);
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  var sumKg = 0.0.obs;
  var sumPrice = 0.0.obs;

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

  late SwitchLinear swDelivery = SwitchLinear(
    controller: GetXCreator.putSwitchLinearController("switchAssignDriver"),
    onSwitch: (isSwitch) {
      if (isSwitch) {
        isSwitchOn.value = true;
        deliveryFee.value = 10000;
      } else {
        isSwitchOn.value = false;
        deliveryFee.value = 0;
      }
    },
  );

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  int countApi =0;

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    isLoading.value = true;
    orderDetail.value = Get.arguments[0] as Order;
    isAllocated.value = Get.arguments[1] as bool;
    if (orderDetail.value!.deliveryFee != null && orderDetail.value!.deliveryFee != 0) {
      isSwitchOn.value = true;
      swDelivery.controller.isSwitchOn.value = true;
      deliveryFee.value = orderDetail.value!.deliveryFee!;
    }
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
    skuBookSO = SkuBookSO(controller: InternalControllerCreator.putSkuBookSOController("skuBookSO", orderDetail.value!.products!, false));
    if (orderDetail.value!.type! == "LB") {
      skuBookSOLB = SkuBookSO(controller: InternalControllerCreator.putSkuBookSOController("LBSKUSTOCK", orderDetail.value!.productNotes!, true));
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
      getTotalQuantity(orderDetail.value);
    }
    if (orderDetail.value!.customer != null) {
      spinnerCustomer.controller.setTextSelected(orderDetail.value!.customer!.businessName!);
    }
    if (orderDetail.value!.operationUnit != null) {
      spinnerSource.controller.setTextSelected(orderDetail.value!.operationUnit!.operationUnitName!);
      spinnerSource.controller.disable();
      bookStockButton.controller.enable();
      countingApi();
    } else {
      getListSource();
    }
  }

  void countingApi() {
    countApi++;
    if (countApi == 2) {
        timeEnd = DateTime.now();
        Duration totalTime = timeEnd.difference(timeStart);
        GlobalVar.trackRenderTime(isAllocated.isTrue ? "Form_Alokasi_Penjualan" :" From_Pesan_Stock_Penjualan", totalTime);
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
              countingApi();
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
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE,0],
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
                countingApi();
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
          productNote.add(Products(productCategoryId: orderDetail.value!.productNotes![i]!.productCategoryId, quantity: (skuBookSOLB.controller.jumlahEkor.value[i].getInputNumber() ?? 0).toInt(), weight: orderDetail.value!.productNotes![i]!.weight, price: orderDetail.value!.productNotes![i]!.price));
        }
      }
      Order orderRequest = Order(
        customerId: orderDetail.value!.customer?.id,
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
                GlobalVar.track("Click_Button_Pesan_Stock_Penjualan");
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
                GlobalVar.trackWithMap("Click_Button_Pesan_Stock_Penjualan", {"error": (body).error!.message!});

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
                GlobalVar.trackWithMap("Click_Button_Pesan_Stock_Penjualan", {"error": exception});
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
      withDeliveryFee: isSwitchOn.value,
    );
    Service.push(
      service: ListApi.editSalesOrder,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathEditSalesOrder(orderDetail.value!.id!), Mapper.asJsonString(orderPayload)],
      listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
        GlobalVar.track("Click_Button_Alokasikan_Penjualan");
        isLoading.value = false;
        Get.back();
        Get.back();
      }, onResponseFail: (code, message, body, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        GlobalVar.trackWithMap("Click_Button_Alokasikan_Penjualan", {"error": (body).error!.message!});
      }, onResponseError: (exception, stacktrace, id, packet) {
        isLoading.value = false;
        Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        GlobalVar.trackWithMap("Click_Button_Alokasikan_Penjualan", {"error": exception});
      }, onTokenInvalid: () {
        Constant.invalidResponse();
      }),
    );
  }

  void getTotalQuantity(Order? data) {
    sumNeededMin.value = 0;
    sumNeededMax.value = 0;
    sumChick.value = 0;
    sumPriceMax.value = 0;
    sumPriceMin.value = 0;
    sumKg.value = 0;
    sumPrice.value = 0;
    // isDeliveryPrice.value = data!.deliveryFee != null && data.deliveryFee != 0;
    // priceDelivery.value = data.deliveryFee ?? 0;
    if (orderDetail.value!.status == "BOOKED" || orderDetail.value!.status == "READY_TO_DELIVER") {
      for (var product in data!.products!) {
        if (product!.returnWeight == null) {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumChick.value += product.quantity!;
            sumKg.value += product.weight!;
            sumPrice.value += product.weight! * product.price!;
          } else {
            sumKg.value += product.weight!;
            sumPrice.value += product.weight! * product.price!;
          }
        } else {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumChick.value += product.quantity! - product.returnQuantity!;
            sumKg.value += (product.weight! - product.returnWeight!);
            sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
          } else {
            sumKg.value += (product.weight! - product.returnWeight!);
            sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
          }
        }
      }
    } else {
      for (var product in data!.products!) {
        if (product!.returnWeight == null) {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumNeededMin.value += product.quantity! * product.minValue!;
            sumNeededMax.value += product.quantity! * product.maxValue!;
            sumChick.value += product.quantity!;
            sumPriceMin.value += product.price! * (product.minValue! * product.quantity!);
            sumPriceMax.value += product.price! * (product.maxValue! * product.quantity!);
          } else {
            sumNeededMin.value += product.weight!;
            sumNeededMax.value += product.weight!;
            sumPriceMin.value += product.weight! * product.price!;
            sumPriceMax.value += product.weight! * product.price!;
          }
        } else {
          if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
            sumNeededMin.value += (product.quantity! - product.returnQuantity!) * product.minValue!;
            sumNeededMax.value += (product.quantity! - product.returnQuantity!) * product.maxValue!;
            sumChick.value += product.quantity! - product.returnQuantity!;
            sumPriceMin.value += product.price! * (product.minValue! * (product.quantity! - product.returnQuantity!));
            sumPriceMax.value += product.price! * (product.maxValue! * (product.quantity! - product.returnQuantity!));
          } else {
            sumNeededMin.value += (product.weight! - product.returnWeight!);
            sumNeededMax.value += (product.weight! - product.returnWeight!);
            sumPriceMin.value += (product.weight! - product.returnWeight!) * product.price!;
            sumPriceMax.value += (product.weight! - product.returnWeight!) * product.price!;
          }
        }
      }
    }
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
