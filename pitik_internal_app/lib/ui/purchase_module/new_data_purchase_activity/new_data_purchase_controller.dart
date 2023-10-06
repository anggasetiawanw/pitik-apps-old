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
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_request.dart';
import 'package:model/internal_app/vendor_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/vendor_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase/sku_card_purchase.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase/sku_card_purchase_controller.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase_internal/sku_card_purchase_internal.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase_internal/sku_card_purchase_internal_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 10/04/23

class NewDataPurchaseController extends GetxController{
    BuildContext context;
    NewDataPurchaseController({required this.context});

    var isLoading = false.obs;
    var status = "".obs;
    var isInternal =false.obs;
    late ButtonFill iyaVisitButton;
    late ButtonOutline tidakVisitButton;

    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<List<OperationUnitModel?>> listSourceJagal = Rx<List<OperationUnitModel>>([]);
    Rx<List<VendorModel?>> listSourceVendor = Rx<List<VendorModel>>([]);
    Rx<List<OperationUnitModel?>> listDestinationPurchase = Rx<List<OperationUnitModel>>([]);

    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});


    late SpinnerField spinnerTypeSource  = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("typeSumberPembelian"),
        label: "Jenis Sumber*",
        hint: "Pilih salah satu",
        alertText: "Jenis sumber harus dipilih!",
        items: const {"Jagal External": false, "Vendor": false
        },
        onSpinnerSelected: (text) {
            if(text.isNotEmpty){
                spinnerSource.controller.enable();
                if(text == "Vendor" ){
                getListSourceVendor();
                
                } else {
                getListJagalExternal();
                }
            }
        }
    );

    late SpinnerField spinnerSource  = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("sumberPembelian"),
        label: "Sumber*",
        hint: "Pilih salah satu",
        alertText: "Sumber harus dipilih!",
        items: const {
        },
        onSpinnerSelected: (text) {
            if (text.isNotEmpty) {
                spinnerDestination.controller.enable();
                if(spinnerTypeSource.controller.textSelected.value == "Vendor"){
                    VendorModel? vendorSelected;
                    vendorSelected = listSourceVendor.value.firstWhere((element) => element!.vendorName == spinnerSource.controller.textSelected.value);
                    if(vendorSelected!.type == AppStrings.INTERNAL){
                        skuCard.controller.invisibleCard();
                        getCategorySkuInternal();
                        isInternal.value = true;
                    } else {
                        skuCardInternal.controller.invisibleCard();
                        getCategorySku();
                        isInternal.value = false;
                    }
                } else {
                    skuCardInternal.controller.invisibleCard();
                    getCategorySku();
                    isInternal.value = false;
                }
            }
        }
    );

    late SpinnerField spinnerDestination  = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("tujuanPembelian"),
        label: "Tujuan*",
        hint: "Pilih salah satu",
        alertText: "Tujuan harus dipilih!",
        items: const {
        },
        onSpinnerSelected: (text) {
        },
    );

    late SkuCardPurchase skuCard;
    late SkuCardPurchaseInternal skuCardInternal;
    @override
    void onInit() {
        getListDestinationPurchase();
        isLoading.value =true;
        spinnerDestination.controller.disable();
        spinnerSource.controller.disable();
        skuCard = SkuCardPurchase(
        controller: InternalControllerCreator.putSkuCardPurchaseController("skuPurchase",context ),
        );

        skuCardInternal = SkuCardPurchaseInternal(controller: InternalControllerCreator.putSkuCardPurchaseInternalController("skuInternalPuchar", context));

        tidakVisitButton = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("tidakPurchase"),
        label: "Tidak",
        onClick: () {
            Get.back();
        },
        );

        iyaVisitButton = ButtonFill(
        controller: GetXCreator.putButtonFillController("iyaPurchase"),
        label: "Ya",
        onClick: () {
            Get.back();
            savePurchase();
        },
        );
        super.onInit();
    }

    @override
    void onReady() {
        Get.find<SkuCardPurchaseController>(tag: "skuPurchase").idx.listen((p0) {
        generateListProduct(p0);
        });

        Get.find<SkuCardPurchaseInternalController>(tag: "skuInternalPuchar").idx.listen((p0) {
        generateListProductInternal(p0);
        });
        skuCard.controller.invisibleCard();
        skuCardInternal.controller.invisibleCard();
        isLoading.value = false;
        super.onReady();
    }


    void generateListProduct(int idx) {
        Timer(const Duration(milliseconds: 500), () {
            idx -=1;
        skuCard.controller.spinnerCategories.value[idx].controller
            .generateItems(mapList.value);
        });
    }

    void generateListProductInternal(int idx) {
        Timer(const Duration(milliseconds: 500), () {
            idx -=1;
        skuCardInternal.controller.spinnerCategories.value[idx].controller
            .generateItems(mapList.value);
        });
    }

    void getListSourceVendor() {
        spinnerSource.controller
        ..disable()
        ..showLoading();
        Service.push(
            service: ListApi.getListVendors,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    for (var vendor in (body as VendorListResponse).data) {
                    mapList[vendor!.vendorName!] = false;
                    }
                    Timer(const Duration(milliseconds: 500), () {
                        spinnerSource.controller.generateItems(mapList);
                    });
                    // spinnerSource.controller.enable();

                    for (var result in body.data) {
                        listSourceVendor.value.add(result);
                    }
                    spinnerSource.controller
                    ..setTextSelected("")
                    ..hideLoading()
                    ..enable()
                    ..refresh();
                },
                onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    spinnerSource.controller.hideLoading();
            },
                onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan Internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    spinnerSource.controller.hideLoading();
                },
                onTokenInvalid: Constant.invalidResponse()
                )
        );
    }
    void getListJagalExternal() {
        spinnerSource.controller
        ..disable()
        ..showLoading();
        Service.push(
            service: ListApi.getListJagalExternal,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, "JAGAL","EXTERNAL"],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                Map<String, bool> mapList = {};
                for (var customer in (body as ListOperationUnitsResponse).data) {
                  mapList[customer!.operationUnitName!] = false;
                }
                Timer(const Duration(milliseconds: 500), () {
                    spinnerSource.controller.generateItems(mapList);
                });

                for (var result in body.data) {
                    listSourceJagal.value.add(result!);
                }
                    spinnerSource.controller.setTextSelected("");
                    spinnerSource.controller.hideLoading();
                    spinnerSource.controller.enable();
                    spinnerSource.controller.refresh();

                },
                onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
            },
                onResponseError: (exception, stacktrace, id, packet) { 
                    Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan Internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    spinnerSource.controller.hideLoading();
                },
                onTokenInvalid: () {
                Constant.invalidResponse();
                }
                )
        );
    }
    void getListDestinationPurchase() {
        spinnerDestination.controller.disable();
        spinnerDestination.controller.showLoading();
        Service.push(
            service: ListApi.getListOperationUnits,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!,AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    for (var customer in (body as ListOperationUnitsResponse).data) {
                    mapList[customer!.operationUnitName!] = false;
                    }
                    spinnerDestination.controller.generateItems(mapList);

                    for (var result in body.data) {
                        listDestinationPurchase.value.add(result!);
                    }
                    spinnerDestination.controller.hideLoading();
                    spinnerDestination.controller.enable();
                    spinnerDestination.controller.refresh();

                },
                onResponseFail: (code, message, body, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    spinnerDestination.controller.hideLoading();
            },
                onResponseError: (exception, stacktrace, id, packet) {
                    Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan Internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    spinnerDestination.controller.hideLoading();
                },
                onTokenInvalid: () {
                Constant.invalidResponse();
                }
                )
        );
    }


    void getCategorySku() {
        Service.push(
        service: ListApi.getCategories,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {

                listCategories.value.clear();
                for (var result in (body as CategoryListResponse).data) {
                listCategories.value.add(result);
                }
                Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }
                skuCard
                    .controller
                    .spinnerCategories
                    .value[0]
                    .controller
                    .generateItems(mapList);

                skuCard.controller.setMaplist(listCategories.value);

                skuCard.controller.visibleCard();
                skuCardInternal.controller.invisibleCard();
                skuCard.controller.idx.refresh();
                this.mapList.value = mapList;
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
            },
            onTokenInvalid: Constant.invalidResponse()
        ),
        );
    }

    void getCategorySkuInternal() {
        Service.push(
        service: ListApi.getCategories,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
                listCategories.value.clear();
                for (var result in (body as CategoryListResponse).data) {
                listCategories.value.add(result);
                }
                Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }
                    skuCardInternal
                    .controller
                    .spinnerCategories
                    .value[0]
                    .controller
                    .generateItems(mapList);

                skuCardInternal.controller.setMaplist(listCategories.value);


                skuCardInternal.controller.visibleCard();
                skuCardInternal.controller.idx.refresh();
                this.mapList.value = mapList;
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
            },
            onTokenInvalid: Constant.invalidResponse()
        ),
        );
    }


    void savePurchase() {

        List ret = validation();
        if (ret[0]) {
        isLoading.value = true;
        PurchaseRequest purchasePayload = generatePayload();
        Service.push(
            service: ListApi.createPurchase,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, Mapper.asJsonString(purchasePayload)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.back();
                },
                onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                },
                onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                Get.snackbar("Alert","Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                },
                onTokenInvalid: () {
                Constant.invalidResponse();
                }
            ),
        );
        }
    }

    PurchaseRequest generatePayload() {
        List<Products?> listProductPayload = [];

        VendorModel? vendorSelected;
        OperationUnitModel? jagalSelected;
        if(spinnerTypeSource.controller.textSelected.value == "Vendor"){
        vendorSelected = listSourceVendor.value.firstWhere(
                (element) => element!.vendorName == spinnerSource.controller.textSelected.value);
        }else{
        jagalSelected = listSourceJagal.value.firstWhere(
                (element) => element!.operationUnitName == spinnerSource.controller.textSelected.value);
        }
        if(vendorSelected?.type == AppStrings.INTERNAL && spinnerTypeSource.controller.textSelected.value == "Vendor"){
            for (int i = 0; i < skuCardInternal.controller.itemCount.value; i++) {
                int whichItem = skuCardInternal.controller.index.value[i];
                // CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == skuCardInternal.controller.spinnerCategories.value[whichItem].controller.textSelected.value);
                var listProductTemp = skuCardInternal.controller.listSku.value.values.toList();
                Products? productSelected = listProductTemp[whichItem].firstWhere((element) => element!.name! == skuCardInternal.controller.spinnerSku.value[whichItem].controller.textSelected.value);
                listProductPayload.add(Products(
                    productItemId: productSelected!.id,
                    quantity: skuCardInternal.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCardInternal.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
                    price: skuCardInternal.controller.editFieldHarga.value[whichItem].getInputNumber() ?? 0,
                    weight: skuCardInternal.controller.editFieldKebutuhan.value[whichItem].getInputNumber(),
                ));
            }
        } else {
            for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
            int whichItem = skuCard.controller.index.value[i];
            // CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == skuCard.controller.spinnerCategories.value[whichItem].controller.textSelected.value);
            var listProductTemp = skuCard.controller.listSku.value.values.toList();
            Products? productSelected = listProductTemp[whichItem].firstWhere((element) => element!.name! == skuCard.controller.spinnerSku.value[whichItem].controller.textSelected.value);
            listProductPayload.add(Products(
                productItemId: productSelected!.id,
                quantity: skuCard.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCard.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
                price: skuCard.controller.editFieldHarga.value[whichItem].getInputNumber(),
                weight: skuCard.controller.editFieldKebutuhan.value[whichItem].getInputNumber(),
            ));
            }
        }


        OperationUnitModel? destinationPurchaseSelected = listDestinationPurchase.value.firstWhere(
            (element) => element!.operationUnitName == spinnerDestination.controller.textSelected.value,
        );

        return PurchaseRequest(
        vendorId: vendorSelected == null ? null : vendorSelected.id!,
        jagalId: jagalSelected?.id,
        operationUnitId: destinationPurchaseSelected!.id!,
        products: listProductPayload,
        status: status.value,
        );
    }


    List validation() {
        List ret = [true, ""];

        if (spinnerSource.controller.textSelected.value.isEmpty) {
        spinnerSource.controller.showAlert();
        Scrollable.ensureVisible(spinnerSource.controller.formKey.currentContext!);
        return ret = [false, ""];
        }
        if (spinnerDestination.controller.textSelected.value.isEmpty) {
        spinnerDestination.controller.showAlert();
        Scrollable.ensureVisible(spinnerDestination.controller.formKey.currentContext!);

        return ret = [false, ""];
        }
        if(spinnerTypeSource.controller.textSelected.value == "Vendor"){
            VendorModel? vendorSelected;
            vendorSelected = listSourceVendor.value.firstWhere((element) => element!.vendorName == spinnerSource.controller.textSelected.value);
            if(vendorSelected!.type == "EXTERNAL"){
                ret = skuCard.controller.validation();
            } else {
                skuCardInternal.controller.validation();
            }
        } else {
            ret = skuCard.controller.validation();
        }
        return ret;
    }
}

class NewDataPurchaseBindings extends Bindings {
  BuildContext context;
  NewDataPurchaseBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => NewDataPurchaseController(context: context));
  }

}