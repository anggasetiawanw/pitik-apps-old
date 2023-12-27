import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
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
import 'package:model/internal_app/transfer_model.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
class TransferFormController extends GetxController {
    BuildContext context;
    TransferFormController({required this.context});

    OperationUnitModel? sourceSelect;
    
    late ButtonFill yesButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesButton"), label: "Ya", onClick: (){
    Get.back();
        if(isEdit.isTrue){
            updateTransfer("CONFIRMED");
        } else {
            createTransfer("CONFIRMED");
        }
    });
    ButtonOutline noButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("No Button"), label: "Tidak", onClick: (){
        Get.back();
    });
   
    late SpinnerField sourceField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("sourceTransfer"), label: "Sumber*", hint: "Pilih salah satu", alertText: "Sumber harus dipilih!", items: const {}, onSpinnerSelected: (value){
        sourceSelect = listSourceOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == sourceField.controller.textSelected.value);
        if(sourceSelect != null){
            Map<String, bool> mapList ={};
            for (var element in sourceSelect!.purchasableProducts!) {
              mapList[element!.name!] = false;
            }
            categorySKUField.controller.generateItems(mapList);
        }
    });

    late SpinnerField destinationField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("destinationTransfer"), label: "Tujuan*", hint: "Pilih salah satu", alertText: "Tujuan harus dipilih!", items: const {}, onSpinnerSelected: (value){
        // getCategorySKU();
        categorySKUField.controller.enable();
    });
    late SpinnerField categorySKUField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("categorySKU"), label: "Kategori SKU*", hint: "Pilih salah satu", alertText: "Kategori SKU harus dipilih!", items: const {}, onSpinnerSelected: (value){
        if(sourceSelect != null ){
            totalField.controller.enable();
            Products? products = sourceSelect!.purchasableProducts!.firstWhereOrNull((element) => element!.name! == value);
            if(products != null){
                Map<String, bool> mapList ={};
                for (var element in products.productItems!) { mapList[element!.name!] = false;}
                skuField.controller.generateItems(mapList);
                if( value == AppStrings.AYAM_UTUH || value == AppStrings.BRANGKAS || value == AppStrings.LIVE_BIRD  || value == AppStrings.KARKAS){
                    amountField.controller.enable();
                    skuField.controller.setTextSelected("");
                    skuField.controller.enable();
                }
                else if( value == AppStrings.KARKAS){
                    skuField.controller.setTextSelected("");
                    skuField.controller.enable();
                    amountField.setInput("");
                    amountField.controller.disable();
                }
                else {
                    amountField.setInput("");
                    amountField.controller.disable();
                    skuField.controller.disable();
                    skuField.controller.setTextSelected(products.name!);
                }
            }
        }
    });

    late SpinnerField skuField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("skuTransfer"), label: "SKU*", hint: "Pilih salah satu", alertText: "Sku harus dipilih!", items: const {}, onSpinnerSelected: (value){

    });
    
    EditField amountField = EditField(controller: GetXCreator.putEditFieldController("amountBirds"), label: "Jumlah Ekor*", hint: "0", alertText: "Jumlah Ekor harus diisi!", textUnit: "Ekor", maxInput: 20, onTyping: (value,controller){}, inputType: TextInputType.number,);
    EditField totalField = EditField(controller: GetXCreator.putEditFieldController("totalFields"), label: "Total*", hint: "0.0", alertText: "Total Kg harus diisi!", textUnit: "Kg", maxInput: 20, onTyping: (value,controller){}, inputType: TextInputType.number,);

    EditField efRemark = EditField(controller: GetXCreator.putEditFieldController("efRemark"), label: "Catatan", hint: "Ketik disini", alertText: "", textUnit: "", maxInput: 500, inputType: TextInputType.multiline, height: 160, onTyping: (value, editField) {});


    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<List<OperationUnitModel?>> listSourceOperationUnits = Rx<List<OperationUnitModel?>>([]);
    Rx<List<OperationUnitModel?>> listDestinationOperationUnits = Rx<List<OperationUnitModel?>>([]);
    var isLoading = false.obs;
    var isEdit = false.obs;

    TransferModel? transferModel;
    @override
    void onInit() {
        
        super.onInit();
        
        isLoading.value = true;
        transferModel = Get.arguments[0];
        isEdit.value = Get.arguments[1];
        categorySKUField.controller.disable();
        skuField.controller.disable();
        amountField.controller.disable();
        totalField.controller.disable();
        getListOperationUnit();
        getListDestinationOperationUnit();

    }
    @override
    void onReady() {
        super.onReady();

        if(isEdit.value){
            sourceField.controller.textSelected.value = transferModel!.sourceOperationUnit!.operationUnitName!;
            destinationField.controller.textSelected.value = transferModel!.targetOperationUnit!.operationUnitName!;
            destinationField.controller.enable();
            categorySKUField.controller.textSelected.value = transferModel!.products !=null ? transferModel!.products![0]!.name ?? "" :"";
            if( categorySKUField.controller.textSelected.value == AppStrings.AYAM_UTUH || categorySKUField.controller.textSelected.value == AppStrings.BRANGKAS|| categorySKUField.controller.textSelected.value == AppStrings.LIVE_BIRD|| categorySKUField.controller.textSelected.value == AppStrings.KARKAS){
                amountField.controller.enable();
                amountField.setInput(transferModel!.products![0]!.productItems![0]!.quantity!.toString());
            }
             Map<String, bool> mapList ={};
            for (var element in transferModel!.sourceOperationUnit!.purchasableProducts!) {
              mapList[element!.name!] = false;
            }
            totalField.controller.enable();
            totalField.setInput(transferModel!.products![0]!.productItems![0]!.weight!.toString());
            efRemark.setInput(transferModel!.remarks != null ? Uri.decodeFull(transferModel!.remarks!) : "");
        }
    }

    void getListOperationUnit() {
        sourceField.controller
        ..disable()
        ..showLoading();
        Service.push(
            service: ListApi.getListOperationUnits,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!,AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE,0],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    
                    Map<String, bool> mapList3 ={};
                    for (var units in (body as ListOperationUnitsResponse).data) {
                      mapList3[units!.operationUnitName!] = false;
                    }

                    for (var result in body.data) {
                        listSourceOperationUnits.value.add(result);
                    }
                    Timer(const Duration(milliseconds: 500), () {
                        sourceField.controller
                        ..enable()
                        ..hideLoading()
                        ..generateItems(mapList3);
                    });

                    if(isEdit.isTrue){
                        sourceSelect = listSourceOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == transferModel!.sourceOperationUnit!.operationUnitName!);
                        if(sourceSelect != null){
                            skuField.controller.showLoading();
                            Map<String, bool> mapList ={};
                            for (var element in sourceSelect!.purchasableProducts!) {
                              mapList[element!.name!] = false;
                            }
                            Timer(const Duration(milliseconds: 1000), () {
                                categorySKUField.controller.generateItems(mapList);
                                categorySKUField.controller.items.refresh();
                                categorySKUField.controller.enable();
                                refresh();
                            });
                            Products? products = sourceSelect!.purchasableProducts!.firstWhereOrNull((element) => element!.name! == transferModel!.products![0]!.name);
                            Timer(const Duration(milliseconds: 500), () { 
                                Map<String, bool> mapList2 ={};
                                for (var element in products!.productItems!) { mapList2[element!.name!] = false;}
                                skuField.controller.generateItems(mapList2);
                                skuField.controller.textSelected.value = transferModel!.products![0]!.productItems != null ? transferModel!.products![0]!.productItems![0]!.name! : "";
                                skuField.controller.hideLoading();
                                skuField.controller.enable();
                                refresh();
                            });
                        }
                    }
                    sourceField.controller
                    .showLoading();
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
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                     isLoading.value = false;
                        sourceField.controller
                        .showLoading();
                },
                onTokenInvalid: Constant.invalidResponse()
                )
        );
    }

    void getListDestinationOperationUnit() {
        destinationField.controller
        ..disable()
        ..showLoading();
        Service.push(
            service: ListApi.getListDestionTransfer,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {

                     Map<String, bool> mapList ={};
                    for (var units in (body as ListOperationUnitsResponse).data) {
                      mapList[units!.operationUnitName!] = false;
                    }
                    for (var result in body.data) {
                        listDestinationOperationUnits.value.add(result);
                    } 
                    Timer(const Duration(milliseconds: 500), () {
                        destinationField.controller
                        ..enable()
                        ..hideLoading()
                        ..generateItems(mapList);
                    });
                    isLoading.value = false;
                    refresh();
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
                    destinationField.controller
                    ..enable()
                    ..hideLoading();
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
                    destinationField.controller
                    ..enable()
                    ..hideLoading();
                },
                onTokenInvalid: Constant.invalidResponse()
            )
        );
    }  

    void createTransfer(String status){
        if(validation()){
            isLoading.value =true;
            Service.push(
                service: ListApi.createTransfer,
                context: context,
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, Mapper.asJsonString(generatePayload(status))],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        Get.back();
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
                    onTokenInvalid: Constant.invalidResponse()));
        }
    }

    void updateTransfer(String status){
        if(validation()){
            Service.push(
                service: ListApi.updateTransferById,
                context: context,
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateTransferByid(transferModel!.id!), Mapper.asJsonString(generatePayload(status))],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        Get.back();
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
                    onTokenInvalid: Constant.invalidResponse()));
        } else {
            isLoading.value = false;
        }
    }

    TransferModel generatePayload(String status){
        OperationUnitModel? selectSource = listSourceOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == sourceField.controller.textSelected.value);
        OperationUnitModel? selectDestination = listDestinationOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == destinationField.controller.textSelected.value);
        Products? selectProduct = sourceSelect!.purchasableProducts!.firstWhereOrNull((element) => element!.name == categorySKUField.controller.textSelected.value,);
        Products? selectItem = selectProduct!.productItems!.firstWhereOrNull((element) => element!.name == skuField.controller.textSelected.value);
        return TransferModel(
            sourceOperationUnitId: selectSource!.id,
            targetOperationUnitId: selectDestination!.id,
            status: status,
            remarks: Uri.encodeFull(efRemark.getInput()),
            products: [Products(
                productItemId: selectItem!.id,
                quantity: selectProduct.name == AppStrings.AYAM_UTUH || selectProduct.name == AppStrings.BRANGKAS || selectProduct.name == AppStrings.LIVE_BIRD || selectProduct.name == AppStrings.KARKAS? amountField.getInputNumber()!.toInt() : null,
                weight:  totalField.getInputNumber()
            )]
        );
    }

    bool validation(){
        if (sourceField.controller.textSelected.value.isEmpty) {
            sourceField.controller.showAlert();
            Scrollable.ensureVisible(sourceField.controller.formKey.currentContext!);
            
            return false;
        }  

        if (destinationField.controller.textSelected.value.isEmpty) {
            destinationField.controller.showAlert();
            Scrollable.ensureVisible(destinationField.controller.formKey.currentContext!);

            return false;
        }  

        if (categorySKUField.controller.textSelected.value.isEmpty) {
            categorySKUField.controller.showAlert();
            Scrollable.ensureVisible(categorySKUField.controller.formKey.currentContext!);

            return false;
        }
        if( categorySKUField.controller.textSelected.value == AppStrings.AYAM_UTUH || categorySKUField.controller.textSelected.value == AppStrings.BRANGKAS || categorySKUField.controller.textSelected.value == AppStrings.LIVE_BIRD){
            if (amountField.getInput().isEmpty ) {
                amountField.controller.showAlert();
                Scrollable.ensureVisible(amountField.controller.formKey.currentContext!);

                return false;
            }
        }
        
        if (totalField.getInput().isEmpty) {
            totalField.controller.showAlert();
            Scrollable.ensureVisible(totalField.controller.formKey.currentContext!);

            return false;
        }

        return true;
    }
}
class TransferFormBindings extends Bindings {
    BuildContext context;
    TransferFormBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => TransferFormController(context: context));
    }
}