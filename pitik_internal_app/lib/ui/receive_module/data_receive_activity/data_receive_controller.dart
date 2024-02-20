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
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/internal_app/vendor_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:model/response/internal_app/purchase_list_response.dart';
import 'package:model/response/internal_app/sales_order_list_response.dart';
import 'package:model/response/internal_app/transfer_list_response.dart';
import 'package:model/response/internal_app/vendor_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/controllers/tab_receive_controller.dart';

part 'data_receive_controller.purchase.dart';
part 'data_receive_controller.sales_order.dart';
part 'data_receive_controller.transfer.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23
///

enum BodyQueryPurhcase { token, auth, xAppId, page, limit, statusConfirmed, statusReceived, withinProductionTeam, createdDate, productCategoryId, productItemId, operationUnitId, vendorId, jagalId, status, source, code }

enum BodyQueryTransfer { token, auth, xAppId, page, limit, statusReceived, statusDelivered, withinProductionTeam, createdDate, productCategoryId, productItemId, sourceOperationUnitId, targetOperationUnitId, status, code, source }

enum BodyQueryReturn { token, auth, xAppId, page, limit, statusReceived, statusDelivered, category, withinProductionTeam, createdDate, productCategoryId, productItemId, operationUnitId, status, returnStatus, code }

class ReceiveController extends GetxController {
  BuildContext context;

  final TabReceiveController tabController = Get.put(TabReceiveController());

  ReceiveController({required this.context});

  var pagePurchase = 1.obs;
  var pageTransfer = 1.obs;
  var pageOrder = 1.obs;
  var limit = 10.obs;
  Rx<List<Purchase?>> listPurchase = Rx<List<Purchase>>([]);
  Rx<List<TransferModel?>> listTransfer = Rx<List<TransferModel>>([]);
  Rx<List<Order?>> listReturn = Rx<List<Order>>([]);
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
  Rx<Map<String, String>> listFilter = Rx<Map<String, String>>({});
  RxList<CategoryModel?> listCategory = RxList<CategoryModel>([]);
  RxList<Products?> listProduct = RxList<Products>([]);
  Rx<List<OperationUnitModel?>> listSourceJagal = Rx<List<OperationUnitModel>>([]);
  Rx<List<VendorModel?>> listSourceVendor = Rx<List<VendorModel>>([]);
  Rx<List<OperationUnitModel?>> listDestinationPurchase = Rx<List<OperationUnitModel>>([]);
  Rx<List<OperationUnitModel?>> listSourceOperationUnits = Rx<List<OperationUnitModel?>>([]);
  Rx<List<OperationUnitModel?>> listDestinationOperationUnits = Rx<List<OperationUnitModel?>>([]);

  RxList<dynamic> bodyGeneralPurhcase = RxList<dynamic>(List.generate(BodyQueryPurhcase.values.length, (index) => null));
  RxList<dynamic> bodyGeneralTransfer = RxList<dynamic>(List.generate(BodyQueryTransfer.values.length, (index) => null));
  RxList<dynamic> bodyGeneralReturn = RxList<dynamic>(List.generate(BodyQueryReturn.values.length, (index) => null));

  var isLoadingPurchase = false.obs;
  var isLoadingTransfer = false.obs;
  var isLoadingOrder = false.obs;
  var isLoadMore = false.obs;
  RxBool isFilter = false.obs;
  RxBool isSearch = false.obs;
  RxBool isPurhcase = true.obs;
  RxBool isTransfer = false.obs;
  RxBool isOrderReturn = false.obs;

  Timer? debouncer;

  ScrollController scrollPurchaseController = ScrollController();
  ScrollController scrollTransferController = ScrollController();
  ScrollController scrollOrderController = ScrollController();

  RxMap<String, bool> mapStatusPo = RxMap<String, bool>({
    "Terkonfirmasi": false,
    "Diterima": false,
    "Dibatalkan": false,
  });

