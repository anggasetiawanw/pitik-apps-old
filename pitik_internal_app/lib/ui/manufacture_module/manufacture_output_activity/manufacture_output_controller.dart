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
import 'package:model/internal_app/manufacture_model.dart';
import 'package:model/internal_app/manufacture_output_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/manufacture_output_list_response.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../widget/internal_controller_creator.dart';
import '../../../widget/sku_card_manufacture/sku_card_manufacture.dart';
import '../../../widget/sku_card_manufacture/sku_card_manufacture_controller.dart';

class ManufactureOutputController extends GetxController {
  BuildContext context;
  ManufactureOutputController({required this.context});
  Rx<List<ManufactureOutputModel?>> listManufactureOutput = Rx<List<ManufactureOutputModel?>>([]);
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel?>>([]);
  Rx<List<CategoryModel?>> listCategoriesSelected = Rx<List<CategoryModel?>>([]);
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
  late SkuCardManufacture skuCard;
  var showSKUCard = false.obs;
  var isLoading = false.obs;
  var isLoadData = false.obs;

  late ButtonFill yesButton = ButtonFill(
      controller: GetXCreator.putButtonFillController('yesButton'),
      label: 'Ya',
      onClick: () {
        Constant.track('Click_Konfirmasi_Output_Manufaktur');
        Get.back();
        updateManufacture('OUTPUT_CONFIRMED');
      });
  ButtonOutline noButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('No Button'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      });

  late SpinnerField typeOutput = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController('typeOutput'),
      label: 'Jenis Output*',
      hint: 'Pilih Salah Satu',
      alertText: 'Jenis Output harus dipilih!',
      items: const {},
      onSpinnerSelected: (value) {
        showSKUCard.value = true;
        final List<String> items = value.split(' , ');
        final Map<String, bool> mapList = {};
        for (var item in items) {
          final CategoryModel? selected = listCategories.value.firstWhereOrNull((element) => element!.name! == item);
          listCategoriesSelected.value.add(selected);
          mapList[item] = false;
        }
        Timer(const Duration(milliseconds: 100), () {
          for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
            skuCard.controller.spinnerCategories.value[i].controller.generateItems(mapList);
            skuCard.controller.spinnerCategories.value[i].controller.textSelected.value = '';
            skuCard.controller.spinnerSku.value[i].controller
              ..textSelected.value = ''
              ..disable();
            skuCard.controller.editFieldJumlahAyam.value[i]
              ..setInput('')
              ..controller.disable()
              ..controller.visibleField();
            skuCard.controller.editFieldJumlahKg.value[i]
              ..setInput('')
              ..controller.disable()
              ..controller.invisibleField();
          }
          skuCard.controller.setMaplist(listCategoriesSelected.value);
          this.mapList.value = mapList;
        });
      });

  late ManufactureModel manufactureModel;
  var isEdit = false.obs;
  late DateTime createdDate;
  EditField efTotalKG = EditField(
      controller: GetXCreator.putEditFieldController('efTotalKGPOGR'),
      label: 'Total/Global(Kg)*',
      hint: 'Ketik di sini',
      alertText: 'Total Kg harus diisi',
      textUnit: 'Kg',
      maxInput: 20,
      inputType: TextInputType.number,
      onTyping: (value, editField) {});

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  int countApi = 0;

  @override
  void onInit() {
    super.onInit();
    skuCard = SkuCardManufacture(controller: InternalControllerCreator.putSkuCardManufactureController('SkuCardManufacure', context));
    manufactureModel = Get.arguments[0];
    isEdit.value = Get.arguments[1];
    createdDate = Convert.getDatetime(manufactureModel.createdDate!);
    getProductCategories();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    if (isEdit.isTrue) {
      typeOutput.controller.setTextSelected(manufactureModel.output!.map((e) => e!.name.toString()).reduce((a, b) => '$a , $b'));
      isLoadData.value = true;
      loadSku(manufactureModel.output);
      efTotalKG.setInput(manufactureModel.outputTotalWeight.toString());
      showSKUCard.value = true;
      isLoadData.value = false;
    }

    isLoading.value = true;
    getManufactureOutput();
    Timer(const Duration(milliseconds: 500), () {
      Get.find<SkuCardManufactureController>(tag: 'SkuCardManufacure').idx.listen((p0) {
        generateListProduct(p0);
      });
    });
  }

  void countingApi() {
    countApi++;
    if (countApi == 2) {
      timeEnd = DateTime.now();
      final Duration totalTime = timeEnd.difference(timeStart);
      Constant.trackRenderTime('Form Manufacture_Manufaktur', totalTime);
    }
  }

  void generateListProduct(int idx) {
    Timer(const Duration(milliseconds: 500), () {
      idx -= 1;
      skuCard.controller.spinnerCategories.value[idx].controller.generateItems(mapList.value);
    });
  }

  void loadSku(List<Products?>? product) {
    final Map<String, bool> listKategori = {};
    final List<Products?> listSku = [];
    for (var product in product!) {
      listKategori[product!.name!] = false;
    }
    final int lengthCat = product.length;
    int idx = 0;
    for (int i = 0; i < lengthCat; i++) {
      final int lengthSku = product[i]!.productItems!.length;
      for (int j = 0; j < lengthSku; j++) {
        skuCard.controller.addCard();
        skuCard.controller.spinnerCategories.value[idx].controller.setTextSelected(product[i]!.name!);
        skuCard.controller.spinnerCategories.value[idx].controller.generateItems(listKategori);
        skuCard.controller.spinnerCategories.value[idx].controller.items.refresh();
        skuCard.controller.spinnerSku.value[idx].controller.setTextSelected(product[i]!.productItems![j]!.name!);
        skuCard.controller.editFieldJumlahAyam.value[idx].setInput(product[i]!.productItems![j]!.quantity!.toString());
        skuCard.controller.editFieldJumlahKg.value[idx].setInput(product[i]!.productItems![j]!.weight!.toString());
        if (product[i]!.name! == AppStrings.AYAM_UTUH || product[i]!.name! == AppStrings.BRANGKAS || product[i]!.name! == AppStrings.LIVE_BIRD || product[i]!.name! == AppStrings.KARKAS) {
          skuCard.controller.editFieldJumlahAyam.value[idx].controller.enable();
          skuCard.controller.getLoadSku(product[i]!.id!, idx);
        }
        skuCard.controller.editFieldJumlahKg.value[idx].controller.enable();
        listSku.add(product[i]!.productItems![j]);
        if (skuCard.controller.spinnerCategories.value[idx].controller.textSelected.value == AppStrings.AYAM_UTUH ||
            skuCard.controller.spinnerCategories.value[idx].controller.textSelected.value == AppStrings.BRANGKAS ||
            skuCard.controller.spinnerCategories.value[idx].controller.textSelected.value == AppStrings.LIVE_BIRD ||
            skuCard.controller.spinnerCategories.value[idx].controller.textSelected.value == AppStrings.KARKAS) {
          skuCard.controller.editFieldJumlahAyam.value[idx].controller
            ..visibleField()
            ..enable();
          skuCard.controller.editFieldJumlahKg.value[idx].controller.invisibleField();
        } else {
          skuCard.controller.editFieldJumlahKg.value[idx].controller
            ..visibleField()
            ..enable();
          skuCard.controller.editFieldJumlahAyam.value[idx].controller.invisibleField();
        }
        idx++;
      }
    }

    final List<String> items = typeOutput.controller.textSelected.value.split(' , ');
    for (var item in items) {
      final CategoryModel? selected = listCategories.value.firstWhereOrNull((element) => element!.name! == item);
      listCategoriesSelected.value.add(selected);
    }
    for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
      skuCard.controller.listSku.value[i] = listSku;
      skuCard.controller.spinnerCategories.value[i].controller.generateItems(listKategori);
      skuCard.controller.setMaplist(listCategoriesSelected.value);
      mapList.value = listKategori;
    }
    mapList.value = listKategori;
    skuCard.controller.removeCard(skuCard.controller.itemCount.value - 1);
  }

  void getProductCategories() {
    Service.push(
        service: ListApi.getCategories,
        context: context,
        body: [
          Constant.auth!.token!,
          Constant.auth!.id,
          Constant.xAppId!,
        ],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              for (var result in (body as CategoryListResponse).data) {
                listCategories.value.add(result);
              }
              countingApi();
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getManufactureOutput() {
    Service.push(
        service: ListApi.getListManufactureOutput,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetListManufactureOutput(manufactureModel.input!.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              final Map<String, bool> mapList = {};
              for (var data in (body as ListManufactureOutputResponse).data) {
                mapList[data!.output!.map((e) => e!.name.toString()).reduce((a, b) => '$a , $b')] = false;
              }
              typeOutput.controller.generateItems(mapList);

              for (var result in body.data) {
                listManufactureOutput.value.add(result);
              }
              isLoading.value = false;
              countingApi();
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void updateManufacture(String status) {
    final List<dynamic> ret = validation();
    if (ret[0]) {
      isLoading.value = true;
      Service.push(
          service: ListApi.updateManufactureById,
          context: context,
          body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateManufactureById(manufactureModel.id!), Mapper.asJsonString(generatePayload(status))],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.back();
              },
              onResponseFail: (code, message, body, id, packet) {
                const stock = "Manufacture output's weight is greater than the input!";
                if ((body as ErrorResponse).error!.message!.contains(stock)) {
                  Get.snackbar(
                    'Pesan',
                    'Gagal membuat output, total output lebih besar dari total input',
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                  );
                } else {
                  Get.snackbar(
                    'Pesan',
                    'Terjadi Kesalahan, ${body.error!.message}',
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                  );
                }

                isLoading.value = false;
              },
              onResponseError: (exception, stacktrace, id, packet) {
                Get.snackbar(
                  'Pesan',
                  'Terjadi kesalahan internal',
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                isLoading.value = false;
              },
              onTokenInvalid: Constant.invalidResponse()));
    }
  }

  List<dynamic> validation() {
    List<dynamic> ret = [true, ''];

    if (typeOutput.controller.textSelected.value.isEmpty) {
      typeOutput.controller.showAlert();
      Scrollable.ensureVisible(typeOutput.controller.formKey.currentContext!);
      return ret = [false, ''];
    }

    if (efTotalKG.getInput().isEmpty) {
      efTotalKG.controller.showAlert();
      Scrollable.ensureVisible(efTotalKG.controller.formKey.currentContext!);
      return ret = [false, ''];
    }

    ret = skuCard.controller.validation();
    return ret;
  }

  ManufactureModel generatePayload(String status) {
    final List<Products?> output = [];
    for (int i = 0; i < skuCard.controller.itemCount.value; i++) {
      final int whichItem = skuCard.controller.index.value[i];
      final listProductTemp = skuCard.controller.listSku.value.values.toList();
      final Products? productSelected = listProductTemp[whichItem].firstWhereOrNull((element) => element!.name! == skuCard.controller.spinnerSku.value[whichItem].controller.textSelected.value);
      output.add(Products(
        productItemId: productSelected?.id,
        quantity: skuCard.controller.editFieldJumlahAyam.value[whichItem].getInput().isEmpty ? null : skuCard.controller.editFieldJumlahAyam.value[whichItem].getInputNumber()!.toInt(),
        weight: skuCard.controller.editFieldJumlahKg.value[whichItem].getInputNumber() ?? 0,
      ));
    }
    return ManufactureModel(
      operationUnitId: manufactureModel.operationUnit!.id,
      status: status,
      input: Products(
        productItemId: manufactureModel.input!.productItems![0]!.id,
        quantity: manufactureModel.input!.productItems![0]!.quantity,
        weight: manufactureModel.input!.productItems![0]!.weight ?? 0,
      ),
      output: output,
      outputTotalWeight: efTotalKG.getInputNumber() ?? 0,
    );
  }
}

class ManufactureOutputBindings extends Bindings {
  BuildContext context;
  ManufactureOutputBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => ManufactureOutputController(context: context));
  }
}
