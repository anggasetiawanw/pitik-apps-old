import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:components/switch_linear/switch_linear.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/customer_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card_order/sku_card_order.dart';
import 'package:pitik_internal_app/widget/sku_card_order/sku_card_order_controller.dart';
import 'package:pitik_internal_app/widget/sku_card_remark/sku_card_remark.dart';
import 'package:pitik_internal_app/widget/sku_card_remark/sku_card_remark_controller.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 15/05/23

class NewDataSalesOrderController extends GetxController {
  BuildContext context;
  NewDataSalesOrderController({required this.context});

  var isLoading = false.obs;
  var isInbound = false.obs;

  late ButtonFill iyaOrderButton;
  late ButtonOutline tidakOrderButton;
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  var page = 1.obs;
  var limit = 10.obs;
  var status = "".obs;
  var produkType = "Non-LB".obs;
  RxBool isDeliveryPrice = false.obs;
  RxInt priceDelivery = 0.obs;

  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
  Rx<List<CategoryModel?>> listCategoriesRemark = Rx<List<CategoryModel>>([]);
  Rx<List<Products?>> listProduct = Rx<List<Products>>([]);
  Rx<List<Customer?>> listCustomer = Rx<List<Customer>>([]);
  Rx<Map<String, bool>> mapListSku = Rx<Map<String, bool>>({});
  Rx<Map<String, bool>> mapListRemark = Rx<Map<String, bool>>({});
  Rx<Map<int, List<Products?>>> listSku = Rx<Map<int, List<Products?>>>({});
  Rx<List<OperationUnitModel?>> listSource = Rx<List<OperationUnitModel>>([]);

  late SpinnerSearch spinnerCustomer = SpinnerSearch(
    controller: GetXCreator.putSpinnerSearchController("customer"),
    label: isInbound.isTrue ? "Customer(Optional)" : "Customer*",
    hint: "Pilih salah satu",
    alertText: "Customer harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {},
  );

  late SpinnerSearch spSumber = SpinnerSearch(
    controller: GetXCreator.putSpinnerSearchController("spSumber"),
    label: "Sumber*",
    hint: "Pilih salah satu",
    alertText: "Sumber harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {},
  );
  late SpinnerField spinnerOrderType = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("orderType"),
    label: "Jenis Penjualan*",
    hint: "Pilih salah satu",
    alertText: "Jenis Penjualan harus dipilih!",
    items: const {"Non-LB": true, "LB": false},
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {
        produkType.value = text;
        if (text == "LB") {
          Map<String, bool> mapListRemark = {};
          for (var product in listCategoriesRemark.value) {
            mapListRemark[product!.name!] = false;
          }
          Timer(const Duration(milliseconds: 100), () {
            skuCardRemark.controller.spinnerCategories.value[0].controller.generateItems(mapListRemark);

            for (var result in listCategories.value) {
              if (result!.name == AppStrings.LIVE_BIRD) {
                spinnerCategories.controller.setTextSelected(result.name!);
                spinnerCategories.controller.disable();
                getSku(result.id!);
              }
            }
          });
        }
      }
    },
  );

  late SkuCardOrder skuCard;
  late SkuCardRemark skuCardRemark;

  late SpinnerField spinnerCategories = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("spinnerKategoriLB"),
    label: "Kategori SKU*",
    hint: "Pilih Salah Satu",
    alertText: "Jenis Kebutuhan harus dipilih!",
    items: const {},
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {}
    },
  );
  late SpinnerField spinnerSku = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("spinnerSKULB"),
      label: "SKU*",
      hint: "Pilih Salah Satu",
      alertText: "Ukuran harus dipilih!",
      items: const {},
      onSpinnerSelected: (value) {
        editFieldJumlahAyam.controller.enable();
      });

  late EditField editFieldJumlahAyam = EditField(
      controller: GetXCreator.putEditFieldController("editFieldJumlahAyamLB"),
      label: "Jumlah Ekor",
      hint: "Tulis Jumlah*",
      alertText: "Kolom Ini Harus Di Isi",
      textUnit: "Ekor",
      inputType: TextInputType.number,
      maxInput: 20,
      onTyping: (value, control) {
        // editFieldKebutuhan.controller.enable();
        editFieldHarga.controller.enable();
        refreshtotalPurchase();
      });