  RxMap<String, bool> mapStatusTransfer = RxMap<String, bool>({
    "Terkirim": false,
    "Diterima": false,
  });

  RxMap<String, bool> mapStatusReturn = RxMap<String, bool>({
    "Ditolak": false,
    "Terkirim Sebagian": false,
    "Diterima": false,
  });

  DateTimeField dtTanggalFilterReceive = DateTimeField(
      controller: GetXCreator.putDateTimeFieldController("dtTanggalFilterReceive"),
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

  SpinnerField spStatus = SpinnerField(controller: GetXCreator.putSpinnerFieldController("spStatusFilter"), label: "Status", hint: "Pilih Salah Satu", alertText: "", items: const {}, onSpinnerSelected: (value) {});

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

  late ButtonFill btKormasiFilter = ButtonFill(
    controller: GetXCreator.putButtonFillController("btKormasiFilter"),
    label: "Konfirmasi Filter",
    onClick: () => saveFilter(),
  );

  late ButtonOutline btBersihkanFilter = ButtonOutline(
    controller: GetXCreator.putButtonOutlineController("btBersihkanFilter"),
    label: "Bersihkan Filter",
    onClick: () => clearFilter(),
  );

  late SearchBarField sbSearch;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  int countApi = 0;

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    scrollPurchaseListener();
    scrollTransferListener();
    scrollOrderListener();
    sbSearch = SearchBarField(
      controller: GetXCreator.putSearchBarController("purhcaseSearchBar"),
      items: const ["Nomor PO", "Nomor Transfer", "Nomor SO"],
      onTyping: (value, control) => searchOrder(value),
      onCategorySelected: (value) {},
      addPrefixDropdown: false,
    );
  }

  @override
  void onReady() {
    super.onReady();
    tabbarListener();
    isLoadingPurchase.value = true;
    resetAllBodyPurhcaseValue();
    getListPurchase();
  }

  void tabbarListener() {
    tabController.controller.addListener(() {
      if (tabController.controller.index == 0) {
        isPurhcase.value = true;
        isTransfer.value = false;
        isOrderReturn.value = false;
        isFilter.value = false;
        listFilter.value.clear();
        isSearch.value = false;
        sbSearch.controller.setSelectedValue("Nomor PO");
        isLoadingPurchase.value = true;
        resetAllBodyPurhcaseValue();
        getListPurchase();
      } else if (tabController.controller.index == 1) {
        isPurhcase.value = false;
        isTransfer.value = true;
        isOrderReturn.value = false;
        isFilter.value = false;
        listFilter.value.clear();
        isSearch.value = false;
        sbSearch.controller.setSelectedValue("Nomor Transfer");
        isLoadingTransfer.value = true;
        resetAllBodyTransferValue();
        getListTransfer();
      } else if (tabController.controller.index == 2) {
        isPurhcase.value = false;
        isTransfer.value = false;
        isOrderReturn.value = true;
        isFilter.value = false;
        listFilter.value.clear();
        isSearch.value = false;
        sbSearch.controller.setSelectedValue("Nomor SO");
        isLoadingOrder.value = true;
        resetAllBodyReturnValue();
        getListReturn();
      }
    });
  }

  void countingApi() {
    countApi++;
    if (countApi == 1) {
      timeEnd = DateTime.now();
      Duration duration = timeEnd.difference(timeStart);
      Constant.trackRenderTime("Penerimaan", duration);
    }
  }

  void openFilter() {
    if (isPurhcase.isTrue) {
      openFilterPurchase();
    } else if (isTransfer.isTrue) {
      openFilterTransfer();
    } else if (isOrderReturn.isTrue) {
      openFilterOrder();
    }
  }

