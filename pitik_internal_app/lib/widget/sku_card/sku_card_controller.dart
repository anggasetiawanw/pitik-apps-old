
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/strings.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/product_list_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-13 13:59:44
/// @modify date 2023-02-13 13:59:44
/// @desc [description]

class SkuCardController extends GetxController {
    String tag;
    BuildContext context;
    SkuCardController({required this.tag, required this.context});

    Rx<List<int>> index = Rx<List<int>>([]);
    Rx<List<SpinnerField>> spinnerProduct = Rx<List<SpinnerField>>([]);
    Rx<List<SpinnerField>> spinnerSize = Rx<List<SpinnerField>>([]);
    Rx<List<EditField>> editFieldJenis = Rx<List<EditField>>([]);
    Rx<List<EditField>> editFieldHarga = Rx<List<EditField>>([]);
    Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
    Rx<Map<int, List<Products?>>> listProduct = Rx<Map<int, List<Products?>>>({});

    var itemCount = 0.obs;
    var expanded = false.obs;
    var isShow = true.obs;
    var isLoadApi = false.obs;
    var numberList = 0.obs;

    void expand() => expanded.value = true;
    void collapse() => expanded.value = false;
    void visibleCard() => isShow.value = true;
    void invisibleCard() => isShow.value = false;


    @override
    void onInit() {
        super.onInit();
        addCard();
    }

  
    addCard() {
        index.value.add(numberList.value);
        int idx = numberList.value;
        spinnerSize.value.add(
            SpinnerField(
                controller: GetXCreator.putSpinnerFieldController("size${idx}SKU"),
                label: "SKU*",
                hint: "Pilih Salah Satu",
                alertText: "Ukuran harus dipilih!",
                items: const {},
                onSpinnerSelected: (value) {}
            ),
        );

        spinnerProduct.value.add(
            SpinnerField(
                controller: GetXCreator.putSpinnerFieldController("spin${idx}SKU"),
                label: "Kategori SKU*",
                hint: "Pilih Salah Satu",
                alertText: "Kategori SKU harus dipilih!",
                items: const {},
                onSpinnerSelected: (value) {
                    try {
                        if (listCategories.value.isNotEmpty) {
                            CategoryModel? selectCategory = listCategories.value.firstWhereOrNull((element) => element!.name! == value);
                            if (selectCategory != null) {
                                getUOM(selectCategory, idx);
                            }
                        }
                    } catch (e, st) {
                        Get.snackbar("Error", "$e $st");
                    }
                }
            ),
        );

        editFieldJenis.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editJenis${idx}Sku"),
            label: "Jumlah Kebutuhan",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "Kg/Hari",
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {}));

        editFieldHarga.value.add(EditField(
            controller: GetXCreator.putEditFieldController(
                "editharga${idx}Sku"),
            label: "Harga beli saat ini?*",
            hint: "Ketik di sini",
            alertText: "Kolom Ini Harus Di Isi",
            textUnit: "/Kg",
            textPrefix: AppStrings.PREFIX_CURRENCY_IDR,
            inputType: TextInputType.number,
            maxInput: 20,
            onTyping: (value, control) {
                if(control.getInput().length < 4){
                    control.controller.setAlertText("Harga Tidak Valid!");
                    control.controller.showAlert();
                }
            }
        ));
        spinnerSize.value[idx].controller.disable();
        itemCount.value = index.value.length;
        numberList.value++;
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
        final temp2 = <String>[];
        for (int i = 0; i < index.value.length; i++) {
            int whichItem = index.value[i];
            if (spinnerProduct.value[whichItem].controller.textSelected.value.isEmpty) {
                spinnerProduct.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(spinnerProduct.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }

            if (spinnerSize.value[whichItem].controller.textSelected.value.isEmpty) {
                spinnerSize.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(spinnerSize.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
        
            if (editFieldJenis.value[whichItem].getInput().isEmpty) {
                editFieldJenis.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(editFieldJenis.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }
          
            if (editFieldHarga.value[whichItem].getInput().isEmpty) {
                editFieldHarga.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(editFieldJenis.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }

            if (editFieldHarga.value[whichItem].getInput().length < 4) {
                editFieldHarga.value[whichItem].controller.setAlertText("Harga Tidak Valid!");
                editFieldHarga.value[whichItem].controller.showAlert();
                Scrollable.ensureVisible(editFieldHarga.value[whichItem].controller.formKey.currentContext!);
                isValid = false;
                return [isValid, error];
            }

            if (temp.contains(spinnerProduct.value[whichItem].controller.textSelected.value)) {
                for (int j = 0; j < index.value.length - i; j++) {
                    if (spinnerProduct.value[j].controller.textSelected.value == spinnerProduct.value[i].controller.textSelected.value) {
                        for (int k = 0; k < index.value.length - i; k++) {
                            if(temp2.contains(spinnerSize.value[k].controller.textSelected.value)  && spinnerSize.value[k].controller.activeField.isTrue){
                                error = spinnerSize.value[k].controller.textSelected.value;
                                for (int l = 0; l < index.value.length - i; l++) {
                                    if(spinnerSize.value[l].controller.textSelected.value == spinnerSize.value[k].controller.textSelected.value){

                                        spinnerSize.value[l].controller
                                            ..alertText.value = "Duplikat Jenis Ukuran $error"
                                            ..showAlert();

                                        spinnerSize.value[k].controller
                                            ..alertText.value = "Duplikat Jenis Ukuran  $error"
                                            ..showAlert();
                                            
                                        Scrollable.ensureVisible(spinnerSize.value[k].controller.formKey.currentContext!);

                                        isValid = false;
                                        isValid = false;
                                        return [isValid, error];
                                    }
                                }
                            } else {
                                temp2.add(spinnerSize.value[k].controller.textSelected.value);
                            }
                        }
                    }
                }
            } else {
                temp.add(spinnerProduct.value[whichItem].controller.textSelected.value);
            }
        }

        return [isValid, error];
    }

    void getUOM(CategoryModel categories, int idx) {
        isLoadApi.value = true;
        Service.push(
            service: ListApi.getProductById,
            context: context,
            body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, categories.id],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                        listProduct
                            .value
                            .update(idx, (value) => body.data, ifAbsent: () => body.data);

                        Map<String, bool> mapList = {};
                        for (var product in body.data) {
                          mapList[product!.name!] = false;
                        }

                        spinnerSize.value[idx].controller
                            ..textSelected.value = ""
                            ..generateItems(mapList)
                            ..enable();
                    } else {
                        listProduct
                            .value
                            .update(idx, (value) => body.data, ifAbsent: () => body.data);

                        spinnerSize
                            .value[idx].controller
                            ..textSelected.value = body.data[0]!.name!
                            ..disable();
                    }

                    isLoadApi.value = false;
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoadApi.value = false;
                    Get.snackbar("Alert", (body as ErrorResponse).error!.message!,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoadApi.value = false;
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


class SkuCardBinding extends Bindings {
    String tag;
    BuildContext context;
    SkuCardBinding({required this.tag, required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SkuCardController>(() => SkuCardController(tag: tag, context: context));
    }
}
