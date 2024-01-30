import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/manufacture_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/stock_model.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:model/response/internal_app/stock_aggregate_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
class ManufactureEditFromController extends GetxController {
    BuildContext context;
    ManufactureEditFromController({required this.context});

    late ManufactureModel manufactureModel;
    Rx<List<OperationUnitModel?>> listOperationUnits = Rx<List<OperationUnitModel?>>([]);
    Rx<List<StockModel?>> listSkuStock = Rx<List<StockModel?>>([]);
    StockModel? categorySelect;
    OperationUnitModel? sourceModel;
    var isLoading = false.obs;

    late ButtonFill yesButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesButton"), label: "Ya", onClick: (){
        GlobalVar.track("Click_Konfirmasi_Edit_Manufaktur");
        Get.back();
        updateManufacture("INPUT_CONFIRMED");
    });
    ButtonOutline noButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("No Button"), label: "Tidak", onClick: (){Get.back();});

    late SpinnerField sourceField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("sourceTransfer"), label: "Sumber*", hint: "Pilih salah satu", alertText: "Sumber harus dipilih!", items: const {}, onSpinnerSelected: (value){
        if (listOperationUnits.value.isNotEmpty) {
            OperationUnitModel? selectUnit = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName! == value);
            if (selectUnit != null) {
                getCategorySKU(selectUnit.id!);
            }
        }
    });
    late SpinnerField categorySKUField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("categorySKU"), label: "Kategori SKU*", hint: "Pilih salah satu", alertText: "Kategori SKU harus dipilih!",isDetail: true, items: const {}, onSpinnerSelected: (value){
         categorySelect = listSkuStock.value.firstWhereOrNull((element) => element!.productCategoryName! == value);
        if(categorySelect != null){
            Map<String, bool> mapList = {};
            Map<String, int> mapListAmount = {};
            Map<String, double> mapListWeight = {};
            for (var units in categorySelect!.productItems!) {
                mapList[units!.name!] = false;
                mapListAmount[units.name!] = units.availableQuantity!;
                mapListWeight[units.name!] = units.availableWeight!;
            }
            skuField.controller.generateAmount(mapListAmount);
            skuField.controller.generateWeight(mapListWeight);
            skuField.controller.generateItems(mapList);
            if( value == AppStrings.AYAM_UTUH || value == AppStrings.BRANGKAS || value == AppStrings.LIVE_BIRD){
                amountField.controller.enable();
                skuField.controller.setTextSelected("");
                skuField.controller.enable();
                totalField.setInput("");
                totalField.controller.disable();
            }
            else {
                skuField.controller.setTextSelected(categorySelect!.productItems![0]!.name!);
                amountField.controller.disable();
                skuField.controller.disable();
                totalField.controller.enable();
            }

        }
    });

    late SpinnerField skuField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("skuField"), label: "SKU*", hint: "Pilih salah satu", alertText: "SKU harus dipilih!",isDetail: true, items: const {}, onSpinnerSelected: (value){

    });

    EditField amountField = EditField(controller: GetXCreator.putEditFieldController("amountBirds"), label: "Jumlah Ekor*", hint: "Tulis Jumlah", alertText: "Jumlah Ekor harus diisi!", textUnit: "Ekor", maxInput: 20, onTyping: (value,controller){}, inputType: TextInputType.number,);
    EditField totalField = EditField(controller: GetXCreator.putEditFieldController("totalFields"), label: "Total*", hint: "Tulis Jumlah", alertText: "Total Kg harus diisi!", textUnit: "Kg", maxInput: 20, onTyping: (value,controller){}, inputType: TextInputType.number,);

    int countApi = 0;
    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

    @override
    void onInit() {
        super.onInit();
        manufactureModel = Get.arguments;
        // categorySKUField.controller.disable();
        // skuField.controller.disable();
    }
    @override
    void onReady() {
        super.onReady();
        isLoading.value =true;
        getListSourceUnit();
        WidgetsBinding.instance.addPostFrameCallback((_) {
            sourceField.controller.setTextSelected(manufactureModel.operationUnit!.operationUnitName!);
            categorySKUField.controller.setTextSelected(manufactureModel.input!.name!);
            skuField.controller.setTextSelected(manufactureModel.input!.productItems![0]!.name!);
            amountField.setInput(manufactureModel.input!.productItems![0]!.quantity.toString());
            totalField.setInput(manufactureModel.input!.productItems![0]!.weight.toString());
            Timer(const Duration(milliseconds: 500), () {
                getCategorySKU(manufactureModel.operationUnit!.id!);
             });
        });

    }

    void countingAPI(){
        countApi++;
        if(countApi == 2){
            timeEnd = DateTime.now();
            Duration totalTime = timeEnd.difference(timeStart);
            GlobalVar.trackRenderTime("Manufacture_Edit_Form", totalTime);
        }
    }

    void getListSourceUnit() {
        Service.push(
            service: ListApi.getListOperationUnits,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE,0],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    Map<String, bool> mapList = {};
                    for (var units in (body as ListOperationUnitsResponse).data) {
                      mapList[units!.operationUnitName!] = false;
                    }
                    sourceField.controller.generateItems(mapList);

                    for (var result in body.data) {
                        listOperationUnits.value.add(result);
                    }

                    sourceModel  = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName! == manufactureModel.operationUnit!.operationUnitName);
                    countingAPI();

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

    void getCategorySKU(String id) {
        Service.push(
            service: ListApi.getListStockAggregateByUnit,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetListStockByUnit(id)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    if( (body as ListStockAggregateResponse).data.isNotEmpty){
                        Map<String, bool> mapList = {};
                        Map<String, int> mapListAmount = {};
                        Map<String, double> mapListWeight = {};
                        for (var units in (body).data) {
                            mapList[units!.productCategoryName!] = false;
                            mapListAmount[units.productCategoryName!] = units.totalQuantity!;
                            mapListWeight[units.productCategoryName!] = units.totalWeight!;
                        }
                        categorySKUField.controller.generateAmount(mapListAmount);
                        categorySKUField.controller.generateWeight(mapListWeight);
                        categorySKUField.controller.generateItems(mapList);
                        categorySKUField.controller.enable();
                        for (var result in body.data) {
                            listSkuStock.value.add(result);
                        }
                        if (sourceModel != null) {
                            categorySelect = listSkuStock.value.firstWhereOrNull((element) => element!.productCategoryName! == manufactureModel.input!.name);
                            if(categorySelect != null){
                                Map<String, bool> mapList = {};
                                Map<String, int> mapListAmount = {};
                                Map<String, double> mapListWeight = {};
                                for (var units in categorySelect!.productItems!) {
                                    mapList[units!.name!] = false;
                                    mapListAmount[units.name!] = units.availableQuantity!;
                                    mapListWeight[units.name!] = units.availableWeight!;
                                }
                                skuField.controller.generateAmount(mapListAmount);
                                skuField.controller.generateWeight(mapListWeight);
                                skuField.controller.generateItems(mapList);
                            }
                        }
                        else {
                            categorySKUField.controller.disable();
                            skuField.controller.disable();
                        }
                    } else {
                            Get.snackbar(
                        "Info",
                        "STOCK Tidak Tersedia!",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                        categorySKUField.controller.setTextSelected("");
                        categorySKUField.controller.disable();
                    }
                    isLoading.value = false;
                    countingAPI();
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
                        "Something Wrong,$exception}",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }

    void updateManufacture(String status){
        if(validation()){
            isLoading.value = true;
            Service.push(
                service: ListApi.updateManufactureById,
                context: context,
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateManufactureById(manufactureModel.id!), Mapper.asJsonString(generatePayload(status))],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        isLoading.value =false;
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

                        isLoading.value =false;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi kesalahan internal",
                            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,);
                        isLoading.value =false;
                    },
                    onTokenInvalid: Constant.invalidResponse()));
        }
    }

    ManufactureModel generatePayload(String status){

        if(manufactureModel.operationUnit!.operationUnitName != sourceField.controller.textSelected.value ) {
            OperationUnitModel? selectSource;
            selectSource= listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == sourceField.controller.textSelected.value,);
            manufactureModel.operationUnit!.id = selectSource!.id;
        }

        if(manufactureModel.input!.productItems![0]!.name != skuField.controller.textSelected.value){
            StockModel? selectStock = categorySelect!.productItems!.firstWhereOrNull((element) => element!.name == skuField.controller.textSelected.value,);
            manufactureModel.input!.productItems![0]!.id = selectStock!.productItemId!;
        }

        if(manufactureModel.input!.productItems![0]!.quantity != amountField.getInputNumber()!.toInt()) {
            manufactureModel.input!.productItems![0]!.quantity = amountField.getInputNumber()!.toInt();
        }

        if(manufactureModel.input!.productItems![0]!.weight != totalField.getInputNumber()){
            manufactureModel.input!.productItems![0]!.weight = totalField.getInputNumber();
        }
        manufactureModel.status = status;

        return ManufactureModel(
            operationUnitId: manufactureModel.operationUnit!.id,
            status: status,
            input: Products(
                productItemId: manufactureModel.input!.productItems![0]!.id,
                quantity:  manufactureModel.input!.productItems![0]!.quantity,
                weight:  manufactureModel.input!.productItems![0]!.weight,
            ),
            output: []
        );
    }

    bool validation(){
        if (sourceField.controller.textSelected.value.isEmpty) {
            sourceField.controller.showAlert();
            sourceField.controller.focusNode.requestFocus();
            return false;
        }
        if (categorySKUField.controller.textSelected.value.isEmpty) {
            categorySKUField.controller.showAlert();
            categorySKUField.controller.focusNode.requestFocus();
            return false;
        }else if(categorySKUField.controller.textSelected.value == "Ceker" || categorySKUField.controller.textSelected.value == "Kepala" || categorySKUField.controller.textSelected.value == "Hati Ampela" || categorySKUField.controller.textSelected.value == "Karkas"){
            categorySKUField.controller.setAlertText("Produk ini tidak bisa di manufaktur!");
            categorySKUField.controller.showAlert();
            categorySKUField.controller.focusNode.requestFocus();

            return false;
        }

        if( categorySKUField.controller.textSelected.value == AppStrings.AYAM_UTUH || categorySKUField.controller.textSelected.value == AppStrings.BRANGKAS || categorySKUField.controller.textSelected.value == AppStrings.LIVE_BIRD){
            if (amountField.getInput().isEmpty) {
                amountField.controller.showAlert();
                amountField.controller.focusNode.requestFocus();
                return false;
            }
        }
        if (totalField.getInput().isEmpty) {
            totalField.controller.showAlert();
            totalField.controller.focusNode.requestFocus();
            return false;
        }
        return true;
    }
}
class ManufactureEditFormBindings extends Bindings {
    BuildContext context;
    ManufactureEditFormBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => ManufactureEditFromController(context: context));
    }
}