  void saveFilter() {
    if (validationFilter()) {
      sbSearch.controller.clearText();
      listFilter.value.clear();
      if (dtTanggalFilterReceive.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Pembelian"] = dtTanggalFilterReceive.controller.textSelected.value;
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
      if (spJenisSumber.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Jenis Sumber"] = spJenisSumber.controller.textSelected.value;
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
      if (isPurhcase.isTrue) {
        filterPurchase();
      } else if (isTransfer.isTrue) {
        filterTransfer();
      } else if (isOrderReturn.isTrue) {
        filterOrder();
      }
    }
  }

  bool validationFilter() {
    return true;
  }

  void clearFilter() {
    listFilter.value.clear();
    listFilter.refresh();
    dtTanggalFilterReceive.controller.setTextSelected("");
    spStatus.controller.setTextSelected("");
    spCategory.controller.setTextSelected("");
    spSku.controller.setTextSelected("");
    spSku.controller.disable();
    spJenisSumber.controller.setTextSelected("");
    spSumber.controller.setTextSelected("");
    spTujuan.controller.setTextSelected("");
    Get.back();
    isFilter.value = false;
    isSearch.value = false;
    if (isPurhcase.isTrue) {
      resetAllBodyPurhcaseValue();
      isLoadingPurchase.value = true;
      getListPurchase();
    } else if (isTransfer.isTrue) {
      resetAllBodyTransferValue();
      isLoadingTransfer.value = true;
      getListTransfer();
    } else if (isOrderReturn.isTrue) {
      resetAllBodyReturnValue();
      isLoadingOrder.value = true;
      getListReturn();
    }
  }

  void removeOneFilter(String key) {
    switch (key) {
      case "Tanggal Pembelian":
        dtTanggalFilterReceive.controller.setTextSelected("");
        break;
      case "Status":
        spStatus.controller.setTextSelected("");
        break;
      case "Kategori":
        spCategory.controller.setTextSelected("");
        spSku.controller.setTextSelected("");
        listFilter.value.remove("SKU");
        break;
      case "Jenis Sumber":
        spSumber.controller.setTextSelected("");
        spJenisSumber.controller.setTextSelected("");
        listFilter.value.remove("Sumber");
        break;
      case "SKU":
        spSku.controller.setTextSelected("");
        break;
      case "Sumber":
        spSumber.controller.setTextSelected("");
        break;
      case "Destination":
        spTujuan.controller.setTextSelected("");
        break;

      default:
    }

    listFilter.value.remove(key);
    listFilter.refresh();
    if (listFilter.value.isEmpty) {
      if (isPurhcase.isTrue) {
        isFilter.value = false;
        isSearch.value = false;
        resetAllBodyPurhcaseValue();
        isLoadingPurchase.value = true;
        getListPurchase();
      } else if (isTransfer.isTrue) {
        isFilter.value = false;
        isSearch.value = false;
        resetAllBodyTransferValue();
        isLoadingTransfer.value = true;
        getListTransfer();
      } else if (isOrderReturn.isTrue) {
        isFilter.value = false;
        isSearch.value = false;
        resetAllBodyReturnValue();
        isLoadingOrder.value = true;
        getListReturn();
      }
    } else {
      if (isPurhcase.isTrue) {
        isLoadingPurchase.value = true;
        filterPurchase();
      } else if (isTransfer.isTrue) {
        isLoadingTransfer.value = true;
        filterTransfer();
      } else if (isOrderReturn.isTrue) {
        isLoadingOrder.value = true;
        filterOrder();
      }
    }
  }

  void searchOrder(String text) {
    if (text.isNotEmpty) {
      if (debouncer?.isActive ?? false) debouncer?.cancel();
      debouncer = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = true;
        isFilter.value = false;
        listFilter.value.clear();
        if (isPurhcase.isTrue) {
          isLoadingPurchase.value = true;
          resetAllBodyPurhcaseValue();
          bodyGeneralPurhcase[BodyQueryPurhcase.code.index] = text;
          getListPurchase();
        } else if (isTransfer.isTrue) {
          isLoadingTransfer.value = true;
          resetAllBodyTransferValue();
          bodyGeneralTransfer[BodyQueryTransfer.code.index] = text;
          getListTransfer();
        } else if (isOrderReturn.isTrue) {
          isLoadingOrder.value = true;
          resetAllBodyReturnValue();
          bodyGeneralReturn[BodyQueryReturn.code.index] = text;
          getListReturn();
        }
      });
    } else {
      if (debouncer?.isActive ?? false) debouncer?.cancel();
      debouncer = Timer(const Duration(milliseconds: 500), () {
        isSearch.value = false;
        if (isPurhcase.isTrue) {
          listPurchase.value.clear();
          isLoadingPurchase.value = true;
          resetAllBodyPurhcaseValue();
          getListPurchase();
        } else if (isTransfer.isTrue) {
          listTransfer.value.clear();
          isLoadingTransfer.value = true;
          resetAllBodyTransferValue();
          getListTransfer();
        } else if (isOrderReturn.isTrue) {
          pageOrder.value = 1;
          listReturn.value.clear();
          isLoadingOrder.value = true;
        }
      });
    }
  }

