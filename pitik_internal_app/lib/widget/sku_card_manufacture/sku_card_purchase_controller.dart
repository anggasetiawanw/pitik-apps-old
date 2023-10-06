import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 11/04/23

class SkuCardManufactureController extends GetxController{

    String tag;
    BuildContext context;
    SkuCardManufactureController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<SpinnerField>> spinnerCategories = Rx<List<SpinnerField>>([]);
    Rx<List<SpinnerField>> spinnerSku = Rx<List<SpinnerField>>([]);
    Rx<List<EditField>> editFieldJumlahAyam = Rx<List<EditField>>([]);
    Rx<List<EditField>> editFieldJumlahKg = Rx<List<EditField>>([]);
    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel?>>([]);
    Rx<Map<int, List<Products?>>> listSku = Rx<Map<int, List<Products?>>>({});

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = true.obs;
    var isLoadApi = false.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void invisibleCard() => isShow.value = false;

    var idx= 0.obs;
    @override
    void onInit() {
        super.onInit();
        addCard();
    }



    addCard() {
        index.value.add(idx.value);
        int numberList = idx.value;
        spinnerCategories.value.add(
        SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("spin${numberList}SKU"),
            label: "Kategori SKU*",
            hint: "Pilih Salah Satu",
            alertText: "Kategori SKU harus dipilih!",
            items: const {},
            onSpinnerSelected: (value) {
                if (listCategories.value.isNotEmpty) {
                    CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == value); 
                    getSku(selectCategory!, numberList);
                    if (value == AppStrings.LIVE_BIRD ||
                        value == AppStrings.AYAM_UTUH ||
                        value == AppStrings.BRANGKAS) {
                        editFieldJumlahAyam.value[numberList].controller.enable();
                        editFieldJumlahKg.value[numberList].controller.enable();
                    }else{
                        editFieldJumlahAyam.value[numberList].controller.disable();
                        editFieldJumlahKg.value[numberList].controller.enable();
                    }                 
                    editFieldJumlahAyam.value[numberList].setInput("");
                    editFieldJumlahKg.value[numberList].setInput("");
                }
            }
        ),
        );

        spinnerSku.value.add(
        SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("size${numberList}SKU"),
            label: "SKU*",
            hint: "Pilih Salah Satu",
            alertText: "Ukuran harus dipilih!",
            items: const {},
            onSpinnerSelected: (value) {
            }
        ),
        );

        editFieldJumlahAyam.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editJumlah${numberList}Sku"),
            label: "Jumlah Ekor*",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "Ekor",
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {
            }
            ));

        editFieldJumlahKg.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editJenis${numberList}Sku"),
            label: "Jumlah Kg*",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "Kg",
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {

            }));

        spinnerSku.value[numberList].controller.disable();
        editFieldJumlahAyam.value[numberList].controller.disable();
        editFieldJumlahKg.value[numberList].controller.disable();
        itemCount.value = index.value.length;
        idx.value++;
    }

    

    removeCard(int idx) {
        index.value.removeWhere((item) => item == idx);
        itemCount.value = index.value.length;

    }

    setMaplist(List<CategoryModel?> map) {
        listCategories.value = map;
    }

    List validation() {
        bool isValid = true;
        String error = "";
        final temp = <String>[];
        for (int i = 0; i < index.value.length; i++) {
        int whichItem = index.value[i];
        if (spinnerCategories.value[whichItem].controller.textSelected.value.isEmpty) {
            spinnerCategories.value[whichItem].controller.showAlert();
            Scrollable.ensureVisible(spinnerCategories.value[whichItem].controller.formKey.currentContext!);
            isValid = false;
            return [isValid, error];
        }

        if (spinnerSku.value[whichItem].controller.textSelected.value.isEmpty) {
            spinnerSku.value[whichItem].controller.showAlert();
            Scrollable.ensureVisible(spinnerSku.value[whichItem].controller.formKey.currentContext!);
            isValid = false;
            return [isValid, error];
        }

        
        if (spinnerSku.value[whichItem].controller.textSelected.value == AppStrings.LIVE_BIRD ||
            spinnerSku.value[whichItem].controller.textSelected.value == AppStrings.AYAM_UTUH ||
            spinnerSku.value[whichItem].controller.textSelected.value == AppStrings.BRANGKAS) {
            if (editFieldJumlahAyam.value[whichItem]
                .getInput()
                .isEmpty) {
            editFieldJumlahAyam.value[whichItem].controller.showAlert();
            Scrollable.ensureVisible(editFieldJumlahAyam.value[whichItem].controller.formKey.currentContext!);
            isValid = false;
            return [isValid, error];
            }
        }

        if (editFieldJumlahKg.value[whichItem].getInput().isEmpty) {
            editFieldJumlahKg.value[whichItem].controller.setAlertText("Kolom Ini Harus Di Isi");
            editFieldJumlahKg.value[whichItem].controller.showAlert();
            Scrollable.ensureVisible(editFieldJumlahKg.value[whichItem].controller.formKey.currentContext!);
            isValid = false;
            return [isValid, error];
        }

            if (temp.contains(spinnerCategories.value[whichItem].controller.textSelected.value)) {
            for (int j = 0; j < index.value.length; j++) {
                int whereItem = index.value[j];
                if ((spinnerCategories.value[whereItem].controller.textSelected.value == spinnerCategories.value[whichItem].controller.textSelected.value) && (whereItem != whichItem) ) {
                        if(spinnerSku.value[whereItem].controller.textSelected.value == spinnerSku.value[whichItem].controller.textSelected.value){
                            error = spinnerSku.value[whichItem].controller.textSelected.value;
                                spinnerSku.value[whichItem].controller
                                    ..alertText.value = "Duplikat Jenis Ukuran  $error"
                                    ..showAlert();

                                spinnerSku.value[whereItem].controller
                                    ..alertText.value = "Duplikat Jenis Ukuran $error"
                                    ..showAlert();
                                    Scrollable.ensureVisible(spinnerSku.value[whichItem].controller.formKey.currentContext!);

                                Get.snackbar(
                                    "Alert", "Duplikat Jenis Ukuran  $error",
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 5),
                                    colorText: Colors.white
                                );
                                isValid = false;
                                return [isValid, error];
                        } else {
                            spinnerSku.value[whereItem].controller.hideAlert();
                            spinnerSku.value[whichItem].controller.hideAlert();
                        }
                }
            }
            } else {
                temp.add(spinnerCategories.value[whichItem].controller.textSelected.value);
            }
        }
        return [isValid, error];
    }

    void getSku(CategoryModel categories, int idx) {
        isLoadApi.value = true;
        spinnerSku.value[idx].controller.showLoading();
        Service.push(
            service: ListApi.getProductById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, categories.id],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                    listSku
                        .value
                        .update(idx, (value) => body.data, ifAbsent: () => body.data);

                    Map<String, bool> mapList = {};
                    for (var product in body.data) {
                      mapList[product!.name!] = false;
                    }

                    spinnerSku.value[idx].controller
                    ..textSelected.value = ""
                    ..generateItems(mapList)
                    ..enable();
                } else {
                    listSku
                        .value
                        .update(idx, (value) => body.data, ifAbsent: () => body.data);

                    spinnerSku
                        .value[idx].controller
                    ..textSelected.value = body.data[0]!.name!
                    ..disable();
                }

                    spinnerSku.value[idx].controller.hideLoading();
                isLoadApi.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                isLoadApi.value = false;
                    spinnerSku.value[idx].controller.hideLoading();
                Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white);
                },
                onResponseError: (exception, stacktrace, id, packet) {
                isLoadApi.value = false;
                    spinnerSku.value[idx].controller.hideLoading();
                Get.snackbar("Alert","Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white);
                },
                onTokenInvalid: () {}
            )
        );
    }

        void getLoadSku(String  id, int idx) {
        isLoadApi.value = true;
        spinnerSku.value[idx].controller.showLoading();
        Service.push(
            service: ListApi.getProductById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, id],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                    listSku
                        .value
                        .update(idx, (value) => body.data, ifAbsent: () => body.data);

                    Map<String, bool> mapList = {};
                    for (var product in body.data) {
                      mapList[product!.name!] = false;
                    }

                    spinnerSku.value[idx].controller
                    ..generateItems(mapList)
                    ..enable();
                } else {
                    listSku
                        .value
                        .update(idx, (value) => body.data, ifAbsent: () => body.data);

                    spinnerSku
                        .value[idx].controller
                    ..textSelected.value = body.data[0]!.name!
                    ..disable();
                }

                    spinnerSku.value[idx].controller.hideLoading();
                isLoadApi.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                isLoadApi.value = false;
                    spinnerSku.value[idx].controller.hideLoading();
                Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white);
                },
                onResponseError: (exception, stacktrace, id, packet) {
                isLoadApi.value = false;
                    spinnerSku.value[idx].controller.hideLoading();
                Get.snackbar("Alert","Terjadi kesalahan internal",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                            duration: const Duration(seconds: 5),
                    colorText: Colors.white);
                },
                onTokenInvalid: () {}
            )
        );
    }
}



class SkuCardManufactureBinding extends Bindings {
    String tag;
    BuildContext context;

    SkuCardManufactureBinding({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SkuCardManufactureController>(() =>
            SkuCardManufactureController(tag: tag, context: context));
    }
}