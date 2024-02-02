import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/location_permission.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/strings.dart';
import 'package:global_variable/text_style.dart';
import 'package:lottie/lottie.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/checkin_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/so_status.dart';
import 'package:pitik_internal_app/widget/common/checkin_component.dart';
class DeliveryConfirmSOController extends GetxController {
    BuildContext context;
    DeliveryConfirmSOController({required this.context});
    double? latitude;
    double? longitude;
    var isLoading = false.obs;
    var sumChick = 0.obs;
    var sumKg =0.0.obs;
    var sumPrice = 0.0.obs;
    var showErrorCheckin = false.obs;
    var isSuccessCheckin = false.obs;
    var isLoadCheckin = false.obs;
    var error = "".obs;
    late ButtonFill confirButton = ButtonFill(controller: GetXCreator.putButtonFillController("confirDeliveryConfirm"), label: "Konfirmasi", onClick: (){
        _showBottomDialog();
    });

    SpinnerField paymentMethod = SpinnerField(controller: GetXCreator.putSpinnerFieldController("paymentDelivery"), label: "Metode Pembayaran*", hint: "Pilih Salah Satu", alertText: "Harus dipilih salah satu!", items: const {"Tunai" : false, "Transfer" : false}, onSpinnerSelected: (value){});
    EditField nominalMoney = EditField(controller: GetXCreator.putEditFieldController("nominalDelivery"), label: "Nominal Uang*", hint: "Tulis Jumlah", alertText: "Nominal Uang harus diisi!", textUnit: "", maxInput: 20,textPrefix: AppStrings.PREFIX_CURRENCY_IDR,inputType: TextInputType.number, onTyping: (value,control){if(control.getInput().length < 4){
            control.controller.setAlertText("Harga Tidak Valid!");
            control.controller.showAlert();
          }});

    late ButtonFill yesSendItem = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesSendItemadssd"),
      label: "Ya",
      onClick: (){
        Get.back();
        isLoading.value =true;
        konfirmasi();
      }
    );
    ButtonOutline noSendItem = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("noSendItemasdsd"),
      label: "Tidak",
      onClick: (){
        Get.back();
      }
    );

    late ButtonOutline checkinButton = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("ButtonCheckindssd"),
    label: "Checkin",
    isHaveIcon: true,
    onClick: () async {
        Constant.track("Click_Checkin_Pengiriman_Sales_Order");
        isLoadCheckin.value = true;
        final hasPermission = await handleLocationPermission();
        if (hasPermission){
            const timeLimit = Duration(seconds: 15);
            await FlLocation.getLocation(timeLimit: timeLimit,accuracy: LocationAccuracy.high).then((position) {
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
                            ListApi.pathCheckinDeliverySalesOrder(order.id!),
                            Mapper.asJsonString(CheckInModel(latitude:position.latitude, longitude: position.longitude ))
                        ],
                       listener:  ResponseListener(
                            onResponseDone: (code, message, body, id, packet) {
                                latitude = position.latitude;
                                longitude = position.longitude;
                                GpsComponent.checkinSuccess();
                                isLoadCheckin.value = false;
                                confirButton.controller.enable();
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
                }).onError((errors, stackTrace) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan gps timeout, tidak bisa mendapatkan lokasi",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    FirebaseCrashlytics.instance.recordError("Errors On GPS : $errors", stackTrace, fatal: false);
                    FirebaseCrashlytics.instance.log("Errors On GPS : $errors");
                    error.value = "Terjadi Kesalahan gps timeout, tidak bisa mendapatkan lokasi";
                    GpsComponent.failedCheckin(error.value);
                    isLoadCheckin.value = false;
                    isSuccessCheckin.value = false;
                    showErrorCheckin.value = true;
                });
            } else  {
                isLoadCheckin.value = false;
            }
        });

    late Order order;
    late DateTime createdDate;

    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

    @override
    void onInit() {
        isLoading.value = true;
        super.onInit();
        order = Get.arguments;
        createdDate = Convert.getDatetime(order.createdDate!);
        confirButton.controller.disable();
         getTotalQuantity(order);
    }
    @override
    void onReady() {
        super.onReady();
        WidgetsBinding.instance.addPostFrameCallback((_) {
           isLoading.value = false;
           timeEnd = DateTime.now();
            Duration difference = timeEnd.difference(timeStart);
            Constant.trackRenderTime("Terkirim_Pengiriman_Sales_Order", difference);
        });

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
                if(order.returnStatus == EnumSO.returnedPartial){
                    if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS || product.category!.name! == AppStrings.KARKAS) {
                    sumChick.value += product.quantity! - product.returnQuantity!;
                    sumKg.value += (product.weight! - product.returnWeight!);
                    sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
                    } else {
                    sumKg.value += (product.weight! - product.returnWeight!);
                    sumPrice.value += (product.weight! - product.returnWeight!) * product.price!;
                    }
                } else {
                    if (product.category!.name! == AppStrings.LIVE_BIRD || product.category!.name! == AppStrings.AYAM_UTUH || product.category!.name! == AppStrings.BRANGKAS|| product.category!.name! == AppStrings.KARKAS) {
                        sumChick.value += product.returnQuantity!;
                        sumKg.value += product.returnWeight!;
                        sumPrice.value += product.returnWeight! * product.price!;
                    } else {
                        sumKg.value += product.returnWeight!;
                        sumPrice.value += product.returnWeight! * product.price!;
                    }
                }
            }
        }
    }

    void konfirmasi(){
        Constant.track("Click_Konfirmasi_Pengiriman_Sales_Order");
        if(validation()){
            isLoading.value = true;
            Service.push(
                service: ListApi.deliveryConfirmSO,
                context: context,
                body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId,ListApi.pathDeliveryConfirmSO(order.id!), Mapper.asJsonString(Order(
                    paymentMethod: paymentMethod.controller.textSelected.value == "Tunai" ? "CASH" : "TRANSFER",
                    paymentAmount: nominalMoney.getInputNumber()!.toInt(),
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
                            "Terjadi Kesalahan, $stacktrace",
                            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,);
                        isLoading.value = false;
                    },
                    onTokenInvalid: Constant.invalidResponse()));
        }
    }

    bool validation(){
        if(paymentMethod.controller.textSelected.value.isEmpty){
            paymentMethod.controller.showAlert();
            Scrollable.ensureVisible(paymentMethod.controller.formKey.currentContext!);
            return false;
        }

        if (nominalMoney.getInput().length < 4) {
            nominalMoney.controller.setAlertText("Harga Tidak Valid!");
            nominalMoney.controller.showAlert();
            Scrollable.ensureVisible(nominalMoney.controller.formKey.currentContext!);
            return false;
        }

        if(longitude == null || latitude == null) {
            return false;
        }

        return true;
    }

  _showBottomDialog() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text(
                    "Apakah kamu yakin data yang dimasukan sudah benar?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan semua data yang kamu masukan semua sudah benar",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Lottie.asset(
                    'images/yakin.json',
                    height: 140,
                    width: 130,
                    fit: BoxFit.cover,
                )),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: yesSendItem),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: noSendItem
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }
}

class DeliveryConfirmSOBindings extends Bindings {
    BuildContext context;
    DeliveryConfirmSOBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DeliveryConfirmSOController(context: context));
    }
}