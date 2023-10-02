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
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/customer_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/order_request.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/customer_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/order_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/internal_controller_creator.dart';
import 'package:pitik_internal_app/widget/sku_book_so/sku_book_so.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 25/05/23

class CreateBookStockController extends GetxController{
    BuildContext context;
    CreateBookStockController({required this.context});

    Rxn<Order> orderDetail = Rxn<Order>();
    ScrollController scrollController = ScrollController();
    late SkuBookSO skuBookSO; 
    late SkuBookSO skuBookSOLB;
    var isLoading = false.obs;

    late ButtonFill bookStockButton = ButtonFill(
        controller: GetXCreator.putButtonFillController("bookStocked"),
        label: "Pesan Stock",
        onClick: () => Get.toNamed(RoutePage.newBookStock, arguments: orderDetail.value!)!.then((value) {
            isLoading.value =true;
            Timer(const Duration(milliseconds: 500), () {
            getDetailOrder();
            });
        })
    );

    late SpinnerField spinnerSource  = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("sumberPenjualan"),
        label: "Sumber*",
        hint: "Pilih salah satu",
        alertText: "Sumber harus dipilih!",
        items: const {
        },
        onSpinnerSelected: (text) {
        if (text.isNotEmpty) {
            bookStockButton.controller.enable();
            Map<String, bool> mapLisCustomer = {};
            for (var product in listCustomer.value) {
              mapLisCustomer[product!.businessName!] = false;
            }
            Timer(const Duration(milliseconds: 100), () {
            spinnerCustomer.controller.generateItems(mapLisCustomer);
            });
        }
        },
    );

    late SpinnerField spinnerCustomer  = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("customerPenjualan"),
        label: "Customer*",
        hint: "Pilih salah satu",
        alertText: "Customer harus dipilih!",
        items: const {
        },
        onSpinnerSelected: (text) {
        if (text.isNotEmpty) {
            bookStockButton.controller.enable();
        }
        },
    );

    late ButtonFill bfYesBook;
    late ButtonOutline boNoBook;

    Rx<List<OperationUnitModel?>> listSource = Rx<List<OperationUnitModel>>([]);
    Rx<List<Customer?>> listCustomer = Rx<List<Customer>>([]);

    @override
    void onInit() {
        super.onInit();
        isLoading.value = true;
        orderDetail.value = Get.arguments as Order;
        getListSource();
        getListCustomer();
        getDetailOrder();
        spinnerCustomer.controller.disable();
        bookStockButton.controller.disable();
        boNoBook = ButtonOutline(
        controller: GetXCreator.putButtonOutlineController("noBookStock"),label: "Tidak",onClick: () {
            Get.back();
            },
        );
        skuBookSO = SkuBookSO(controller: InternalControllerCreator.putSkuBookSOController("skuBookSO", orderDetail.value!.products!));
        if(orderDetail.value!.type! =="LB"){
            skuBookSOLB = SkuBookSO(controller: InternalControllerCreator.putSkuBookSOController("LBSKUSTOCK", orderDetail.value!.productNotes!));
        } 
    }


    @override
    void onReady() {
        super.onReady();
        getListSource();
        getListCustomer();
        bfYesBook = ButtonFill(
        controller: GetXCreator.putButtonFillController("yesBookStock"),
            label: "Ya",
            onClick: () {
                Get.back();
                updateBookStock();
            },
        );
    }

    void getDetailOrder(){
        isLoading.value = true;
        Service.push(
            service: ListApi.detailOrderById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, ListApi.pathDetailOrderById(orderDetail.value!.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                isLoading.value = false;
                orderDetail.value = (body as OrderResponse).data;
                },
                onResponseFail: (code, message, body, id, packet){
                isLoading.value = false;
                Get.snackbar(
                    "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                },  onTokenInvalid: Constant.invalidResponse())
        );
    }

    void getListSource() {
        Service.push(
            service: ListApi.getListOperationUnits,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE],
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
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                },
                onTokenInvalid: Constant.invalidResponse()
            )
        );
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
                spinnerCustomer.controller.generateItems(mapList);
                spinnerCustomer.controller.setTextSelected(orderDetail.value!.customer!.businessName!);

                for (var result in body.data) {
                    listCustomer.value.add(result!);
                }

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
                    Get.snackbar("Alert","Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                },
                onTokenInvalid: () {
                Constant.invalidResponse();
                }
            )
        );
    }

    void updateBookStock(){
        OperationUnitModel? sourceSelected = listSource.value.firstWhere(
                (element) => element!.operationUnitName == spinnerSource.controller.textSelected.value
        );

        Customer? customerSelected = listCustomer.value.firstWhere(
            (element) => element!.businessName == spinnerCustomer.controller.textSelected.value,
        );
        List<Products?> products =[];

        for(int i = 0 ; i < skuBookSO.controller.itemCount.value; i++){
            products.add(
                Products(
                    productItemId: orderDetail.value!.products![i]!.id,
                    quantity: (skuBookSO.controller.jumlahEkor.value[i].getInputNumber() ?? 0).toInt(),
                    weight: skuBookSO.controller.jumlahkg.value[i].getInputNumber() ?? 0,
                    price: orderDetail.value!.products![i]!.price
                )
            );
        }
        

        OrderRequest orderRequest = OrderRequest(
            customerId: customerSelected!.id!,
            operationUnitId: sourceSelected!.id!,
            products: products,
        );

        if(orderDetail.value!.type == "LB"){
            List<Products?> productNote =[];

            for(int i = 0 ; i < skuBookSOLB.controller.itemCount.value; i++){
                productNote.add(
                    Products(
                        productItemId: orderDetail.value!.products![i]!.id,
                        quantity: (skuBookSOLB.controller.jumlahEkor.value[i].getInputNumber() ?? 0).toInt(),
                        weight: skuBookSOLB.controller.jumlahkg.value[i].getInputNumber() ?? 0,
                        price: orderDetail.value!.products![i]!.price
                    )
                );
            }
            orderRequest.productNotes = productNote;
        }

        Service.push(
            service: ListApi.bookStockSalesOrder,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, ListApi.pathBookStock(orderDetail.value!.id!), Mapper.asJsonString(orderRequest)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                Get.back();
                isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                    "Pesan",
                    "Terjadi Kesalahan, ${(body).error!.message}",
                    snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                    
                isLoading.value = false;
                },
                onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                    "Pesan",
                    "Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,);
                isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));


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