  showFilter() {
    if (isPurhcase.isTrue) {
      Future.delayed(const Duration(milliseconds: 100), () {
        spStatus.controller.generateItems(mapStatusPo);
      });
      dtTanggalFilterReceive.controller.setLabel("Tanggal Pembelian");
      spJenisSumber.controller.visibleSpinner();
    } else if (isTransfer.isTrue) {
      Future.delayed(const Duration(milliseconds: 100), () {
        spStatus.controller.generateItems(mapStatusTransfer);
      });
      dtTanggalFilterReceive.controller.setLabel("Tanggal Transfer");
      spJenisSumber.controller.invisibleSpinner();
      spSumber.controller.enable();
    } else if (isOrderReturn.isTrue) {
      Future.delayed(const Duration(milliseconds: 100), () {
        spStatus.controller.generateItems(mapStatusReturn);
      });
      dtTanggalFilterReceive.controller.setLabel("Tanggal Penjualan");
      spJenisSumber.controller.invisibleSpinner();
      spSumber.controller.enable();
    }
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
                          thumbColor: AppColors.primaryOrange,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                if(isPurhcase.isTrue) Text("Filter Pembelian", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 21)),
                                if(isTransfer.isTrue) Text("Filter Transfer", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 21)),
                                if(isOrderReturn.isTrue) Text("Filter Penjualan", style: AppTextStyle.blackTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 21)),
                                dtTanggalFilterReceive,
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

  void fetchOrder(List<dynamic> body, ResponseListener listener) {
    Service.push(service: ListApi.getListOrdersFilter, context: context, body: body, listener: listener);
  }

  void setValueBody(int index, dynamic value, List<dynamic> bodyGeneral) {
    bodyGeneral[index] = value;
  }

//   void resetAllBodyValue<T>(T enum,List<dynamic> bodyGeneral) {
//     for (int i = 0; i < bodyGeneral.length; i++) {
//       bodyGeneral[i] = null;
//     }
//     bodyGeneral[enum.token.index] = Constant.auth!.token;
//     bodyGeneral[enum.auth.index] = Constant.auth!.id;
//     bodyGeneral[enum.xAppId.index] = Constant.xAppId;
//   }

//   void setGeneralheader(int page, int limit, String category, List<dynamic> bodyGeneral) {
//     bodyGeneral[BodyQuerySales.page.index] = page;
//     bodyGeneral[BodyQuerySales.limit.index] = limit;
//     bodyGeneral[BodyQuerySales.category.index] = category;
//   }

  void onResponseFail(dynamic body, RxBool loading) {
    loading.value = false;
    Get.snackbar(
      "Pesan",
      "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  void onResponseError(RxBool loading) {
    Get.snackbar(
      "Pesan",
      "Terjadi kesalahan internal",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
    loading.value = false;
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
}

class ReceiveBindings extends Bindings {
  BuildContext context;
  ReceiveBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => ReceiveController(context: context));
  }
}
