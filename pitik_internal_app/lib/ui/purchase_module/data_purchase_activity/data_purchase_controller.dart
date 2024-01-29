///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/search_bar/search_bar.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/strings.dart';
import 'package:intl/intl.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/internal_app/vendor_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:model/response/internal_app/purchase_list_response.dart';
import 'package:model/response/internal_app/vendor_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class PurchaseController extends GetxController {
  BuildContext context;
  PurchaseController({required this.context});

  var page = 1.obs;
  var limit = 10.obs;
  Rx<List<Purchase?>> purchaseList = Rx<List<Purchase>>([]);

  var isLoading = false.obs;
  var isLoadMore = false.obs;

  ScrollController scrollController = ScrollController();

  scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        isLoadMore.value = true;
        page++;
        getListPurchase();
      }
    });
  }

  void getListPurchase() {
    Service.push(
        service: ListApi.getPurchaseOrderList,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, page.value, limit.value],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListPurchaseResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  purchaseList.value.add(result as Purchase);
                }
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  page.value = (purchaseList.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoading.value = false;
                }
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

  Timer? debounce;
  RxBool isFilter = false.obs;
  RxBool isSearch = false.obs;
  RxString searchValue = "".obs;
  Rx<Map<String, String>> listFilter = Rx<Map<String, String>>({});
  RxList<CategoryModel?> listCategory = RxList<CategoryModel>([]);
  RxList<Products?> listProduct = RxList<Products>([]);
  Rx<List<OperationUnitModel?>> listSourceJagal = Rx<List<OperationUnitModel>>([]);
  Rx<List<VendorModel?>> listSourceVendor = Rx<List<VendorModel>>([]);
  Rx<List<OperationUnitModel?>> listDestinationPurchase = Rx<List<OperationUnitModel>>([]);

  late SearchBarField sbSearch;

  DateTimeField dtTanggalPembelian = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController("dtTanggalPembelian"),
      label: "Tanggal Pembelian",
      hint: "dd MM yyyy",
      alertText: "",
      flag: 1,
      onDateTimeSelected: (date, dateField) {
        dateField.controller.setTextSelected(DateFormat("dd MMM yyyy", 'id').format(date));
      });

  late SpinnerField spCategory = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spCategoryFilter"),
      label: "Kategori SKU",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {},
      onSpinnerSelected: (value) {
        if (listCategory.isNotEmpty) {
          CategoryModel? selectCategory = listCategory.firstWhereOrNull((element) => element!.name! == value);
          if (selectCategory != null) {
            getSku(selectCategory.id!);
          }
        }
      });
  SpinnerField spSku = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spSkuFilter"), label: "SKU", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});

  SpinnerField spStatus = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spStatusFilter"),
      label: "Status",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {
        "Draft": false,
        "Terkonfirmasi": false,
        "Diterima": false,
        "Ditolak": false,
      },
      onSpinnerSelected: (value) {});

  SpinnerField spTujuan = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spTujuanFilterPembelian"), label: "Tujuan", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});
  late SpinnerField spJenisSumber = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spJenisSumberFilterPembelian"),
      label: "Jenis Sumber",
      hint: "Pilih Salah Satu",
      alertText: "",
      items: const {"Jagal Eksternal": false, "Vendor": false},
      onSpinnerSelected: (value) {
        if (value.isNotEmpty) {
          if (value == "Vendor") {
            getListSourceVendor();
          } else {
            getListJagalExternal();
          }
        }
      });
  SpinnerField spSumber = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spSumberFilterPembelian"), label: "Sumber", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});

  late ButtonFill btKormasiFilter = ButtonFill(controller: GetXCreator.putButtonFillController("btKormasiFilter"), label: "Konfirmasi Filter", onClick: () => saveFilter());

  late ButtonOutline btBersihkanFilter = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btBersihkanFilter"), label: "Bersihkan Filter", onClick: () => clearFilter());

  @override
  void onInit() {
    super.onInit();
    sbSearch = SearchBarField(
      controller: GetXCreator.putSearchBarController("purhcaseSearchBar"),
      items: const ["Nomor PO"],
      onTyping: (value, control) => searchOrder(value),
      onCategorySelected: (value) {},
      addPrefixDropdown: false,
    );
    scrollListener();
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    getListPurchase();
  }

  void getSku(String categoriId) {
    Service.push(
        service: ListApi.getProductById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, categoriId],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }
                for (var result in (body).data) {
                  listProduct.add(result);
                }
                spSku.controller.generateItems(mapList);
                spSku.controller.enable();
              } else {
                spSku.controller.disable();
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
            },
            onTokenInvalid: () {}));
  }

  void getListSourceVendor() {
    spSumber.controller
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
              for (var result in body.data) {
                listSourceVendor.value.add(result);
              }
              Timer(const Duration(milliseconds: 100), () {
                spSumber.controller
                  ..generateItems(mapList)
                  ..setTextSelected("")
                  ..hideLoading()
                  ..enable()
                  ..refresh();
              });
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
              spSumber.controller.hideLoading();
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan Internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              spSumber.controller.hideLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getListJagalExternal() {
    spSumber.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListJagalExternal,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, "JAGAL", "EXTERNAL"],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var customer in (body as ListOperationUnitsResponse).data) {
            mapList[customer!.operationUnitName!] = false;
          }
          for (var result in body.data) {
            listSourceJagal.value.add(result!);
          }
          Timer(const Duration(milliseconds: 100), () {
            spSumber.controller
              ..generateItems(mapList)
              ..setTextSelected("")
              ..hideLoading()
              ..enable()
              ..refresh();
          });
        }, onResponseFail: (code, message, body, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spSumber.controller.hideLoading();
        }, onResponseError: (exception, stacktrace, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan Internal",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spSumber.controller.hideLoading();
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
  }

  void getListDestinationPurchase() {
    spTujuan.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE, 0],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var customer in (body as ListOperationUnitsResponse).data) {
            mapList[customer!.operationUnitName!] = false;
          }
          spTujuan.controller.generateItems(mapList);

          for (var result in body.data) {
            listDestinationPurchase.value.add(result!);
          }
          spTujuan.controller.hideLoading();
          spTujuan.controller.enable();
          spTujuan.controller.refresh();
        }, onResponseFail: (code, message, body, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spTujuan.controller.hideLoading();
        }, onResponseError: (exception, stacktrace, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan Internal",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spTujuan.controller.hideLoading();
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
  }

  void getCategorySku() {
    spCategory.controller.disable();
    spCategory.controller.showLoading();
    spCategory.controller.setTextSelected("Loading...");
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as CategoryListResponse).data) {
              listCategory.add(result);
            }
            Map<String, bool> mapList = {};
            for (var product in body.data) {
              mapList[product!.name!] = false;
            }
            spCategory.controller.enable();
            if (listFilter.value["Kategori"] != null) {
              spCategory.controller.setTextSelected(listFilter.value["Kategori"]!);
            } else {
              spCategory.controller.setTextSelected("");
            }
            spCategory.controller.hideLoading();
            spCategory.controller.generateItems(mapList);
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
            spCategory.controller.disable();
            spCategory.controller.setTextSelected("");
            spCategory.controller.hideLoading();
          },
          onResponseError: (exception, stacktrace, id, packet) {
            Get.snackbar(
              "Pesan",
              "Terjadi KesalahanInternal",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            spCategory.controller.disable();
            spCategory.controller.setTextSelected("");
            spCategory.controller.hideLoading();
          },
          onTokenInvalid: Constant.invalidResponse()),
    );
  }

  void openFilter() {
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    if (spCategory.controller.textSelected.isNotEmpty) {
      spSku.controller.enable();
    }
    if (spSumber.controller.textSelected.isEmpty) {
      spSumber.controller.disable();
    }
    if (spJenisSumber.controller.textSelected.isNotEmpty) {
      spSumber.controller.enable();
    }
    getCategorySku();
    getListDestinationPurchase();
    showFilter();
  }

  showFilter() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.90,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
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
                      Expanded(
                        child: RawScrollbar(
                          //   controller: controller.scrollControllerInbound,
                          // thumbVisibility: true,
                          // trackVisibility: true,
                          thumbColor: AppColors.primaryOrange,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                dtTanggalPembelian,
                                spCategory,
                                spSku,
                                spTujuan,
                                spJenisSumber,
                                spSumber,
                                spStatus,
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: btKormasiFilter),
                        const SizedBox(width: 8),
                        Expanded(child: btBersihkanFilter),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void saveFilter() {
    if (validationFilter()) {
      sbSearch.controller.clearText();
      listFilter.value.clear();
      if (dtTanggalPembelian.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Pembelian"] = dtTanggalPembelian.controller.textSelected.value;
      }
      if (spStatus.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Status"] = spStatus.controller.textSelected.value;
      }
      if (spCategory.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Kategori"] = spCategory.controller.textSelected.value;
      }
      if (spSku.controller.textSelected.value.isNotEmpty) {
        listFilter.value["SKU"] = spSku.controller.textSelected.value;
      }
      if (spSumber.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Sumber"] = spSumber.controller.textSelected.value;
      }

      if (spTujuan.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Destination"] = spTujuan.controller.textSelected.value;
      }

      listFilter.refresh();
      Get.back();
      isFilter.value = true;
      isSearch.value = false;
      // TODO : API
    }
  }

  bool validationFilter() {
    if (spJenisSumber.controller.textSelected.value.isNotEmpty) {
      if (spSumber.controller.textSelected.value.isEmpty) {
        Get.snackbar(
          "Pesan",
          "Sumber harus diisi",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        spSumber.controller.showAlert();
        return false;
      }
    }
    return true;
  }

  void clearFilter() {
    listFilter.value.clear();
    listFilter.refresh();
    dtTanggalPembelian.controller.setTextSelected("");

    spStatus.controller.setTextSelected("");
    spCategory.controller.setTextSelected("");
    spSku.controller.setTextSelected("");
    spSku.controller.disable();
    spJenisSumber.controller.setTextSelected("");
    spSumber.controller.setTextSelected("");
    spTujuan.controller.setTextSelected("");
    Get.back();
    // TODO : API
  }

  void removeOneFilter(String key) {
    switch (key) {
      case "Tanggal Pembelian":
        dtTanggalPembelian.controller.setTextSelected("");
        break;
      case "Status":
        spStatus.controller.setTextSelected("");
        break;
      case "Kategori":
        spCategory.controller.setTextSelected("");
        spSku.controller.setTextSelected("");
        listFilter.value.remove("SKU");
        break;
      case "SKU":
        spSku.controller.setTextSelected("");
        break;
      case "Sumber":
        spSumber.controller.setTextSelected("");
        spJenisSumber.controller.setTextSelected("");
        break;
      case "Destination":
        spTujuan.controller.setTextSelected("");
        break;

      default:
    }

    listFilter.value.remove(key);
    listFilter.refresh();

    //TODO :: CALL API
  }

  void searchOrder(String text) {
    if (text.isNotEmpty) {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = true;
        isFilter.value = false;
        listFilter.value.clear();
        //TODO : API
      });
    } else {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = false;

        //TODO : API
      });
    }
  }
}

class PurchasePageBindings extends Bindings {
  BuildContext context;
  PurchasePageBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseController(context: context));
  }
}
