import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:intl/intl.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/profile.dart';
import 'package:model/response/internal_app/list_driver_response.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class AssignDriverController extends GetxController {
  BuildContext context;
  AssignDriverController({required this.context});

  Rxn<Order> orderDetail = Rxn<Order>();
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var sumChick = 0.obs;
  var sumKg = 0.0.obs;
  var sumPrice = 0.0.obs;
  var deliveryPrice = 0.0.obs;
  var isSwitchOn = false.obs;

  late SpinnerSearch spinnerDriver = SpinnerSearch(
    controller: GetXCreator.putSpinnerSearchController("driverList"),
    label: "Driver*",
    hint: "Pilih salah satu",
    alertText: "Driver harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {},
  );

  late ButtonFill bfYesAssign;
  late ButtonOutline boNoAssign;

  Rx<List<OperationUnitModel?>> listSource = Rx<List<OperationUnitModel>>([]);
  Rx<List<Profile?>> listDriver = Rx<List<Profile?>>([]);

  DateTimeField dtDeliveryDate = DateTimeField(
    controller: GetXCreator.putDateTimeFieldController("DeliveryDateSo"),
    label: "Tanggal Pengiriman*",
    hint: "dd/mm/yyyy",
    alertText: "Tanggal Pengiriman harus dipilih!",
    onDateTimeSelected: (date, dateField) => dateField.controller.setTextSelected('${Convert.getDay(date)}/${Convert.getMonthNumber(date)}/${Convert.getYear(date)}'),
    flag: 1,
  );
  DateTimeField dtDeliveryTime = DateTimeField(
    controller: GetXCreator.putDateTimeFieldController("deliveryTimeSo"),
    label: "Waktu Pengiriman",
    hint: "hh:mm",
    alertText: "Waktu Pengiriman harus dipilih!",
    onDateTimeSelected: (date, dateField) => dateField.controller.setTextSelected('${Convert.getHour(date)}:${Convert.getMinute(date)}'),
    flag: 2,
  );

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
    if (orderDetail.value!.deliveryTime != null) {
      dtDeliveryDate.controller.setTextSelected(DateFormat("dd/MM/yyyy").format(Convert.getDatetime(orderDetail.value!.deliveryTime!)));
      dtDeliveryDate.controller.disable();
      String time = DateFormat("HH:mm").format(Convert.getDatetime(orderDetail.value!.deliveryTime!)) != "00:00" ? DateFormat("HH:mm").format(Convert.getDatetime(orderDetail.value!.deliveryTime!)) : "";
      dtDeliveryTime.controller.setTextSelected(time);
    }
    getTotalQuantity(orderDetail.value);
  }

  void getDetailOrder() {
    Service.push(
        service: ListApi.detailOrderById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, ListApi.pathDetailOrderById(orderDetail.value!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              orderDetail.value = (body as OrderResponse).data;
              isLoading.value = false;
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
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getTotalQuantity(Order? data) {
    sumChick.value = 0;
    sumKg.value = 0;
    sumPrice.value = 0;
    deliveryPrice.value = data?.deliveryFee?.toDouble() ?? 0;
    for (var product in data!.products!) {
      if (product!.returnWeight == null) {
        if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS) {
          sumChick.value += product.quantity!;
          sumKg.value += product.weight!;
          sumPrice.value += product.weight! * product.price!;
        } else {
          sumKg.value += product.weight!;
          sumPrice.value += product.weight! * product.price!;
        }
      } else {
        if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS) {
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

  void getListDriver() {
    spinnerDriver.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListDriver,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, "driver", 1, 0],
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
              if (orderDetail.value!.driver != null) {
                spinnerDriver.controller.setTextSelected(orderDetail.value!.driver!.fullName!);
              }
              isLoading.value = false;

              spinnerDriver.controller
                ..enable()
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
  }

  void assignToDriver() {
    Profile? driverSelected = listDriver.value.firstWhereOrNull(
      (element) => element!.fullName == spinnerDriver.controller.textSelected.value,
    );
    DateTime? resultDate;
    if (dtDeliveryTime.getLastTimeSelectedText() != "00:00") {
      DateTime deliveryDate = DateFormat("dd/MM/yyyy").parse(dtDeliveryDate.getLastTimeSelectedText());
      DateFormat deliveryTime = DateFormat("HH:mm");
      resultDate = DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day, deliveryTime.parse(dtDeliveryTime.getLastTimeSelectedText()).hour, deliveryTime.parse(dtDeliveryTime.getLastTimeSelectedText()).minute);
    }

    Order orderRequest = Order(
      driverId: driverSelected!.id!,
      deliveryTime: resultDate != null ? Convert.getStringIso(resultDate) : orderDetail.value!.deliveryTime,
      withDeliveryFee: orderDetail.value!.deliveryFee != null ? true : false,
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
