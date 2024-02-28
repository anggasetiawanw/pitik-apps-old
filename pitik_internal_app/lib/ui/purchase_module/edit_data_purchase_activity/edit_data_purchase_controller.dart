import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:dao_impl/user_google_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/internal_app/vendor_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/vendor_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase/sku_card_purchase.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase/sku_card_purchase_controller.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase_internal/sku_card_purchase_internal.dart';
import 'package:pitik_internal_app/widget/sku_card_purchase_internal/sku_card_purchase_internal_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 16/05/23

class EditDataPurchaseController extends GetxController {
  BuildContext context;
  EditDataPurchaseController({required this.context});

  var isLoading = false.obs;
  var isLoadData = false.obs;
  var status = "".obs;
  late ButtonFill iyaVisitButton;
  late ButtonOutline tidakVisitButton;
  var sumWeight = 0.obs;
  var sumChick = 0.obs;
  var sumPrice = 0.obs;
  var isInternal = false.obs;

  late Purchase purchaseDetail;
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
  Rx<List<VendorModel?>> listSourceVendor = Rx<List<VendorModel>>([]);
  Rx<List<OperationUnitModel?>> listSourceJagal = Rx<List<OperationUnitModel>>([]);
  Rx<List<OperationUnitModel?>> listDestinationPurchase = Rx<List<OperationUnitModel>>([]);

  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  late SpinnerField spinnerTypeSource = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("typeSumberPembelian"),
      label: "Jenis Sumber*",
      hint: "Pilih salah satu",
      alertText: "Jenis sumber harus dipilih!",
      items: const {"Jagal External": false, "Vendor": false},
      onSpinnerSelected: (text) {
        if (text.isNotEmpty) {
          spinnerSource.controller.enable();
          spinnerSource.controller.setTextSelected("");
          if (text == "Vendor") {
            getListSourceVendor();
          } else {
            getListJagalExternal();
          }
        }
      });

  late SpinnerField spinnerSource = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("sumberPembelian"),
    label: "Sumber*",
    hint: "Pilih salah satu",
    alertText: "Sumber harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {
        spinnerDestination.controller.enable();
        if (spinnerTypeSource.controller.textSelected.value == "Vendor") {
          VendorModel? vendorSelected;
          vendorSelected = listSourceVendor.value.firstWhereOrNull((element) => element!.vendorName == spinnerSource.controller.textSelected.value);
          if (vendorSelected!.type == AppStrings.INTERNAL) {
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
    },
  );

  late SpinnerField spinnerDestination = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("tujuanPembelian"),
    label: "Tujuan*",
    hint: "Pilih salah satu",
    alertText: "Tujuan harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {},
  );

  EditField efTotalKG = EditField(controller: GetXCreator.putEditFieldController("efTotalKGPO"), label: "Total/Global(Kg)*", hint: "Ketik di sini", alertText: "Total Kg harus diisi", textUnit: "Kg", maxInput: 20, inputType: TextInputType.number, onTyping: (value, editField) {});

  EditField efRemark = EditField(controller: GetXCreator.putEditFieldController("efRemark"), label: "Catatan", hint: "Ketik disini", alertText: "", textUnit: "", maxInput: 500, inputType: TextInputType.multiline, height: 160, onTyping: (value, editField) {});

  late SkuCardPurchase skuCard;
  late SkuCardPurchaseInternal skuCardInternal;


  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    spinnerDestination.controller.disable();
    purchaseDetail = Get.arguments;
    isLoading.value = true;
    getListDestinationPurchase();
    spinnerDestination.controller.disable();
    skuCard = SkuCardPurchase(
      controller: InternalControllerCreator.putSkuCardPurchaseController("skuPurchase", context),
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
        Constant.track("Click_Simpan_Konfirmasi_Pembelian");
        Get.back();
        editPurchase();

      },
    );
  }

  @override
  void onReady() async {
    Get.find<SkuCardPurchaseController>(tag: "skuPurchase").idx.listen((p0) {
      generateListProduct(p0);
    });

    Get.find<SkuCardPurchaseInternalController>(tag: "skuInternalPuchar").idx.listen((p0) {
      generateListProductInternal(p0);
    });
    skuCard.controller.invisibleCard();
    skuCardInternal.controller.invisibleCard();
    await loadData(purchaseDetail);
    super.onReady();
  }

  void generateListProduct(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx = idx - 1;
      skuCard.controller.spinnerCategories.value[idx].controller.generateItems(mapList.value);
    });
  }

  void generateListProductInternal(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx -= 1;
      skuCardInternal.controller.spinnerCategories.value[idx].controller.generateItems(mapList.value);
    });
  }

  void getListSourceVendor() {
    isLoading.value = true;
    Service.push(
        service: ListApi.getListVendors,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
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
          isLoading.value = false;
          timeEnd = DateTime.now();
          Duration totalTime = timeEnd.difference(timeStart);
          Constant.trackWithMap("Render_Time", {'Page': "Edit_Pembelian", 'value': "${totalTime.inHours} hours : ${totalTime.inMinutes} minutes : ${totalTime.inSeconds} seconds : ${totalTime.inMilliseconds} miliseconds"});
        }, onResponseFail: (code, message, body, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          isLoading.value = false;
        }, onResponseError: (exception, stacktrace, id, packet) {
          isLoading.value = false;
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
  }

  void getListJagalExternal() {
    isLoading.value = true;
    Service.push(
        service: ListApi.getListJagalExternal,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, "JAGAL", "EXTERNAL"],
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
            onResponseError: (exception, stacktrace, id, packet) {},
            onTokenInvalid: () {
              Constant.invalidResponse();
            }));
  }

  void getListDestinationPurchase() {
    spinnerDestination.controller.disable();
    spinnerDestination.controller.showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE,0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var customer in (body as ListOperationUnitsResponse).data) {
                mapList[customer!.operationUnitName!] = false;
              }
              spinnerDestination.controller.generateItems(mapList);
              spinnerDestination.controller.enable();

              for (var result in body.data) {
                listDestinationPurchase.value.add(result!);
              }
              spinnerDestination.controller.hideLoading();
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
            onResponseError: (exception, stacktrace, id, packet) {},
            onTokenInvalid: () {
              Constant.invalidResponse();
            }));
  }

  void getCategorySku() {
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as CategoryListResponse).data) {
              listCategories.value.add(result);
            }
            Map<String, bool> mapList = {};
            for (var product in body.data) {
              mapList[product!.name!] = false;
            }
            skuCard.controller.spinnerCategories.value[0].controller.generateItems(mapList);

            skuCard.controller.setMaplist(listCategories.value);
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
          onResponseError: (exception, stacktrace, id, packet) {},
          onTokenInvalid: () {
            AuthImpl().delete(null, []);
            UserGoogleImpl().delete(null, []);
            Get.offNamed(RoutePage.loginPage);
          }),
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
            skuCardInternal.controller.spinnerCategories.value[0].controller.generateItems(mapList);

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
          onResponseError: (exception, stacktrace, id, packet) {},
          onTokenInvalid: Constant.invalidResponse()),
    );
  }

  Future<void> loadData(Purchase purchase) async {
    isLoadData.value = true;
    spinnerTypeSource.controller.setTextSelected(purchase.vendor == null ? "Jagal External" : "Vendor");
    Timer(const Duration(milliseconds: 100), () {
      String source = purchase.vendor != null ? purchase.vendor!.name! : purchase.jagal!.operationUnitName!;
      spinnerSource.controller.setTextSelected(source);
    });
    spinnerDestination.controller.setTextSelected(purchase.operationUnit!.operationUnitName!);
    efRemark.setInput(purchase.remarks != null ? Uri.decodeFull(purchase.remarks! ): "");
    efTotalKG.setInput((purchase.totalWeight ?? 0).toString());
    if (purchase.vendor != null) {
      getListSourceVendor();
      if (purchase.vendor!.type == AppStrings.INTERNAL) {
        getCategorySkuInternal();
        isInternal.value = true;
        skuCardInternal.controller.visibleCard();
        generateSku(purchase.products ?? [], skuCardInternal);
      } else {
        getCategorySku();
        isInternal.value = false;
        skuCard.controller.visibleCard();
        generateSku(purchase.products ?? [], skuCard);
      }
    } else {
      getListJagalExternal();
      getCategorySku();
      isInternal.value = false;
      skuCard.controller.visibleCard();
      generateSku(purchase.products ?? [], skuCard);
    }
  }

  generateSku(List<Products?> listProduct, var sku) async {
    if (listProduct.isNotEmpty) {
      for (int i = 0; i < listProduct.length - 1; i++) {
        sku.controller.addCard();
      }
      Timer(Duration.zero, () async {
        Map<String, bool> listKebutuhan = {};
        for (var product in listCategories.value) {
          listKebutuhan[product!.name!] = false;
        }

        for (int j = 0; j < listProduct.length; j++) {
          sku.controller.spinnerCategories.value[j].controller.setTextSelected(listProduct[j]!.category!.name!);
          sku.controller.spinnerCategories.value[j].controller.generateItems(listKebutuhan);
          sku.controller.spinnerSku.value[j].controller.setTextSelected(listProduct[j]!.name!);
          sku.controller.editFieldJumlahAyam.value[j].setInput(listProduct[j]!.quantity!.toString());
          sku.controller.editFieldKebutuhan.value[j].setInput((listProduct[j]!.weight ?? 0).toString());
          sku.controller.editFieldHarga.value[j].setInput(listProduct[j]!.price!.toString());
          sku.controller.listSku.value[j] = listProduct;
          sku.controller.mapSumChick[j] = sku.controller.editFieldJumlahAyam.value[j].getInputNumber()!;
          sku.controller.mapSumNeeded[j] = sku.controller.editFieldKebutuhan.value[j].getInputNumber()!;
          sku.controller.mapSumPrice[j] = sku.controller.editFieldHarga.value[j].getInputNumber()!;

          Timer(const Duration(milliseconds: 500), () {
            CategoryModel? selectCategory = listCategories.value.firstWhereOrNull((element) => element!.name! == sku.controller.spinnerCategories.value[j].controller.textSelected.value);
            sku.controller.getLoadSku(selectCategory!, j);
            if (sku.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.LIVE_BIRD || sku.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.AYAM_UTUH || sku.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.BRANGKAS || sku.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.KARKAS) {
              sku.controller.editFieldJumlahAyam.value[j].controller.visibleField();
            } else {
              sku.controller.editFieldKebutuhan.value[j].controller.visibleField();
            }
            sku.controller.editFieldHarga.value[j].controller.visibleField();

            sku.controller.refreshtotalPurchase();
          });
        }
        isLoadData.value = false;
      });
    }
  }

  void editPurchase() {
    List ret = validation();
    if (ret[0]) {
      isLoading.value = true;
      Purchase purchasePayload = generatePayload();
      Service.push(
        service: ListApi.editPurchase,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathEditPurchase(purchaseDetail.id!), Mapper.asJsonString(purchasePayload)],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          isLoading.value = false;
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

  Purchase generatePayload() {
    List<Products?> listProductPayload = [];

    VendorModel? vendorSelected;
    OperationUnitModel? jagalSelected;
    if (spinnerTypeSource.controller.textSelected.value == "Vendor") {
      vendorSelected = listSourceVendor.value.firstWhereOrNull((element) => element!.vendorName == spinnerSource.controller.textSelected.value);
    } else {
      jagalSelected = listSourceJagal.value.firstWhereOrNull((element) => element!.operationUnitName == spinnerSource.controller.textSelected.value);
    }
    if (vendorSelected?.type == AppStrings.INTERNAL && spinnerTypeSource.controller.textSelected.value == "Vendor") {
      for (int i = 0; i < skuCardInternal.controller.index.value.length; i++) {
        int whichItem = skuCardInternal.controller.index.value[i];
        // CategoryModel? selectCategory = listCategories.value.firstWhereOrNull((element) => element!.name! == skuCardInternal.controller.spinnerCategories.value[whichItem].controller.textSelected.value);
        var listProductTemp = skuCardInternal.controller.listSku.value.values.toList();
        Products? productSelected = listProductTemp[whichItem].firstWhereOrNull((element) => element!.name! == skuCardInternal.controller.spinnerSku.value[whichItem].controller.textSelected.value);
        listProductPayload.add(Products(
          productItemId: productSelected!.id,
          quantity: skuCardInternal.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCardInternal.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
          price: skuCardInternal.controller.editFieldHarga.value[whichItem].getInputNumber() ?? 0,
          weight: skuCardInternal.controller.editFieldKebutuhan.value[whichItem].getInputNumber() ?? 0,
        ));
      }
    } else {
      for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
        int whichItem = skuCard.controller.index.value[i];
        // CategoryModel? selectCategory = listCategories.value.firstWhereOrNull((element) => element!.name! == skuCard.controller.spinnerCategories.value[whichItem].controller.textSelected.value);
        var listProductTemp = skuCard.controller.listSku.value.values.toList();
        Products? productSelected = listProductTemp[whichItem].firstWhereOrNull((element) => element!.name! == skuCard.controller.spinnerSku.value[whichItem].controller.textSelected.value);
        listProductPayload.add(Products(
          productItemId: productSelected!.id,
          quantity: skuCard.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCard.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
          price: skuCard.controller.editFieldHarga.value[whichItem].getInputNumber(),
          weight: skuCard.controller.editFieldKebutuhan.value[whichItem].getInputNumber() ?? 0,
        ));
      }
    }

    OperationUnitModel? destinationPurchaseSelected = listDestinationPurchase.value.firstWhereOrNull(
      (element) => element!.operationUnitName == spinnerDestination.controller.textSelected.value,
    );

    return Purchase(
      vendorId: vendorSelected?.id,
      jagalId: jagalSelected?.id,
      operationUnitId: destinationPurchaseSelected!.id!,
      products: listProductPayload,
      status: status.value,
      totalWeight: efTotalKG.getInputNumber(),
      remarks: Uri.encodeFull(efRemark.getInput()),
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
    if (efTotalKG.getInput().isEmpty) {
      efTotalKG.controller.showAlert();
      Scrollable.ensureVisible(efTotalKG.controller.formKey.currentContext!);

      return ret = [false, ""];
    }
    if (spinnerTypeSource.controller.textSelected.value == "Vendor") {
      VendorModel? vendorSelected;
      vendorSelected = listSourceVendor.value.firstWhereOrNull((element) => element!.vendorName == spinnerSource.controller.textSelected.value);
      if (vendorSelected!.type == "EXTERNAL") {
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

class EditDataPurchaseBindings extends Bindings {
  BuildContext context;
  EditDataPurchaseBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => EditDataPurchaseController(context: context));
  }
}
