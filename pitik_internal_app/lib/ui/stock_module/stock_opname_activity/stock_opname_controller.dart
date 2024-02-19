import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/stock_opname_field/stock_opname_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/category_model.dart';
import 'package:model/internal_app/operation_unit_model.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/response/internal_app/category_list_response.dart';
import 'package:model/response/internal_app/operation_units_response.dart';
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';

class StockOpnameController extends GetxController {
  BuildContext context;
  StockOpnameController({required this.context});
  var isLoading = false.obs;
  var isEdit = false.obs;

  OpnameModel? opnameModel;
  OperationUnitModel? operationUnitModel;
  Rx<List<OperationUnitModel?>> listOperationUnits = Rx<List<OperationUnitModel?>>([]);
  Rx<List<CategoryModel?>> listCategories = Rx<List<CategoryModel?>>([]);
  Rx<List<StockOpnameField>> listStockField = Rx<List<StockOpnameField>>([]);

  late SpinnerField sourceStock = SpinnerField(
      controller: GetXCreator.putSpinnerFieldController("stockSourceOpname"),
      label: "Sumber*",
      hint: "Pilih salah satu",
      alertText: "Sumber harus dipilih!",
      items: const {},
      onSpinnerSelected: (value) {
        if (listOperationUnits.value.isNotEmpty) {
          OperationUnitModel? selectSource = listOperationUnits.value.firstWhereOrNull((element) => element!.operationUnitName == value);
          if (selectSource != null) {
            efTotal.controller.visibleField();
            showWidget(selectSource.purchasableProducts!, false);
          }
        }
      });

  EditField efTotal = EditField(controller: GetXCreator.putEditFieldController("efTOtal"), label: "Total/Global(kg)*", hint: "ketik disini", alertText: "Total harus diisi", textUnit: "kg", maxInput: 20, inputType: TextInputType.number, onTyping: (value, editField) {});
  late ButtonFill yesButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesButton"),
      label: "Ya",
      onClick: () {
        Constant.track("Click_Konfirmasi_Stock_Opname");
        if (isEdit.isTrue) {
          Get.back();
          updateStock("CONFIRMED");
        } else {
          Get.back();
          createStockOpname("CONFIRMED");
        }
      });

  ButtonOutline noButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("No Button"),
      label: "Tidak",
      onClick: () {
        Get.back();
      });

  DateTime timeStart = DateTime.now();
    DateTime timeEnd = DateTime.now();
    int countApi = 0;

  @override
  void onInit() {
    super.onInit();
    efTotal.controller.invisibleField();
    opnameModel = Get.arguments[0];
    isEdit.value = Get.arguments[1];
    operationUnitModel = Get.arguments[2];
    getListSourceUnit();
    getProductCategories();
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    if (isEdit.isTrue) {
      isLoading.value = true;
      sourceStock.controller.setTextSelected(opnameModel!.operationUnit!.operationUnitName!);
      showWidget(opnameModel!.products!, true);
      efTotal.setInput((opnameModel?.totalWeight ?? 0).toString());
      efTotal.controller.visibleField();
      countingApi();
    } else {
      if (operationUnitModel != null) {
        sourceStock.controller.setTextSelected(operationUnitModel!.operationUnitName!);
        showWidget(operationUnitModel!.purchasableProducts!, false);
        efTotal.controller.visibleField();
      }
      countingApi();
    }
  }

  void countingApi(){
    countApi++;
    if(countApi == 3){
      isLoading.value = false;
      timeEnd = DateTime.now();
        Duration totalTime = timeEnd.difference(timeStart);
        Constant.trackRenderTime("Form_Stock_Opname", totalTime);
    }
  }

  void getListSourceUnit() {
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE, 0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              sourceStock.controller.generateItems(mapList);
              for (var result in body.data) {
                listOperationUnits.value.add(result);
              }
              countingApi();
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
              Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
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
              Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void createStockOpname(String status) {
    if (validation(status)) {
      isLoading.value = true;
      Service.push(
          service: ListApi.createStockOpname,
          context: context,
          body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, Mapper.asJsonString(generatePayload(status))],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.back();
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
                Get.snackbar(
                  "Pesan",
                  "Terjadi kesalahan internal",
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

  void updateStock(String status) {
    if (validation(status)) {
      isLoading.value = true;
      Service.push(
          service: ListApi.updateOpnameById,
          context: context,
          body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateOpnameById(opnameModel!.id!), Mapper.asJsonString(generatePayload(status))],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                isLoading.value = false;
                Get.back();
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
                Get.snackbar(
                  "Pesan",
                  "Terjadi kesalahan internal",
                  duration: const Duration(seconds: 5),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                isLoading.value = false;
              },
              onTokenInvalid: Constant.invalidResponse()));
    }
  }

  showWidget(List<Products?> items, bool isEdit) {
    listStockField.value.clear();
    int idx = 0;
    if (isEdit) {
      for (var element in items) {
        listStockField.value.add(StockOpnameField(title: element!.name!, controller: GetXCreator.putStockOpnameField(element.name!)));
        listStockField.value[idx].controller.generateEf(element);
        listStockField.refresh();
        listStockField.value[idx].controller.setDefault(element);
        listStockField.refresh();
        idx++;
      }
    } else {
      for (var element in items) {
        listStockField.value.add(StockOpnameField(title: element!.name!, controller: GetXCreator.putStockOpnameField(element.name!)));
        listStockField.value[idx].controller.generateEf(element);
        idx++;
        listStockField.refresh();
      }
    }
  }

  bool validation(String status) {
    bool ret = true;
    if (sourceStock.controller.textSelected.value.isEmpty) {
      sourceStock.controller.showAlert();
      Scrollable.ensureVisible(sourceStock.controller.formKey.currentContext!);
      return false;
    }

    if (efTotal.getInput().isEmpty) {
      efTotal.controller.showAlert();
      Scrollable.ensureVisible(efTotal.controller.formKey.currentContext!);
      return false;
    }
    return ret;
  }

  OpnameModel generatePayload(String status) {
    List<Products?> products = [];
    OperationUnitModel? selectSource = listOperationUnits.value.firstWhereOrNull(
      (element) => element!.operationUnitName == sourceStock.controller.textSelected.value,
    );
    for (var stock in listStockField.value) {
      Products? purchaseProduct = selectSource!.purchasableProducts!.firstWhereOrNull((element) => element!.name == stock.title);
      for (var item in stock.controller.efSku.value) {
        Products? productItem = purchaseProduct!.productItems!.firstWhereOrNull((element) => element!.name == item.controller.tag);
        products.add(
          Products(
            productItemId: productItem!.id,
            quantity: purchaseProduct.name == AppStrings.LIVE_BIRD || purchaseProduct.name == AppStrings.AYAM_UTUH || purchaseProduct.name == AppStrings.BRANGKAS || purchaseProduct.name == AppStrings.KARKAS ? (item.getInputNumber() ?? 0).toInt() : 0,
            weight: purchaseProduct.name == AppStrings.LIVE_BIRD || purchaseProduct.name == AppStrings.AYAM_UTUH || purchaseProduct.name == AppStrings.BRANGKAS || purchaseProduct.name == AppStrings.KARKAS ? 0 : item.getInputNumber() ?? 0,
          ),
        );
      }
    }

    return OpnameModel(
      operationUnitId: selectSource!.id,
      products: products,
      status: status,
      totalWeight: efTotal.getInputNumber() ?? 0,
    );
  }
}

class StockOpnameBindings extends Bindings {
  BuildContext context;
  StockOpnameBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => StockOpnameController(context: context));
  }
}
