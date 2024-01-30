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
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/terminate_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/media_field.dart';
class TerminateFormController extends GetxController {
    BuildContext context;
    TerminateFormController({required this.context});
    OperationUnitModel? sourceSelect;
    late ButtonFill yesButton = ButtonFill(controller: GetXCreator.putButtonFillController("yesButton"), label: "Ya", onClick: (){
        GlobalVar.track("Click_Konfirmasi_Pemusnahan");
        Get.back();
        if(isEdit.isTrue){
            updateTerminate("CONFIRMED");
        } else {
            createTerminate("CONFIRMED");
        }
    });
    ButtonOutline noButton = ButtonOutline(controller: GetXCreator.putButtonOutlineController("No Button"), label: "Tidak", onClick: (){
        Get.back();
    });

    late SpinnerField sourceField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("sourceTransfer"), label: "Sumber*", hint: "Pilih salah satu", alertText: "Sumber harus dipilih!", items: const {}, onSpinnerSelected: (value){
            sourceSelect = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == sourceField.controller.textSelected.value);
            if(sourceSelect != null){
                Map<String, bool> mapList ={};
                for (var element in sourceSelect!.purchasableProducts!) {
                  mapList[element!.name!] = false;
                }
                categorySKUField.controller.generateItems(mapList);
                categorySKUField.controller.enable();
            }
        });

    late SpinnerField categorySKUField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("categorySKU"), label: "Kategori SKU*", hint: "Pilih salah satu", alertText: "Kategori SKU harus dipilih!", items: const {}, onSpinnerSelected: (value){
        if(sourceSelect != null ){
            totalField.controller.enable();
            Products? products = sourceSelect!.purchasableProducts!.firstWhereOrNull((element) => element!.name! == value);
            if(products != null){
                Map<String, bool> mapList ={};
                for (var element in products.productItems!) { mapList[element!.name!] = false;}
                skuField.controller.generateItems(mapList);
                if( value == AppStrings.AYAM_UTUH || value == AppStrings.BRANGKAS || value == AppStrings.LIVE_BIRD || value == AppStrings.KARKAS){
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

    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<List<OperationUnitModel?>> listOperationUnits = Rx<List<OperationUnitModel?>>([]);
    Rx<MediaUploadModel> mediaUploadData = Rx<MediaUploadModel>(MediaUploadModel());
    var isLoading = false.obs;
    var isLoadingPicture = false.obs;
    var isEdit = false.obs;
    late MediaField mediaField = MediaField(controller: GetXCreator.putMediaFieldController("photoPemusnahan"), onMediaResult: (value){
        if(value != null) {
            isLoadingPicture.value = true;
            Service.push(
                service: ListApi.uploadImage,
                context: context,
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, "downstream-disposal", value],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        mediaUploadData.value = body.data;
                        if(isEdit.isTrue){
                            terminateModel?.imageLink = mediaUploadData.value.url;
                        }
                        isLoadingPicture.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,);
                        isLoadingPicture.value = false;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                            "Pesan",
                            "Terjadi kesalahan internal",
                            snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                            colorText: Colors.white,
                            backgroundColor: Colors.red,);
                        isLoadingPicture.value = false;
                    },
                    onTokenInvalid: Constant.invalidResponse()));
        }
    }, label: "", hint: "Upload Bukti Photo", alertText: "Bukti Photo harus disertakan", showGallerOptions: false, type: 2,);
    TerminateModel? terminateModel;

    DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();

    @override
    void onInit() {
        super.onInit();
        isLoading.value = true;
        terminateModel = Get.arguments[0];
        isEdit.value = Get.arguments[1];
        categorySKUField.controller.disable();
        skuField.controller.disable();
        amountField.controller.disable();
        totalField.controller.disable();
        mediaField.controller.disable();

    }
    @override
    void onReady() {
        super.onReady();
        if(isEdit.value){
            isLoading.value = true;
            // getCategorySKU();
            sourceField.controller.textSelected.value = terminateModel!.operationUnit!.operationUnitName!;
            categorySKUField.controller.enable();
            categorySKUField.controller.textSelected.value = terminateModel!.product!.name!;
            if (terminateModel!.product!.name! == AppStrings.AYAM_UTUH || terminateModel!.product!.name! == AppStrings.BRANGKAS || terminateModel!.product!.name! == AppStrings.LIVE_BIRD|| terminateModel!.product!.name! == AppStrings.KARKAS) {
                amountField.controller.enable();
                amountField.setInput(terminateModel!.product!.productItem!.quantity.toString());
            }
            skuField.controller.textSelected.value = terminateModel!.product!.productItem != null ? terminateModel!.product!.productItem!.name! : "";
            totalField.controller.enable();
            totalField.setInput((terminateModel!.product!.productItem!.weight ?? 0).toString());
        }

        getListSourceUnit();
    }

    void getListSourceUnit() {
        sourceField.controller
        ..disable()
        ..showLoading();
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
                    for (var result in body.data) {
                        listOperationUnits.value.add(result);
                    }
                    Timer(const Duration(milliseconds: 500), () {
                        sourceField.controller
                        ..enable()
                        ..hideLoading()
                        ..generateItems(mapList);
                    });
                    if(isEdit.isTrue){
                        sourceSelect = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == terminateModel!.operationUnit!.operationUnitName!);
                        if(sourceSelect != null){
                            Map<String, bool> mapList ={};
                            for (var element in sourceSelect!.purchasableProducts!) {
                              mapList[element!.name!] = false;
                            }
                            Timer(const Duration(milliseconds: 500), () {
                                categorySKUField.controller.generateItems(mapList);
                                categorySKUField.controller.items.refresh();
                            });
                        }
                    }
                    isLoading.value = false;
                    timeEnd = DateTime.now();
                    Duration totalTime = timeEnd.difference(timeStart);
                    GlobalVar.trackRenderTime("Buat_Pemusnahan", totalTime);
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
                },
                onTokenInvalid: Constant.invalidResponse()
                )
        );
    }

    void getCategorySKU() {
        categorySKUField.controller
        ..disable()
        ..showLoading();
        Service.push(
            service: ListApi.getCategories,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    for (var result in (body as CategoryListResponse).data) {
                    listCategories.value.add(result);
                    }
                    Map<String, bool> mapList = {};
                    for (var product in body.data) {
                      mapList[product!.name!] = false;
                    }
                    categorySKUField.controller
                    ..generateItems(mapList)
                    ..hideLoading()
                    ..enable();
                    isLoading.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                    categorySKUField.controller
                    .hideLoading();
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
                    categorySKUField.controller
                    .hideLoading();
                },
                onTokenInvalid: Constant.invalidResponse()));
    }

    void createTerminate(String status){

        if(validation()){
            isLoading.value =true;
            Service.push(
                service: ListApi.createTerminate,
                context: context,
                body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, Mapper.asJsonString(generatePayload(status))],
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

    void updateTerminate(String status){
        isLoading.value = true;
        Service.push(
            service: ListApi.updateTerminateById,
            context: context,
            body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateTerminateById(terminateModel!.id!), Mapper.asJsonString(generatePayload(status))],
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
                        "Terjadi kesalahan internal",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        colorText: Colors.white,
                        backgroundColor: Colors.red,);
                    isLoading.value = false;
                },
                onTokenInvalid: Constant.invalidResponse()));
    }

    TerminateModel generatePayload(String status){
        OperationUnitModel? selectSource = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == sourceField.controller.textSelected.value);
         Products? selectProduct = sourceSelect!.purchasableProducts!.firstWhereOrNull((element) => element!.name == categorySKUField.controller.textSelected.value,);
        Products? selectItem = selectProduct!.productItems!.firstWhereOrNull((element) => element!.name == skuField.controller.textSelected.value);
        return TerminateModel(
            operationUnitId: selectSource!.id,
            status: status,
            product: Products(
                productItemId: selectItem!.id,
                quantity:  selectProduct.name == AppStrings.AYAM_UTUH || selectProduct.name == AppStrings.BRANGKAS || selectProduct.name == AppStrings.LIVE_BIRD ? amountField.getInputNumber()!.toInt() : null,
                weight: totalField.getInputNumber()
            ),
            imageLink: isEdit.isFalse? mediaUploadData.value.url! : mediaField.controller.fileName.isNotEmpty ? mediaUploadData.value.url! : terminateModel!.imageLink ,
        );
    }

    bool validation(){
        if (sourceField.controller.textSelected.value.isEmpty) {
            sourceField.controller.showAlert();
            Scrollable.ensureVisible(sourceField.controller.formKey.currentContext!);
            return false;
        }
        if (categorySKUField.controller.textSelected.value.isEmpty) {
            categorySKUField.controller.showAlert();
            Scrollable.ensureVisible(categorySKUField.controller.formKey.currentContext!);
            return false;
        }

        if( categorySKUField.controller.textSelected.value == AppStrings.AYAM_UTUH || categorySKUField.controller.textSelected.value == AppStrings.BRANGKAS || categorySKUField.controller.textSelected.value == AppStrings.LIVE_BIRD){
            if (amountField.getInput().isEmpty) {
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

        if(isEdit.isFalse){
            if(mediaField.controller.fileName.isEmpty){
                mediaField.controller.showAlert();
                return false;
            }
        }

        return true;
    }
}
class TerminateFormBindings extends Bindings {
    BuildContext context;
    TerminateFormBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => TerminateFormController(context: context));
    }
}