//   late EditField editFieldKebutuhan = EditField(
//       controller: GetXCreator.putEditFieldController("editFieldKebutuhanLb"),
//       label: "Kebutuhan*",
//       hint: "Tulis Jumlah*",
//       alertText: "Kolom Ini Harus Di Isi",
//       textUnit: "Kg",
//       inputType: TextInputType.number,
//       maxInput: 20,
//       onTyping: (value, control) {
//         refreshtotalPurchase();
//       });

  late EditField editFieldHarga = EditField(
      controller: GetXCreator.putEditFieldController("edithargaLb"),
      label: "Harga*",
      hint: "Tulis Jumlah",
      alertText: "Kolom Ini Harus Di Isi",
      textUnit: "/Kg",
      textPrefix: AppStrings.PREFIX_CURRENCY_IDR,
      inputType: TextInputType.number,
      maxInput: 20,
      onTyping: (value, control) {
        if (control.getInput().length < 4) {
          control.controller.setAlertText("Harga Tidak Valid!");
          control.controller.showAlert();
        }
        refreshtotalPurchase();
      });

  EditField efRemark = EditField(controller: GetXCreator.putEditFieldController("efRemark"), label: "Catatan", hint: "Ketik disini", alertText: "", textUnit: "", maxInput: 500, inputType: TextInputType.multiline, height: 160, onTyping: (value, editField) {});

  late SwitchLinear deliveryPrice = SwitchLinear(
      onSwitch: (active) {
        isDeliveryPrice.value = active;
        if (active) {
          priceDelivery.value = 10000;
        } else {
          priceDelivery.value = 0;
        }
      },
      controller: GetXCreator.putSwitchLinearController("deliveryprice"));

  DateTimeField dtDeliveryDate = DateTimeField(
    controller: GetXCreator.putDateTimeFieldController("DeliveryDateSo"),
    label: "Tanggal Pengiriman*",
    hint: "dd/mm/yyyy",
    alertText: "Tanggal Pengiriman harus dipilih!",
    onDateTimeSelected: (date, dateField) =>dateField.controller.setTextSelected('${Convert.getDay(date)}/${Convert.getMonthNumber(date)}/${Convert.getYear(date)}'),
    flag: 1,
  );
  DateTimeField dtDeliveryTime = DateTimeField(
    controller: GetXCreator.putDateTimeFieldController("deliveryTimeSo"),
    label: "Waktu Pengiriman",
    hint: "hh:mm",
    alertText: "Waktu Pengiriman harus dipilih!",
    onDateTimeSelected: (date, dateField) =>dateField.controller.setTextSelected('${Convert.getHour(date)}:${Convert.getMinute(date)}'),
    flag: 2,
  );

  @override
  void onInit() {
    super.onInit();
    isInbound.value = Get.arguments;
    isLoading.value = true;
    spinnerOrderType.controller.setTextSelected("Non-LB");
    skuCard = SkuCardOrder(
      controller: InternalControllerCreator.putSkuCardOrderController("skuOrder", context),
    );
    skuCardRemark = SkuCardRemark(
      controller: InternalControllerCreator.putSkuCardRemarkController("skuRemark", context),
    );

    tidakOrderButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("tidakOrder"),
      label: "Tidak",
      onClick: () {
        Get.back();
      },
    );

    iyaOrderButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("iyaPurchase"),
      label: "Ya",
      onClick: () {
        Get.back();
        saveOrder();
      },
    );
  }

  @override
  void onReady() {
    Get.find<SkuCardOrderController>(tag: "skuOrder").idx.listen((p0) {
      generateListProduct(p0);
    });
    Get.find<SkuCardRemarkController>(tag: "skuRemark").itemCount.listen((p0) {
      generateListRemark(p0);
    });
    skuCard.controller.visibleCard();
    skuCardRemark.controller.visibleCard();
    editFieldJumlahAyam.controller.disable();
    // editFieldKebutuhan.controller.disable();
    editFieldHarga.controller.disable();
    if (isInbound.isTrue) {
      getListSource();
    }
    getListCustomer();
    getCategorySku();
    super.onReady();
  }

  void generateListProduct(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx = idx - 1;
      skuCard.controller.spinnerCategories.value[idx].controller.generateItems(mapListSku.value);
      skuCard.controller.editFieldHarga.value[idx].controller.addListener(() {});
    });
  }

  void generateListRemark(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx = idx - 1;
      skuCardRemark.controller.spinnerCategories.value[idx].controller.generateItems(mapListRemark.value);
      // skuCardRemark.controller.editFieldHarga.value[idx].controller.addListener(() {
      // });
    });
  }

  void refreshtotalPurchase() {
    Products? selectProduct = listProduct.value.firstWhereOrNull((element) => element!.name! == spinnerSku.controller.textSelected.value);

    if (selectProduct != null) {
      double jumlahAyam = editFieldJumlahAyam.getInputNumber() ?? 0;
      double harga = editFieldHarga.getInputNumber() ?? 0;

      // Hitung nilai minimum dan maksimum berdasarkan produk dan jumlah ayam
      double minValue = selectProduct.minValue! * jumlahAyam;
      double maxValue = selectProduct.maxValue! * jumlahAyam;

      // Update variabel-sum yang sesuai
      sumNeededMin.value = minValue;
      sumNeededMax.value = maxValue;
      sumChick.value = jumlahAyam.toInt();
      sumPriceMin.value = harga * minValue;
      sumPriceMax.value = harga * maxValue;
    }
  }

  void getListCustomer() {
    spinnerCustomer.controller.disable();
    spinnerCustomer.controller.setTextSelected("Loading...");
    spinnerCustomer.controller.showLoading();
    Service.push(
        apiKey: 'userApi',
        service: ListApi.getListCustomerWithoutPage,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var customer in (body as ListCustomerResponse).data) {
            mapList[customer!.businessName!] = false;
          }
          Timer(const Duration(milliseconds: 500), () {
            spinnerCustomer.controller.generateItems(mapList);
          });
          spinnerCustomer.controller.enable();

          for (var result in body.data) {
            listCustomer.value.add(result!);
          }
          spinnerCustomer.controller.hideLoading();
          spinnerCustomer.controller.setTextSelected("");
        }, onResponseFail: (code, message, body, id, packet) {
          Get.snackbar(
            "Pesan",
            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          spinnerCustomer.controller.hideLoading();
          spinnerCustomer.controller.setTextSelected("");
        }, onResponseError: (exception, stacktrace, id, packet) {
          Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
          spinnerCustomer.controller.hideLoading();
          spinnerCustomer.controller.setTextSelected("");
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }));
  }

  void getCategorySku() {
    skuCard.controller.spinnerCategories.value[0].controller.disable();
    skuCard.controller.spinnerCategories.value[0].controller.showLoading();
    skuCard.controller.spinnerCategories.value[0].controller.setTextSelected("Loading...");
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as CategoryListResponse).data) {
              listCategories.value.add(result);
              listCategoriesRemark.value.add(result);
            }
            Map<String, bool> mapList = {};
            Map<String, bool> mapListRemark = {};
            for (var product in body.data) {
              mapList[product!.name!] = false;
            }
            for (var product in body.data) {
              mapListRemark[product!.name!] = false;
            }
            //Generate Card SKU
            mapList.removeWhere((key, value) => key == AppStrings.LIVE_BIRD);
            Timer(const Duration(milliseconds: 100), () {
              skuCard.controller.spinnerCategories.value[0].controller.enable();
              skuCard.controller.spinnerCategories.value[0].controller.setTextSelected("");
              skuCard.controller.spinnerCategories.value[0].controller.hideLoading();
              skuCard.controller.spinnerCategories.value[0].controller.generateItems(mapList);

              skuCard.controller.setMaplist(listCategories.value);
              mapListSku.value = mapList;

              //Generate Card Remark
              skuCardRemark.controller.spinnerCategories.value[0].controller.generateItems(mapListRemark);

              skuCardRemark.controller.setMaplist(listCategoriesRemark.value);
              this.mapListRemark.value = mapListRemark;

              spinnerCategories.controller.generateItems(mapListRemark);
            });

            for (var result in listCategories.value) {
              if (result!.name == AppStrings.LIVE_BIRD) {
                spinnerCategories.controller.setTextSelected(result.name!);
                spinnerCategories.controller.disable();
                getSku(result.id!);
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
          onResponseError: (exception, stacktrace, id, packet) {},
          onTokenInvalid: Constant.invalidResponse()),
    );
  }

  void getSku(String categoriId) {
    isLoading.value = true;
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
                  listProduct.value.add(result);
                }

                Timer(const Duration(milliseconds: 100), () {
                  spinnerSku.controller.generateItems(mapList);
                  // spinnerSku.controller
                  //   ..textSelected.value = ""
                  //   ..generateItems(mapList)
                  //   ..enable();
                });
              } else {
                spinnerSku.controller
                  ..textSelected.value = body.data[0]!.name!
                  ..disable();
              }

              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              isLoading.value = false;
            },
            onTokenInvalid: () {}));
  }

  void getListSource() {
    spSumber.controller
      ..disable()
      ..setTextSelected("Loading...")
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE, 0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              Timer(const Duration(milliseconds: 500), () {
                spSumber.controller.generateItems(mapList);
              });
              for (var result in body.data) {
                listSource.value.add(result);
              }
              spSumber.controller
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
              spSumber.controller
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
              spSumber.controller
                ..setTextSelected("")
                ..hideLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void saveOrder() {
    List ret = produkType.value == "LB" ? validationLb() : validationNonLb();
    if (ret[0]) {
      isLoading.value = true;
      Order purchasePayload = generatePayload();
      Service.push(
        service: ListApi.createSalesOrder,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, Mapper.asJsonString(purchasePayload)],
        listener: ResponseListener(onResponseDone: (code, message, body, id, packet) {
          isLoading.value = false;
          Get.back();
        }, onResponseFail: (code, message, body, id, packet) {
          isLoading.value = false;
          var stock = "Invalid sales order's weight Product's note weight is greater than the input!";
          if ((body as ErrorResponse).error!.message!.contains(stock)) {
            Get.snackbar(
              "Pesan",
              "Gagal membuat Penjualan, total catatan lebih besar dari input SKU LB",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
          } else {
            Get.snackbar(
              "Pesan",
              "Terjadi Kesalahan, ${(body).error!.message}",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
          }
        }, onResponseError: (exception, stacktrace, id, packet) {
          isLoading.value = false;
          Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        }, onTokenInvalid: () {
          Constant.invalidResponse();
        }),
      );
    }
  }

  Order generatePayload() {
    List<Products?> productList = [];
    List<Products?> lbProductList = [];
    List<Products?> remarkProductList = [];

    if (produkType.value == "LB") {
      lbProductList = _generateLbProductList();
      remarkProductList = _generateRemarkProductList();
    } else {
      productList = _generateProductList();
    }
    OperationUnitModel? sourceSelected;
    Customer? customerSelected;
    if (spinnerCustomer.controller.textSelected.value.isNotEmpty) {
      customerSelected = listCustomer.value.firstWhereOrNull(
        (element) => element!.businessName == spinnerCustomer.controller.textSelected.value,
      );
    }
    if (spSumber.controller.textSelected.value.isNotEmpty && isInbound.isTrue) {
      sourceSelected = listSource.value.firstWhereOrNull((element) => element!.operationUnitName == spSumber.controller.textSelected.value);
    }

    DateTime? resultDate;
    if (isInbound.isFalse) {
      DateTime deliveryDate = dtDeliveryDate.getLastTimeSelected();
      DateTime deliveryTime = dtDeliveryTime.controller.textSelected.value.isNotEmpty ? dtDeliveryTime.getLastTimeSelected() : DateTime(0);
      resultDate = DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day, deliveryTime.hour, deliveryTime.minute);
    }
    return Order(
      customerId: customerSelected?.id, // Ganti dengan nilai default jika tidak ada customer terpilih
      operationUnitId: sourceSelected?.id,
      products: produkType.value == "LB" ? lbProductList : productList,
      productNotes: produkType.value == "LB" ? remarkProductList : null,
      type: produkType.value == "LB" ? "LB" : "NON_LB",
      status: status.value,
      category: isInbound.isTrue ? "INBOUND" : "OUTBOUND",
      remarks: Uri.encodeFull(efRemark.getInput()),
      withDeliveryFee: isDeliveryPrice.value,
      deliveryTime: resultDate !=null ? Convert.getStringIso(resultDate) : null,
    );
  }

  List<Products?> _generateProductList() {
    List<Products?> productList = [];

    for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
      int whichItem = skuCard.controller.index.value[i];
      var listProductTemp = skuCard.controller.listSku.value.values.toList();
      Products? productSelected = listProductTemp[whichItem].firstWhereOrNull(
        (element) => element!.name! == skuCard.controller.spinnerSku.value[whichItem].controller.textSelected.value,
      );

      if (productSelected!.id != null) {
        productList.add(Products(
          productItemId: productSelected.id,
          quantity: _getQuantity(productSelected.category, skuCard.controller.editFieldJumlahAyam.value[whichItem]),
          numberOfCuts: _getNumberOfCuts(productSelected.category, skuCard.controller.editFieldPotongan.value[whichItem]),
          price: skuCard.controller.editFieldHarga.value[whichItem].getInputNumber() ?? 0,
          weight: skuCard.controller.editFieldKebutuhan.value[whichItem].getInputNumber() ?? 0,
        ));
      }
    }

    return productList;
  }

  List<Products?> _generateLbProductList() {
    List<Products?> lbProductList = [];
    Products? produkSkuSelected = listProduct.value.firstWhereOrNull((element) => element!.name == spinnerSku.controller.textSelected.value);

    if (produkSkuSelected != null) {
      lbProductList.add(Products(
        productItemId: produkSkuSelected.id,
        quantity: (editFieldJumlahAyam.getInputNumber() ?? 0).toInt(),
        numberOfCuts: 0,
        price: editFieldHarga.getInputNumber(),
        weight: /*editFieldKebutuhan.getInputNumber()*/ 0,
      ));
    }

    return lbProductList;
  }

  List<Products?> _generateRemarkProductList() {
    List<Products?> remarkProductList = [];

    for (int i = 0; i < skuCardRemark.controller.itemCount.value; i++) {
      int whichItem = skuCardRemark.controller.index.value[i];
      CategoryModel? productSelected = listCategoriesRemark.value.firstWhereOrNull(
        (element) => element!.name! == skuCardRemark.controller.spinnerCategories.value[whichItem].controller.textSelected.value,
      );

      if (productSelected != null) {
        remarkProductList.add(Products(
          productCategoryId: productSelected.id,
          quantity: _getQuantity(productSelected, skuCardRemark.controller.editFieldJumlahAyam.value[whichItem]),
          numberOfCuts: _getNumberOfCuts(productSelected, skuCardRemark.controller.editFieldPotongan.value[whichItem]),
          cutType: skuCardRemark.controller.spinnerTypePotongan.value[whichItem].controller.textSelected.value == "Potong Biasa" ? "REGULAR" : "BEKAKAK",
          weight: null,
        ));
      }
    }

    return remarkProductList;
  }

  int? _getQuantity(CategoryModel? category, EditField ef) {
    if (category != null && (category.name == AppStrings.AYAM_UTUH || category.name == AppStrings.BRANGKAS || category.name == AppStrings.LIVE_BIRD || category.name == AppStrings.KARKAS)) {
      return (ef.getInputNumber() ?? 0).toInt(); // Ganti dengan logic sesuai kebutuhan
    }
    return null;
  }

  int? _getNumberOfCuts(CategoryModel? category, EditField ef) {
    if (category != null && (category.name == AppStrings.AYAM_UTUH || category.name == AppStrings.BRANGKAS || category.name == AppStrings.LIVE_BIRD || category.name == AppStrings.KARKAS)) {
      return (ef.getInputNumber() ?? 0).toInt(); // Ganti dengan logic sesuai kebutuhan
    }
    return null;
  }

  List validationNonLb() {
    List ret = [true, ""];
    if (spinnerCustomer.controller.textSelected.value.isEmpty && isInbound.isFalse) {
      spinnerCustomer.controller.showAlert();
      Scrollable.ensureVisible(spinnerCustomer.controller.formKey.currentContext!);
      return ret = [false, ""];
    } else if (spSumber.controller.textSelected.value.isEmpty && isInbound.isTrue) {
      spSumber.controller.showAlert();
      Scrollable.ensureVisible(spSumber.controller.formKey.currentContext!);
      return ret = [false, ""];
    }
    if (isInbound.isFalse) {
      if (dtDeliveryDate.controller.textSelected.value.isEmpty) {
        dtDeliveryDate.controller.showAlert();
        Scrollable.ensureVisible(dtDeliveryDate.controller.formKey.currentContext!);
        return ret = [false, ""];
      }
    }

    ret = skuCard.controller.validation();
    return ret;
  }

  List validationLb() {
    List ret = [true, ""];
    if (spinnerCustomer.controller.textSelected.value.isEmpty && isInbound.isFalse) {
      spinnerCustomer.controller.showAlert();
      Scrollable.ensureVisible(spinnerCustomer.controller.formKey.currentContext!);
      return ret = [false, ""];
    } else if (spSumber.controller.textSelected.value.isEmpty && isInbound.isTrue) {
      spSumber.controller.showAlert();
      Scrollable.ensureVisible(spSumber.controller.formKey.currentContext!);
      return ret = [false, ""];
    } else if (spinnerCategories.controller.textSelected.value.isEmpty) {
      spinnerCategories.controller.showAlert();
      Scrollable.ensureVisible(spinnerCategories.controller.formKey.currentContext!);
      return ret = [false, ""];
    } else if (spinnerSku.controller.textSelected.value.isEmpty) {
      spinnerSku.controller.showAlert();
      Scrollable.ensureVisible(spinnerSku.controller.formKey.currentContext!);
      return ret = [false, ""];
    } else if (editFieldJumlahAyam.getInput().isEmpty) {
      editFieldJumlahAyam.controller.showAlert();
      Scrollable.ensureVisible(editFieldJumlahAyam.controller.formKey.currentContext!);
      return ret = [false, ""];
    } else if (editFieldHarga.getInput().isEmpty) {
      editFieldHarga.controller.showAlert();
      Scrollable.ensureVisible(editFieldHarga.controller.formKey.currentContext!);
      return ret = [false, ""];
    }

    if (isInbound.isFalse) {
      if (dtDeliveryDate.controller.textSelected.value.isEmpty) {
        dtDeliveryDate.controller.showAlert();
        Scrollable.ensureVisible(dtDeliveryDate.controller.formKey.currentContext!);
        return ret = [false, ""];
      }
    }

    ret = skuCardRemark.controller.validation();
    return ret;
  }
}

class NewDataSalesOrderBindings extends Bindings {
  BuildContext context;
  NewDataSalesOrderBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => NewDataSalesOrderController(context: context));
  }
}
