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
///@create date 27/05/23

class SkuCardRemarkController extends GetxController{

    String tag;
    BuildContext context;
    SkuCardRemarkController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<SpinnerField>> spinnerCategories = Rx<List<SpinnerField>>([]);
    Rx<List<SpinnerField>> spinnerSku = Rx<List<SpinnerField>>([]);
    Rx<List<EditField>> editFieldJumlahAyam = Rx<List<EditField>>([]);
    Rx<List<EditField>> editFieldPotongan = Rx<List<EditField>>([]);
    Rx<List<EditField>> editFieldKebutuhan = Rx<List<EditField>>([]);
    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<Map<int, List<Products?>>> listSku = Rx<Map<int, List<Products?>>>({});

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = true.obs;
    var isLoadApi = false.obs;
    Rx<List<int>> listChick = Rx<List<int>>([]);
    Rx<List<int>> listNeeded = Rx<List<int>>([]);
    Rx<List<int>> listPrice = Rx<List<int>>([]);
    var sumChick = 0.obs;
    var sumNeeded = 0.obs;
    var sumPrice = 0.obs;
    RxMap<int,double?> mapSumChick = <int, double?>{}.obs;
    RxMap<int,double?> mapSumNeeded = <int, double?>{}.obs;
    RxMap<int,double?> mapSumPrice = <int, double?>{}.obs;

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
        spinnerSku.value.add(
        SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("size${numberList}Remark"),
            label: "SKU*",
            hint: "Pilih Salah Satu",
            alertText: "Ukuran harus dipilih!",
            items: const {},
            onSpinnerSelected: (value) {
                if (listCategories.value.isNotEmpty) {
                            if (spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.LIVE_BIRD || spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.AYAM_UTUH ||
                                spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.BRANGKAS) {
                                editFieldJumlahAyam.value[numberList].controller.enable();
                                editFieldPotongan.value[numberList].controller.enable();
                            } else {
                                editFieldJumlahAyam.value[numberList].controller.disable();
                                editFieldPotongan.value[numberList].controller.disable();
                            }
                            editFieldJumlahAyam.value[numberList].setInput("");
                            editFieldKebutuhan.value[numberList].setInput("");
                            editFieldPotongan.value[numberList].setInput("");
                        }
                }
        ),
        );

        spinnerCategories.value.add(
        SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("spin${numberList}Remark"),
            label: "Kategori SKU*",
            hint: "Pilih Salah Satu",
            alertText: "Kategori SKU harus dipilih!",
            items: const {},
            onSpinnerSelected: (value) {
                try {
                if (listCategories.value.isNotEmpty) {
                    CategoryModel? selectCategory = listCategories.value.firstWhere((element) => element!.name! == value);
                    if (selectCategory != null) {
                        if (spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.LIVE_BIRD || spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.AYAM_UTUH ||
                                spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.BRANGKAS) {
                                editFieldJumlahAyam.value[numberList].controller.enable();
                                editFieldPotongan.value[numberList].controller.enable();
                            } else {
                                editFieldJumlahAyam.value[numberList].controller.disable();
                                editFieldPotongan.value[numberList].controller.disable();
                            }
                            editFieldJumlahAyam.value[numberList].setInput("");
                            editFieldKebutuhan.value[numberList].setInput("");
                            editFieldPotongan.value[numberList].setInput("");
                    getSku(selectCategory, numberList);
                    }
                }
                } catch (e, st) {
                Get.snackbar("Error", "$e $st");
                }
            }
        ),
        );

        editFieldJumlahAyam.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editJumlah${numberList}Remark"),
            label: "Jumlah Ekor",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "Ekor",
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {
                mapSumChick[numberList] = control.getInputNumber();
                refreshSumWeight();
            }));

        editFieldPotongan.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editPotongan${numberList}Remark"),
            label: "Potongan",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "Potongan",
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {
            }));

        editFieldKebutuhan.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editJenis${numberList}Remark"),
            label: "Kebutuhan",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "Kg",
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {
            mapSumNeeded[numberList] = control.getInputNumber();
            refreshSumNeeded();
            }));


        spinnerSku.value[itemCount.value].controller.disable();
        // editFieldJumlahAyam.value[itemCount.value].controller.disable();
        // editFieldPotongan.value[itemCount.value].controller.disable();
        itemCount.value = index.value.length;
        idx.value++;
    }

    refreshSumWeight(){
        sumChick.value = 0;
        mapSumChick.forEach((key, value) {
        if(value!= null) {
            sumChick.value += value.toInt();
        }
        });
    }

    refreshSumNeeded(){
        sumNeeded.value = 0;
        mapSumNeeded.forEach((key, value) {
        if(value!= null) {
            sumNeeded.value += value.toInt();
        }
        });
    }
    refreshSumPrice(){
        sumPrice.value = 0;
        mapSumPrice.forEach((key, value) {
        if(value!= null) {
            sumPrice.value += value.toInt();
        }
        });
    }

    removeCard(int idx) {
        index.value.removeWhere((item) => item == idx);
        itemCount.value = index.value.length;

        mapSumChick.removeWhere((key, value) => key == idx);
        mapSumNeeded.removeWhere((key, value) => key == idx);
        mapSumPrice.removeWhere((key, value) => key == idx);

        refreshSumWeight();
        refreshSumPrice();
        refreshSumNeeded();
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

        if(spinnerCategories.value[whichItem].controller.textSelected.value == AppStrings.AYAM_UTUH || spinnerCategories.value[whichItem].controller.textSelected.value == AppStrings.BRANGKAS){
            if (editFieldJumlahAyam.value[whichItem].getInput().isEmpty) {
                editFieldJumlahAyam.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(editFieldJumlahAyam.value[whichItem].controller.formKey.currentContext!);

                isValid = false;
                return [isValid, error];
            }

            if (editFieldPotongan.value[whichItem].getInput().isEmpty) {
                editFieldPotongan.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(editFieldPotongan.value[whichItem].controller.formKey.currentContext!);

                isValid = false;
                return [isValid, error];
            }
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
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, categories.id],
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
                            duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                },
                onTokenInvalid: () {}
            )
        );
    }

    void getLoadSku(CategoryModel categories, int idx) {
        isLoadApi.value = true;
        spinnerSku.value[idx].controller.showLoading();
        Service.push(
            service: ListApi.getProductById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, categories.id],
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
                            duration: const Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                },
                onTokenInvalid: () {}
            )
        );
    }

}

class SkuCardRemarkBinding extends Bindings {
    String tag;
    BuildContext context;

    SkuCardRemarkBinding({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SkuCardRemarkController>(() =>
            SkuCardRemarkController(tag: tag, context: context));
    }
}