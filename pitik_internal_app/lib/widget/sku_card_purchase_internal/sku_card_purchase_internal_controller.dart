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
import '../../api_mapping/list_api.dart';
import '../../utils/constant.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 11/04/23

class SkuCardPurchaseInternalController extends GetxController {
  String tag;
  BuildContext context;
  SkuCardPurchaseInternalController({required this.tag, required this.context});

  Rx<List<int>> index = Rx<List<int>>([]);
  Rx<List<SpinnerField>> spinnerCategories = Rx<List<SpinnerField>>([]);
  Rx<List<SpinnerField>> spinnerSku = Rx<List<SpinnerField>>([]);
  Rx<List<EditField>> editFieldJumlahAyam = Rx<List<EditField>>([]);
  Rx<List<EditField>> editFieldKebutuhan = Rx<List<EditField>>([]);
  Rx<List<EditField>> editFieldHarga = Rx<List<EditField>>([]);
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel>>([]);
  Rx<Map<int, List<Products?>>> listSku = Rx<Map<int, List<Products?>>>({});

  var itemCount = 0.obs;
  var expanded = false.obs;
  var isShow = true.obs;
  var isLoadApi = false.obs;
  var sumChick = 0.obs;
  var sumNeededMin = 0.0.obs;
  var sumNeededMax = 0.0.obs;
  var sumPriceMin = 0.0.obs;
  var sumPriceMax = 0.0.obs;
  RxMap<int, double?> mapSumChick = <int, double?>{}.obs;
  RxMap<int, double?> mapSumNeeded = <int, double?>{}.obs;
  RxMap<int, double?> mapSumPrice = <int, double?>{}.obs;

  void expand() => expanded.value = true;
  void collapse() => expanded.value = false;
  void visibleCard() => isShow.value = true;
  void invisibleCard() => isShow.value = false;

  var idx = 0.obs;
  @override
  void onInit() {
    super.onInit();
    addCard();
  }

  void addCard() {
    index.value.add(idx.value);
    final int numberList = idx.value;
    spinnerCategories.value.add(
      SpinnerField(
          controller: GetXCreator.putSpinnerFieldController('spin${numberList}SKUInternal'),
          label: 'Kategori SKU*',
          hint: 'Pilih Salah Satu',
          alertText: 'Kategori SKU harus dipilih!',
          items: const {},
          onSpinnerSelected: (value) {
            if (listCategories.value.isNotEmpty) {
              final CategoryModel? selectCategory = listCategories.value.firstWhereOrNull((element) => element!.name! == value);
              if (value == AppStrings.AYAM_UTUH || value == AppStrings.BRANGKAS || value == AppStrings.KARKAS || value == AppStrings.LIVE_BIRD) {
                // editFieldJumlahAyam.value[numberList].controller.enable();
                spinnerSku.value[numberList].controller.visibleSpinner();
                editFieldJumlahAyam.value[numberList].controller.visibleField();
                editFieldHarga.value[numberList].controller.visibleField();
                editFieldKebutuhan.value[numberList].controller.invisibleField();
              } else {
                spinnerSku.value[numberList].controller.invisibleSpinner();
                editFieldJumlahAyam.value[numberList].controller.invisibleField();
                editFieldKebutuhan.value[numberList].controller.visibleField();
                editFieldHarga.value[numberList].controller.visibleField();
              }

              spinnerSku.value[numberList].controller.textSelected.value = '';
              editFieldJumlahAyam.value[numberList].setInput('');
              editFieldKebutuhan.value[numberList].setInput('');
              editFieldHarga.value[numberList].setInput('');
              getSku(selectCategory!, numberList);
            }
          }),
    );

    spinnerSku.value.add(
      SpinnerField(
          controller: GetXCreator.putSpinnerFieldController('size${numberList}SKUInternal'),
          label: 'SKU*',
          hint: 'Pilih Salah Satu',
          alertText: 'Ukuran harus dipilih!',
          items: const {},
          onSpinnerSelected: (value) {
            if (listCategories.value.isNotEmpty) {
              if (spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.AYAM_UTUH ||
                  spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.BRANGKAS ||
                  spinnerCategories.value[numberList].controller.textSelected.value == AppStrings.KARKAS) {
                editFieldJumlahAyam.value[numberList].setInput('');
                editFieldHarga.value[numberList].setInput('');
              }
            }
          }),
    );

    editFieldJumlahAyam.value.add(EditField(
        controller: GetXCreator.putEditFieldController('editJumlah${numberList}SKUInternal'),
        label: 'Jumlah Ekor*',
        hint: 'Ketik di sini',
        alertText: 'Kolom Ini Harus Di Isi',
        textUnit: 'Ekor',
        inputType: TextInputType.number,
        maxInput: 20,
        onTyping: (value, control) {
          mapSumChick[numberList] = control.getInputNumber();
          refreshtotalPurchase();
        }));

    editFieldKebutuhan.value.add(EditField(
        controller: GetXCreator.putEditFieldController('editJenis${numberList}SKUInternal'),
        label: 'Jumlah Kebutuhan*',
        hint: 'Ketik di sini',
        alertText: 'Kolom Ini Harus Di Isi',
        textUnit: 'Kg',
        inputType: TextInputType.number,
        maxInput: 20,
        onTyping: (value, control) {
          mapSumChick[numberList] = control.getInputNumber();
          refreshtotalPurchase();
        }));

    editFieldHarga.value.add(EditField(
        controller: GetXCreator.putEditFieldController('editharga${numberList}SKUInternal'),
        label: 'Harga',
        hint: 'Ketik di sini',
        alertText: 'Kolom Ini Harus Di Isi',
        textUnit: '/Kg',
        textPrefix: AppStrings.PREFIX_CURRENCY_IDR,
        inputType: TextInputType.number,
        maxInput: 20,
        onTyping: (value, control) {
          mapSumPrice[numberList] = control.getInputNumber();
          refreshtotalPurchase();
        }));
    spinnerSku.value[numberList].controller.invisibleSpinner();
    editFieldJumlahAyam.value[numberList].controller.invisibleField();
    editFieldKebutuhan.value[numberList].controller.invisibleField();
    editFieldHarga.value[numberList].controller.invisibleField();
    itemCount.value = index.value.length;
    idx.value++;
  }

