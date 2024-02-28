import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../widget/internal_controller_creator.dart';
import '../../../widget/sku_reject_so/sku_reject.dart';

class DeliveryRejectSOController extends GetxController {
  BuildContext context;
  DeliveryRejectSOController({required this.context});
  late SkuReject skuReject;
  var isLoading = false.obs;
  late Order order;
  late DateTime createdDate;
  var sumChick = 0.obs;
  var sumKg = 0.0.obs;
  var sumPrice = 0.0.obs;
  SpinnerField remarkField = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController('remarksss'),
      label: 'Alasan',
      hint: 'Pilih Salah Satu',
      alertText: '',
      items: const {
        'Pengiriman telat': false,
        'Ukuran ayam tidak sesuai': false,
        'Potongan tidak sesuai': false,
        'Kualitas buruk': false,
        'Lainnya': false,
      },
      onSpinnerSelected: (value) {});

  late ButtonFill yesSendItem = ButtonFill(
      controller: GetXCreator.putButtonFillController('yesSendItem'),
      label: 'Ya',
      onClick: () {
        Constant.track('Click_Tolak_Konirmasi_Pengiriman_Sales_Order');
        Get.back();
        confirmed();
      });

  ButtonOutline noSendItem = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('noSendItem'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      });
  @override
  void onInit() {
    super.onInit();
    order = Get.arguments;
    createdDate = Convert.getDatetime(order.createdDate!);
    skuReject = SkuReject(controller: InternalControllerCreator.putSkuCardRejectSO('SkuReject', order.products!));
  }

  @override
  void onReady() {
    super.onReady();
    getTotalQuantity(order);
  }

  void getTotalQuantity(Order? data) {
    sumChick.value = 0;
    sumKg.value = 0;
    sumPrice.value = 0;
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
          sumKg.value += product.weight! - product.returnWeight!;
          sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
        } else {
          sumKg.value += product.weight! - product.returnWeight!;
          sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
        }
      }
    }
  }

  void confirmed() {
    if (validation()) {
      isLoading.value = true;
      Service.push(
          service: ListApi.deliveryConfirmSO,
          context: context,
          body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathDeliveryRejectSO(order.id!), Mapper.asJsonString(generatePayload())],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Get.back();
                isLoading.value = false;
              },
              onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                  'Pesan',
                  'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                isLoading.value = false;
              },
              onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                  'Pesan',
                  'Terjadi kesalahan internal',
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

  bool validation() {
    bool isCheckEach = false;
    for (int index = 0; index < skuReject.controller.index.value.length; index++) {
      if (skuReject.controller.selectedValue.value[index]) {
        isCheckEach = true;
        if (order.products![index]!.category!.name == AppStrings.LIVE_BIRD || order.products![index]!.category!.name! == AppStrings.AYAM_UTUH || order.products![index]!.category!.name! == AppStrings.BRANGKAS) {
          if (skuReject.controller.jumlahEkorDitolak.value[index].getInput().isEmpty) {
            skuReject.controller.jumlahEkorDitolak.value[index].controller.showAlert();
            Scrollable.ensureVisible(skuReject.controller.jumlahEkorDitolak.value[index].controller.formKey.currentContext!);
            return false;
          }
        }
        if (skuReject.controller.jumlahKgDitolak.value[index].getInput().isEmpty) {
          skuReject.controller.jumlahKgDitolak.value[index].controller.showAlert();
          Scrollable.ensureVisible(skuReject.controller.jumlahKgDitolak.value[index].controller.formKey.currentContext!);
          return false;
        }
      }
    }
    if (!isCheckEach) {
      Get.snackbar(
        'Pesan',
        'Jika melakukan penolakan minimal memilih 1 produk dikembalikan',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    return true;
  }

  Order generatePayload() {
    final List<Products?> products = [];
    for (int index = 0; index < skuReject.controller.index.value.length; index++) {
      if (skuReject.controller.selectedValue.value[index]) {
        products.add(Products(
          productItemId: skuReject.controller.products[index]!.id!,
          quantity: order.products![index]!.category!.name == AppStrings.LIVE_BIRD || order.products![index]!.category!.name! == AppStrings.AYAM_UTUH || order.products![index]!.category!.name! == AppStrings.BRANGKAS
              ? skuReject.controller.jumlahEkorDitolak.value[index].getInputNumber()!.toInt()
              : null,
          weight: skuReject.controller.jumlahKgDitolak.value[index].getInputNumber(),
        ));
      }
    }

    return Order(reason: remarkField.controller.textSelected.value, returnedProducts: products);
  }
}

class DeliveryRejectSOBindings extends Bindings {
  BuildContext context;
  DeliveryRejectSOBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => DeliveryRejectSOController(context: context));
  }
}
