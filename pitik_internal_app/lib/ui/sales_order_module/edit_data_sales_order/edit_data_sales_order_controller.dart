import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/spinner_search/spinner_search.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/customer_list_response.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_card_order/sku_card_order.dart';
import 'package:pitik_internal_app/widget/sku_card_order/sku_card_order_controller.dart';
import 'package:pitik_internal_app/widget/sku_card_remark/sku_card_remark.dart';
import 'package:pitik_internal_app/widget/sku_card_remark/sku_card_remark_controller.dart';
import 'package:model/internal_app/order_request.dart';
///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class EditDataSalesOrderController extends GetxController{
  BuildContext context;
  EditDataSalesOrderController({required this.context});

  var isLoading = false.obs;
  var isLoadData = false.obs;

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

  late Order orderDetail;
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
  Rx<List<CategoryModel?>> listCategoriesRemark = Rx<List<CategoryModel>>([]);
  Rx<List<Products?>> listProduct = Rx<List<Products>>([]);
  Rx<List<Customer?>> listCustomer = Rx<List<Customer>>([]);
  Rx<Map<String, bool>> mapListSku = Rx<Map<String, bool>>({});
  Rx<Map<String, bool>> mapListRemark = Rx<Map<String, bool>>({});


  late SpinnerSearch spinnerCustomer  = SpinnerSearch(
    controller: GetXCreator.putSpinnerSearchController("customer"),
    label: "Customer*",
    hint: "Pilih salah satu",
    alertText: "Customer harus dipilih!",
    items: const {
    },
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {
        // editNamaSupplier.controller.visibleField();
      }
    },
  );
  late SpinnerField spinnerOrderType  = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("orderType"),
    label: "Jenis Penjualan*",
    hint: "Pilih salah satu",
    alertText: "Jenis Penjualan harus dipilih!",
    items: const {"Non-LB" : true, "LB" :false
    },
    onSpinnerSelected: (text) {
      if (text.isNotEmpty) {
        if (text == "LB") {
          Map<String, bool> mapListRemark = {};
          for (var product in listCategoriesRemark.value) {
            mapListRemark[product!.name!] = false;
          }
          Timer(const Duration(milliseconds: 500), () {
            skuCardRemark
                .controller
                .spinnerCategories
                .value[0]
                .controller
                .generateItems(mapListRemark);

            for(var result in listCategories.value) {
              if (result!.name == AppStrings.LIVE_BIRD) {
                spinnerCategories.controller.setTextSelected(result.name!);
                spinnerCategories.controller.disable();
                getSku(result.id!);
              }
            }
          });
        }else{
          isLoading.value = true;
          getCategorySku();
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
      if (text.isNotEmpty) {
        // editNamaSupplier.controller.visibleField();
      }
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
      }
  );

  late EditField editFieldJumlahAyam = EditField(
      controller: GetXCreator.putEditFieldController("editFieldJumlahAyamLB"),
      label: "Jumlah Ekor",
      hint: "Tulis Jumlah*",
      alertText: "Kolom Ini Harus Di Isi",
      textUnit: "Ekor",
      inputType: TextInputType.number,
      maxInput: 20,
      onTyping: (value, control) {
        editFieldKebutuhan.controller.enable();
        editFieldHarga.controller.enable();
        refreshtotalPurchase();
      }
  );

  late EditField editFieldKebutuhan = EditField(
      controller: GetXCreator.putEditFieldController("editFieldKebutuhanLb"),
      label: "Kebutuhan*",
      hint: "Tulis Jumlah*",
      alertText: "Kolom Ini Harus Di Isi",
      textUnit: "Kg",
      inputType: TextInputType.number,
      maxInput: 20,
      onTyping: (value, control) {
        refreshtotalPurchase();
    }
  );

  late EditField editFieldHarga = EditField(
      controller: GetXCreator.putEditFieldController(
          "edithargaLb"),
      label: "Harga*",
      hint: "Tulis Jumlah",
      alertText: "Kolom Ini Harus Di Isi",
      textUnit: "/Kg",
      inputType: TextInputType.number,
      maxInput: 20,
      onTyping: (value, control) {
        if(control.getInput().length < 4){
          control.controller.setAlertText("Harga Tidak Valid!");
          control.controller.showAlert();
        }
        refreshtotalPurchase();

      }
  );

  @override
  void onInit() {
    super.onInit();
    isLoading.value =true;
    orderDetail = Get.arguments;
    spinnerOrderType.controller.setTextSelected("Non-LB");
    spinnerOrderType.controller.disable();
    getListCustomer();
    getCategorySku();
    skuCard = SkuCardOrder(
      controller: InternalControllerCreator.putSkuCardOrderController("skuOrder",context ),
    );
    skuCardRemark= SkuCardRemark(
      controller: InternalControllerCreator.putSkuCardRemarkController("skuRemark",context ),
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
        saveEditOrder();
      },
    );
  }

  @override
  void onReady() async{
    super.onReady();
    Get.find<SkuCardOrderController>(tag: "skuOrder").idx.listen((p0) {
      generateListProduct(p0);
    });
    Get.find<SkuCardRemarkController>(tag: "skuRemark").itemCount.listen((p0) {
      generateListRemark(p0);
    });
    skuCard.controller.visibleCard();
    skuCardRemark.controller.visibleCard();
    Timer(const Duration(milliseconds: 500), () async{ await loadData(orderDetail); });
   
  }

  
  refreshtotalPurchase(){
        Products? selectProduct = listProduct.value.firstWhere((element) => element!.name! == spinnerSku.controller.textSelected.value);
        double minValue = selectProduct!.minValue! * editFieldJumlahAyam.getInputNumber()!;
        double maxValue = selectProduct.maxValue! * editFieldJumlahAyam.getInputNumber()!;
        sumNeededMin.value = minValue;
        sumNeededMax.value = maxValue;
        sumChick.value = (editFieldJumlahAyam.getInputNumber()??0).toInt();
        sumPriceMin.value = (editFieldHarga.getInputNumber()??0) * minValue;
        sumPriceMax.value = (editFieldHarga.getInputNumber()??0) * maxValue;

  }

  Future<void> loadData(Order order) async{
    isLoadData.value = true;
    produkType.value = orderDetail.type! == "LB" ? "LB" : "Non-LB";
    spinnerCustomer.controller.setTextSelected(order.customer!.businessName!);
    spinnerOrderType.controller.setTextSelected(order.type! == "LB" ? "LB" : "Non-LB");

    if(order.type! == "LB") {
      getSku(orderDetail.products![0]!.category!.id!);
      if (orderDetail.productNotes!.isNotEmpty && orderDetail.productNotes != null) {
        for (int i = 0; i < orderDetail.productNotes!.length - 1; i++) {
          skuCardRemark.controller.addCard();
        }
        Timer(const Duration(milliseconds: 500), () async{
          Map<String, bool> listSku = {};
          Map<String, bool> listSkuRemark = {};
          for (var product in listCategories.value) {
            listSku[product!.name!] = false;
          }
          for (var product in listCategoriesRemark.value) {
            listSkuRemark[product!.name!] = false;
          }

          for (int j = 0; j < orderDetail.productNotes!.length; j++) {
            skuCardRemark.controller.spinnerCategories.value[j].controller.setTextSelected(orderDetail.productNotes![j]!.category!.name!);
            skuCardRemark.controller.spinnerCategories.value[j].controller.generateItems(listSkuRemark);
            skuCardRemark.controller.spinnerSku.value[j].controller.setTextSelected( orderDetail.productNotes![j]!.name!);
            skuCardRemark.controller.editFieldKebutuhan.value[j].setInput(orderDetail.productNotes![j]!.weight!.toString());


            skuCardRemark.controller.listSku.value[j] =orderDetail.productNotes!;
            skuCardRemark.controller.mapSumNeeded[j] =skuCardRemark.controller.editFieldKebutuhan.value[j].getInputNumber()!;

            Timer(const Duration(milliseconds: 500), () {
                CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == skuCardRemark.controller.spinnerCategories.value[j].controller.textSelected.value);
                skuCardRemark.controller.getLoadSku(selectCategory!, j);
                if (skuCardRemark.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.AYAM_UTUH ||skuCardRemark.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.BRANGKAS) {
                        skuCardRemark.controller.editFieldJumlahAyam.value[j].setInput(orderDetail.productNotes![j]!.quantity!.toString());
                        skuCardRemark.controller.editFieldPotongan.value[j].setInput(orderDetail.productNotes![j]!.numberOfCuts!.toString());
                        skuCardRemark.controller.editFieldJumlahAyam.value[j].controller.enable();
                        skuCardRemark.controller.editFieldPotongan.value[j].controller.enable();

                        skuCardRemark.controller.mapSumChick[j] =skuCardRemark.controller.editFieldJumlahAyam.value[j].getInputNumber()!;
                  }
                  else {
                    skuCardRemark.controller.editFieldJumlahAyam.value[j].controller.disable();
                    skuCardRemark.controller.editFieldPotongan.value[j].controller.disable();
                  }
                skuCardRemark.controller.editFieldKebutuhan.value[j].controller.enable();
             });
          }

        for (int j = 0; j < orderDetail.products!.length; j++) {
            listProduct.value.add(orderDetail.products![j]);
            spinnerCategories.controller.setTextSelected(orderDetail.products![j]!.category!.name!);
            spinnerCategories.controller.generateItems(listSku);
            spinnerSku.controller.setTextSelected(orderDetail.products![j]!.name!);
            editFieldJumlahAyam.setInput(orderDetail.products![j]!.quantity!.toString());
            editFieldKebutuhan.setInput(orderDetail.products![j]!.weight!.toString());
            editFieldHarga.setInput(orderDetail.products![j]!.price!.toString());
            refreshtotalPurchase();
        }
          
        });
        isLoadData.value = false;
      }

    }else {
      if (orderDetail.products!.isNotEmpty && orderDetail.products != null) {
        for (int i = 0; i < orderDetail.products!.length - 1; i++) {
          skuCard.controller.addCard();
        }
        Timer(Duration.zero, () async {
          Map<String, bool> listKebutuhan = {};
          for (var product in listCategories.value) {
            listKebutuhan[product!.name!] = false;
          }

          for (int j = 0; j < orderDetail.products!.length; j++) {
            skuCard.controller.spinnerCategories.value[j].controller.setTextSelected(orderDetail.products![j]!.category!.name!);
            skuCard.controller.spinnerCategories.value[j].controller.generateItems(listKebutuhan);
            skuCard.controller.spinnerSku.value[j].controller.setTextSelected(orderDetail.products![j]!.name!);
            skuCard.controller.editFieldJumlahAyam.value[j].setInput(orderDetail.products![j]!.quantity!.toString());
            skuCard.controller.editFieldPotongan.value[j].setInput(orderDetail.products![j]!.numberOfCuts!.toString());
            skuCard.controller.editFieldKebutuhan.value[j].setInput(orderDetail.products![j]!.weight!.toString());
            skuCard.controller.editFieldHarga.value[j].setInput(orderDetail.products![j]!.price!.toString());
            
            skuCard.controller.listSku.value[j] = orderDetail.products!;
            skuCard.controller.mapSumChick[j] =skuCard.controller.editFieldJumlahAyam.value[j].getInputNumber()!;
            skuCard.controller.mapSumNeeded[j] =skuCard.controller.editFieldKebutuhan.value[j].getInputNumber()!;
            skuCard.controller.mapSumPrice[j] =skuCard.controller.editFieldHarga.value[j].getInputNumber()!;
            skuCard.controller.mapSumTotalPrice[j] = skuCard.controller.mapSumPrice[j]! * skuCard.controller.mapSumNeeded[j]!;

            Timer(const Duration(milliseconds: 500), () {
                CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == skuCard.controller.spinnerCategories.value[j].controller.textSelected.value);
                skuCard.controller.getLoadSku(selectCategory!, j);
                if (skuCard.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.AYAM_UTUH ||skuCard.controller.spinnerCategories.value[j].controller.textSelected.value == AppStrings.BRANGKAS) {
                        skuCard.controller.editFieldJumlahAyam.value[j].controller.enable();
                        skuCard.controller.editFieldPotongan.value[j].controller.enable();
                  }
                skuCard.controller.editFieldKebutuhan.value[j].controller.enable();
                skuCard.controller.editFieldHarga.value[j].controller.enable();
             });
          }

            skuCard.controller.refreshtotalPurchase();
        });
        isLoadData.value =false;
      }
    }

  }
    void generateListProduct(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx = idx - 1;
      skuCard.controller.spinnerCategories.value[idx].controller
          .generateItems(mapListSku.value);
      skuCard.controller.editFieldHarga.value[idx].controller.addListener(() {
      });

    });

  }
  void generateListRemark(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx = idx - 1;
      skuCardRemark.controller.spinnerCategories.value[idx].controller
          .generateItems(mapListRemark.value);
      // skuCardRemark.controller.editFieldHarga.value[idx].controller.addListener(() {
      // });

    });

  }

  void getListCustomer() {
    Service.push(
        apiKey: 'userApi',
        service: ListApi.getListCustomerWithoutPage,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
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

            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                backgroundColor: Colors.red,);
            },
            onResponseError: (exception, stacktrace, id, packet) {
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
            Timer(const Duration(milliseconds: 100), () {
              skuCard
                  .controller
                  .spinnerCategories
                  .value[0]
                  .controller
                  .generateItems(mapList);

              skuCard.controller.setMaplist(listCategories.value);
              mapListSku.value = mapList;


              //Generate Card Remark
              skuCardRemark
                  .controller
                  .spinnerCategories
                  .value[0]
                  .controller
                  .generateItems(mapListRemark);

              skuCardRemark.controller.setMaplist(listCategoriesRemark.value);
              this.mapListRemark.value = mapListRemark;

              spinnerCategories.controller.generateItems(mapListRemark);

            });

            for(var result in listCategories.value){
              if(result!.name == AppStrings.LIVE_BIRD){
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
          onResponseError: (exception, stacktrace, id, packet) {
          },
          onTokenInvalid:Constant.invalidResponse()
      ),
    );
  }

  Future<void> getSku(String categoriId) async {
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
              Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                  snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
              isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar("Alert","Terjadi kesalahan internal",
                  snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
              isLoading.value = false;
            },
            onTokenInvalid: () {}
        )
    );
  }



  void saveEditOrder() {
    List ret = orderDetail.type! == "LB" ? validationLb() : validationNonLb();
    if (ret[0]) {
      isLoading.value = true;
      OrderRequest orderPayload = generatePayload();
      Service.push(
        service: ListApi.editSalesOrder,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathEditSalesOrder(orderDetail.id!), Mapper.asJsonString(orderPayload)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.back();
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

  OrderRequest generatePayload() {

    List<Products?> listProductLbPayload = [];
    List<Products?> listRemarkPayload = [];
    List<Products?> listProductPayload = [];

    if(orderDetail.type == "LB") {
      Products? produkSkuSelected = listProduct.value.firstWhere((element) =>
      element!.name == spinnerSku.controller.textSelected.value,);

      listProductLbPayload.add(Products(
        productItemId: produkSkuSelected!.id,
        quantity: editFieldJumlahAyam.getInputNumber()!.toInt(),
        numberOfCuts: 0,
        price: editFieldHarga.getInputNumber(),
        weight: editFieldKebutuhan.getInputNumber(),
      ));
    
    
      for (int i = 0; i < skuCardRemark.controller.itemCount.value; i++) {
        int whichItem = skuCardRemark.controller.index.value[i];
        List<Products?>? listProductTemp = skuCardRemark.controller.listSku.value[whichItem];
        Products? productSelected;
        if(listProductTemp != null){
          productSelected = listProductTemp.firstWhere((element) => element!.name! == skuCardRemark.controller.spinnerSku.value[whichItem].controller.textSelected.value);
        }
        listRemarkPayload.add(Products(
          productItemId: productSelected != null ? productSelected.id : orderDetail.productNotes![whichItem]!.id,
          quantity: productSelected!.category!.name! == AppStrings.AYAM_UTUH || productSelected.category!.name! == AppStrings.BRANGKAS || productSelected.category!.name! == AppStrings.LIVE_BIRD ? skuCardRemark.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt() : null,
          numberOfCuts: productSelected.category!.name! == AppStrings.AYAM_UTUH || productSelected.category!.name! == AppStrings.BRANGKAS || productSelected.category!.name! == AppStrings.LIVE_BIRD ? skuCardRemark.controller.editFieldPotongan.value[whichItem].getInputNumber()!.toInt() : null,
          weight: skuCardRemark.controller.editFieldKebutuhan.value[whichItem].getInputNumber(),
        ));
      }
    }else{

      for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
        int whichItem = skuCard.controller.index.value[i];
        List<Products?>? listProductTemp = skuCard.controller.listSku.value[whichItem];
        Products? productSelected;
        if(listProductTemp != null){
          productSelected = listProductTemp.firstWhere((element) => element!.name! == skuCard.controller.spinnerSku.value[whichItem].controller.textSelected.value);
        }
        listProductPayload.add(Products(
          productItemId: productSelected!.id,
          quantity: productSelected.category!.name! == AppStrings.AYAM_UTUH || productSelected.category!.name! == AppStrings.BRANGKAS ?skuCard.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt() : null,
          numberOfCuts: productSelected.category!.name! == AppStrings.AYAM_UTUH || productSelected.category!.name! == AppStrings.BRANGKAS ?skuCard.controller.editFieldPotongan.value[whichItem].getInputNumber()!.toInt():0,
          price: skuCard.controller.editFieldHarga.value[whichItem].getInputNumber(),
          weight: skuCard.controller.editFieldKebutuhan.value[whichItem].getInputNumber(),
        ));
      }
    }

    Customer? customerSelected = listCustomer.value.firstWhere(
          (element) => element!.businessName == spinnerCustomer.controller.textSelected.value,
    );

    return OrderRequest(
      operationUnitId: orderDetail.operationUnitId,
      customerId: customerSelected!.id!,
      products: orderDetail.type! == "LB" ? listProductLbPayload : listProductPayload,
      productNotes: orderDetail.type! == "LB" ? listRemarkPayload : null ,
      type: orderDetail.type! == "LB" ? "LB" : "NON_LB",
      status: status.value,
    );
  }


  List validationNonLb() {
    List ret = [true, ""];
    if (spinnerCustomer.controller.textSelected.value.isEmpty) {
      spinnerCustomer.controller.showAlert();
      spinnerCustomer.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }

    ret = skuCard.controller.validation();
    return ret;
  }

  List validationLb() {
    List ret = [true, ""];
    if (spinnerCustomer.controller.textSelected.value.isEmpty) {
      spinnerCustomer.controller.showAlert();
      spinnerCustomer.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }else if (spinnerCategories.controller.textSelected.value.isEmpty) {
      spinnerCategories.controller.showAlert();
      spinnerCategories.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }else if (spinnerSku.controller.textSelected.value.isEmpty) {
      spinnerSku.controller.showAlert();
      spinnerSku.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }else if (editFieldJumlahAyam.getInput().isEmpty) {
      editFieldJumlahAyam.controller.showAlert();
      editFieldJumlahAyam.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }else if (editFieldKebutuhan.getInput().isEmpty) {
      editFieldKebutuhan.controller.showAlert();
      editFieldKebutuhan.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }else if (editFieldHarga.getInput().isEmpty) {
      editFieldHarga.controller.showAlert();
      editFieldHarga.controller.focusNode.requestFocus();
      return ret = [false, ""];
    }

    ret = skuCardRemark.controller.validation();
    return ret;
  }


}

class EditDataSalesOrderBindings extends Bindings {
  BuildContext context;
  EditDataSalesOrderBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => EditDataSalesOrderController(context: context));
  }

}