  void refreshtotalPurchase() {
    sumNeededMin.value = 0;
    sumNeededMax.value = 0;
    sumChick.value = 0;
    sumPriceMax.value = 0;
    sumPriceMin.value = 0;
    for (var idx in index.value) {
      if (spinnerCategories.value[idx].controller.textSelected.value == AppStrings.LIVE_BIRD ||
          spinnerCategories.value[idx].controller.textSelected.value == AppStrings.AYAM_UTUH ||
          spinnerCategories.value[idx].controller.textSelected.value == AppStrings.BRANGKAS ||
          spinnerCategories.value[idx].controller.textSelected.value == AppStrings.KARKAS) {
        final List<Products?> listSkuSelect = listSku.value[idx]!;
        if (listSkuSelect.isNotEmpty) {
          final Products? selectProduct = listSkuSelect.firstWhereOrNull(
            (element) => element?.name == spinnerSku.value[idx].controller.textSelected.value,
          );
          final double minValue = (selectProduct?.minValue ?? 0) * (mapSumChick[idx] ?? 0);
          final double maxValue = (selectProduct?.maxValue ?? 0) * (mapSumChick[idx] ?? 0);
          sumNeededMin.value += minValue;
          sumNeededMax.value += maxValue;
          sumChick.value += (mapSumChick[idx] ?? 0).toInt();
          sumPriceMin.value += (mapSumPrice[idx] ?? 0) * minValue;
          sumPriceMax.value += (mapSumPrice[idx] ?? 0) * maxValue;
        }
      } else {
        sumNeededMin.value += mapSumNeeded[idx] ?? 0;
        sumNeededMax.value += mapSumNeeded[idx] ?? 0;
        sumPriceMin.value += (mapSumNeeded[idx] ?? 0) * (mapSumPrice[idx] ?? 0);
        sumPriceMax.value += (mapSumNeeded[idx] ?? 0) * (mapSumPrice[idx] ?? 0);
      }
    }
  }

  void removeCard(int idx) {
    index.value.removeWhere((item) => item == idx);
    itemCount.value = index.value.length;

    mapSumChick.removeWhere((key, value) => key == idx);
    mapSumNeeded.removeWhere((key, value) => key == idx);
    mapSumPrice.removeWhere((key, value) => key == idx);

    refreshtotalPurchase();
  }

  void setMaplist(List<CategoryModel?> map) {
    listCategories.value = map;
  }

  List<dynamic> validation() {
    bool isValid = true;
    String error = '';
    final temp = <String>[];
    for (int i = 0; i < index.value.length; i++) {
      final int whichItem = index.value[i];
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
          spinnerSku.value[whichItem].controller.textSelected.value == AppStrings.BRANGKAS ||
          spinnerSku.value[whichItem].controller.textSelected.value == AppStrings.KARKAS) {
        if (editFieldJumlahAyam.value[whichItem].getInput().isEmpty) {
          editFieldJumlahAyam.value[whichItem].controller.showAlert();
          Scrollable.ensureVisible(editFieldJumlahAyam.value[whichItem].controller.formKey.currentContext!);
          isValid = false;
          return [isValid, error];
        }
        if (editFieldKebutuhan.value[whichItem].getInput().isEmpty) {
          editFieldKebutuhan.value[whichItem].controller.setAlertText('Kolom Ini Harus Di Isi');
          editFieldKebutuhan.value[whichItem].controller.showAlert();
          Scrollable.ensureVisible(editFieldKebutuhan.value[whichItem].controller.formKey.currentContext!);
          isValid = false;
          return [isValid, error];
        }
      }

      if (temp.contains(spinnerCategories.value[whichItem].controller.textSelected.value)) {
        for (int j = 0; j < index.value.length; j++) {
          final int whereItem = index.value[j];
          if ((spinnerCategories.value[whereItem].controller.textSelected.value == spinnerCategories.value[whichItem].controller.textSelected.value) && (whereItem != whichItem)) {
            if (spinnerSku.value[whereItem].controller.textSelected.value == spinnerSku.value[whichItem].controller.textSelected.value) {
              error = spinnerSku.value[whichItem].controller.textSelected.value;
              spinnerSku.value[whichItem].controller
                ..alertText.value = 'Duplikat Jenis Ukuran  $error'
                ..showAlert();

              spinnerSku.value[whereItem].controller
                ..alertText.value = 'Duplikat Jenis Ukuran $error'
                ..showAlert();
              Scrollable.ensureVisible(spinnerSku.value[whichItem].controller.formKey.currentContext!);

              Get.snackbar('Alert', 'Duplikat Jenis Ukuran  $error', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, duration: const Duration(seconds: 5), colorText: Colors.white);
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
                listSku.value.update(idx, (value) => body.data, ifAbsent: () => body.data);

                final Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }

                spinnerSku.value[idx].controller
                  ..textSelected.value = ''
                  ..generateItems(mapList)
                  ..enable();
              } else {
                listSku.value.update(idx, (value) => body.data, ifAbsent: () => body.data);

                spinnerSku.value[idx].controller
                  ..textSelected.value = body.data[0]!.name!
                  ..disable();
              }

              spinnerSku.value[idx].controller.hideLoading();
              isLoadApi.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoadApi.value = false;
              spinnerSku.value[idx].controller.hideLoading();
              Get.snackbar('Alert', (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, duration: const Duration(seconds: 5), colorText: Colors.white);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoadApi.value = false;
              spinnerSku.value[idx].controller.hideLoading();
              Get.snackbar('Alert', 'Terjadi kesalahan internal', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, duration: const Duration(seconds: 5), colorText: Colors.white);
            },
            onTokenInvalid: () {}));
  }

  void getLoadSku(CategoryModel categories, int idx) {
    isLoadApi.value = true;
    spinnerSku.value[idx].controller.showLoading();
    Service.push(
        service: ListApi.getProductById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, categories.id],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                listSku.value.update(idx, (value) => body.data, ifAbsent: () => body.data);

                final Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }

                spinnerSku.value[idx].controller
                  ..generateItems(mapList)
                  ..enable();
              } else {
                listSku.value.update(idx, (value) => body.data, ifAbsent: () => body.data);

                spinnerSku.value[idx].controller
                  ..textSelected.value = body.data[0]!.name!
                  ..disable();
              }

              spinnerSku.value[idx].controller.hideLoading();
              isLoadApi.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoadApi.value = false;
              spinnerSku.value[idx].controller.hideLoading();
              Get.snackbar('Alert', (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, duration: const Duration(seconds: 5), colorText: Colors.white);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoadApi.value = false;
              spinnerSku.value[idx].controller.hideLoading();
              Get.snackbar('Alert', 'Terjadi kesalahan internal', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, duration: const Duration(seconds: 5), colorText: Colors.white);
            },
            onTokenInvalid: () {}));
  }
}

class SkuCardPurchaseInternalBinding extends Bindings {
  String tag;
  BuildContext context;

  SkuCardPurchaseInternalBinding({required this.tag, required this.context});

  @override
  void dependencies() {
    Get.lazyPut<SkuCardPurchaseInternalController>(() => SkuCardPurchaseInternalController(tag: tag, context: context));
  }
}
