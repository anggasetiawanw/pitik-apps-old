import 'dart:convert';

import 'package:common_page/library/component_library.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/global_var.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/product_model.dart';
import 'package:model/response/products_response.dart';
import 'package:model/response/stock_summary_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 8/12/2023

class AdjustmentFeedController extends GetxController {
  BuildContext context;
  AdjustmentFeedController({required this.context});

  late Coop coop;
  late EditAreaField eaNotes;
  late MultipleFormField<Product> feedMultipleFormField;
  late SpinnerField feedCategory;
  late SpinnerField feedBrandSpinnerField;
  late EditField feedQuantityField;

  var isLoading = false.obs;
  var isLoadingFeedBrand = false.obs;
  var prestarterStockSummary = '-'.obs;
  var starterStockSummary = '-'.obs;
  var finisherStockSummary = '-'.obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    eaNotes = EditAreaField(controller: GetXCreator.putEditAreaFieldController('adjustmentFeedNotes'), label: 'Catatan', hint: 'Tulis Catatan', alertText: 'Harus diisi..!', maxInput: 300, onTyping: (text, field) {});

    // SETUP FEED WIDGET
    feedCategory = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController('adjustmentFeedCategory'),
        label: 'Kategori Pakan',
        hint: 'Pilih Kategori Pakan',
        backgroundField: GlobalVar.primaryLight,
        alertText: 'Kategori Pakan harus dipilih..!',
        items: const {'PRESTARTER': false, 'STARTER': false, 'FINISHER': false},
        onSpinnerSelected: (text) => _getFeedBrandByCategory());

    feedBrandSpinnerField = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController<Product>('adjustmentFeedSpinnerField'),
        label: 'Merek Pakan',
        hint: 'Pilih merek pakan',
        alertText: 'Merek Pakan masih kosong..!',
        items: const {},
        onSpinnerSelected: (text) => feedQuantityField.getController().changeTextUnit(_getLatestFeedTextUnit()));

    feedQuantityField = EditField(
        controller: GetXCreator.putEditFieldController('adjustmentFeedQuantity'), label: 'Total', hint: 'Ketik di sini', alertText: 'Total belum diisi..!', textUnit: '', maxInput: 20, inputType: TextInputType.number, onTyping: (text, field) {});

    feedMultipleFormField = MultipleFormField<Product>(
        controller: GetXCreator.putMultipleFormFieldController<Product>('adjustmentMultipleFeed'),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        labelButtonAdd: 'Tambah Pakan',
        initInstance: Product(),
        childAdded: () => _createChildAdded(getFeedProductName(), getFeedQuantity(product: null)),
        increaseWhenDuplicate: (product) => _createChildAdded(getFeedProductName(), getFeedQuantity(product: product)),
        selectedObject: () => getFeedSelectedObject(),
        selectedObjectWhenIncreased: (product) => getFeedSelectedObjectWhenIncreased(product),
        keyData: () => getFeedProductName(),
        validationAdded: () {
          bool isPass = true;
          if (feedCategory.getController().selectedIndex == -1) {
            feedCategory.getController().showAlert();
            isPass = false;
          }
          if (feedBrandSpinnerField.getController().selectedObject == null) {
            feedBrandSpinnerField.getController().showAlert();
            isPass = false;
          }
          if (feedQuantityField.getInputNumber() == null) {
            feedQuantityField.getController().showAlert();
            isPass = false;
          }

          return isPass;
        },
        child: Column(children: [feedCategory, feedQuantityField, isLoadingFeedBrand.isTrue ? const Center(child: ProgressLoading()) : feedBrandSpinnerField]));

    _getFeedStockSummary();
  }

  void refreshData() {
    _getFeedStockSummary();
    _getFeedBrandByCategory();
  }

  Row _createChildAdded(String productName, String quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(productName, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
        const SizedBox(width: 16),
        Text(quantity, style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
      ],
    );
  }

  String getFeedProductName({Product? product}) {
    if (product != null) {
      return '${product.subcategoryCode ?? ''} - ${product.productName ?? ''}';
    } else {
      if (feedBrandSpinnerField.getController().selectedObject == null) {
        return '';
      } else {
        return '${(feedBrandSpinnerField.getController().selectedObject as Product).subcategoryCode ?? ''} - ${(feedBrandSpinnerField.getController().selectedObject as Product).productName ?? ''}';
      }
    }
  }

  String getFeedQuantity({Product? product}) {
    if (product != null) {
      return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''}';
    } else {
      return '${feedQuantityField.getInputNumber() == null ? '' : feedQuantityField.getInputNumber()!.toStringAsFixed(0)} ${feedQuantityField.getController().textUnit.value}';
    }
  }

  String _getLatestFeedTextUnit() {
    if (feedBrandSpinnerField.controller.selectedObject == null) {
      return '';
    } else {
      if ((feedBrandSpinnerField.controller.selectedObject as Product).purchaseUom != null) {
        return (feedBrandSpinnerField.controller.selectedObject as Product).purchaseUom!;
      } else if ((feedBrandSpinnerField.controller.selectedObject as Product).uom != null) {
        return (feedBrandSpinnerField.controller.selectedObject as Product).uom!;
      } else {
        return '';
      }
    }
  }

  String _getRemainingQuantity(Product product) {
    return '${product.remainingQuantity == null ? '-' : product.remainingQuantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''}';
  }

  Product getFeedSelectedObject() {
    if (feedBrandSpinnerField.controller.getSelectedObject() != null) {
      final Product product = feedBrandSpinnerField.controller.getSelectedObject();
      product.quantity = feedQuantityField.getInputNumber() ?? 0;

      return product;
    } else {
      return Product();
    }
  }

  Product getFeedSelectedObjectWhenIncreased(Product oldProduct) {
    if (feedBrandSpinnerField.controller.getSelectedObject() != null) {
      final Product product = feedBrandSpinnerField.controller.getSelectedObject();
      product.quantity = (oldProduct.quantity ?? 0) + (feedQuantityField.getInputNumber() ?? 0);

      return product;
    } else {
      return Product();
    }
  }

  void _getFeedStockSummary() => AuthImpl().get().then((auth) => {
        if (auth != null)
          {
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getStocksSummary,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathFeedSummaryStocks(coop.farmingCycleId!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                      if ((body as StockSummaryResponse).data != null && body.data!.summaries.isNotEmpty) {
                        for (var product in body.data!.summaries) {
                          if (product != null) {
                            if (product.subcategoryCode != null && product.subcategoryCode == 'PRESTARTER') {
                              prestarterStockSummary.value = _getRemainingQuantity(product);
                            } else if (product.subcategoryCode != null && product.subcategoryCode == 'STARTER') {
                              starterStockSummary.value = _getRemainingQuantity(product);
                            } else if (product.subcategoryCode != null && product.subcategoryCode == 'FINISHER') {
                              finisherStockSummary.value = _getRemainingQuantity(product);
                            }
                          }
                        }
                      }
                    },
                    onResponseFail: (code, message, body, id, packet) {},
                    onResponseError: (exception, stacktrace, id, packet) {},
                    onTokenInvalid: () => GlobalVar.invalidResponse()))
          }
        else
          {GlobalVar.invalidResponse()}
      });

  void _getFeedBrandByCategory() => AuthImpl().get().then((auth) {
        if (auth != null) {
          isLoadingFeedBrand.value = true;
          Service.push(
              apiKey: 'productReportApi',
              service: ListApi.getStocks,
              context: context,
              body: ['Bearer ${auth.token}', auth.id, 'v2/feedstocks/${coop.farmingCycleId}/summaries?subcategoryCode=${feedCategory.controller.textSelected.value}'],
              listener: ResponseListener(
                  onResponseDone: (code, message, body, id, packet) {
                    feedBrandSpinnerField.controller.listObject.clear();
                    feedBrandSpinnerField.controller.items.clear();
                    feedBrandSpinnerField.controller.setTextSelected('');
                    feedBrandSpinnerField.controller.selectedObject = null;

                    if ((body as ProductsResponse).data.isNotEmpty) {
                      feedBrandSpinnerField.controller.setupObjects(body.data);
                      for (var product in body.data) {
                        final String key = '${product == null || product.subcategoryCode == null ? '' : product.subcategoryCode} - ${product == null || product.productName == null ? '' : product.productName}';
                        feedBrandSpinnerField.controller.addItems(value: key, isActive: false);
                      }
                    }

                    isLoadingFeedBrand.value = false;
                  },
                  onResponseFail: (code, message, body, id, packet) {
                    isLoadingFeedBrand.value = false;
                    Get.snackbar(
                      'Pesan',
                      'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  },
                  onResponseError: (exception, stacktrace, id, packet) {
                    isLoadingFeedBrand.value = false;
                    Get.snackbar(
                      'Pesan',
                      'Terjadi Kesalahan, $exception',
                      snackPosition: SnackPosition.TOP,
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                    );
                  },
                  onTokenInvalid: () => GlobalVar.invalidResponse()));
        } else {
          GlobalVar.invalidResponse();
        }
      });

  void saveAdjustment() => AuthImpl().get().then((auth) {
        if (auth != null) {
          showModalBottomSheet(
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )),
              isScrollControlled: true,
              context: Get.context!,
              builder: (context) => Container(
                  color: Colors.transparent,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                            const SizedBox(height: 16),
                            Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                            const SizedBox(height: 16),
                            Text('Penyesuaian Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                            const SizedBox(height: 8),
                            Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Column(
                                  children: feedMultipleFormField.controller.listObjectAdded.entries.map((entry) {
                                    final Product product = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: Text(getFeedProductName(product: product), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium), overflow: TextOverflow.clip)),
                                          const SizedBox(width: 12),
                                          Text(getFeedQuantity(product: product), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )),
                            const SizedBox(height: 50),
                            SizedBox(
                                width: MediaQuery.of(Get.context!).size.width - 32,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(
                                      child: ButtonFill(
                                          controller: GetXCreator.putButtonFillController('btnAgreeAdjustmentFeed'),
                                          label: 'Yakin',
                                          onClick: () {
                                            Navigator.pop(Get.context!);
                                            isLoading.value = true;

                                            final List<dynamic> body = [];
                                            for (var product in feedMultipleFormField.controller.listObjectAdded.values) {
                                              body.add({'feedStockSummaryId': (product as Product).id, 'adjustmentQuantity': product.quantity, 'type': 'Pengurangan', 'remarks': eaNotes.getInput()});
                                            }

                                            Service.push(
                                                apiKey: 'productReportApi',
                                                service: ListApi.saveStocks,
                                                context: context,
                                                body: ['Bearer ${auth.token}', auth.id, 'v2/feedstocks/${coop.farmingCycleId}/adjustments', jsonEncode(body)],
                                                listener: ResponseListener(
                                                    onResponseDone: (code, message, body, id, packet) {
                                                      Get.back();
                                                      Get.snackbar(
                                                        'Pesan',
                                                        'Pencatatan Pakan berhasil....',
                                                        snackPosition: SnackPosition.TOP,
                                                        colorText: Colors.black,
                                                        backgroundColor: Colors.white,
                                                      );
                                                      isLoading.value = false;
                                                    },
                                                    onResponseFail: (code, message, body, id, packet) {
                                                      isLoading.value = false;
                                                      Get.snackbar(
                                                        'Pesan',
                                                        'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                                                        snackPosition: SnackPosition.TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors.red,
                                                      );
                                                    },
                                                    onResponseError: (exception, stacktrace, id, packet) {
                                                      isLoading.value = false;
                                                      Get.snackbar(
                                                        'Pesan',
                                                        'Terjadi Kesalahan, $exception',
                                                        snackPosition: SnackPosition.TOP,
                                                        colorText: Colors.white,
                                                        backgroundColor: Colors.red,
                                                      );
                                                    },
                                                    onTokenInvalid: () => GlobalVar.invalidResponse()));
                                          })),
                                  const SizedBox(width: 16),
                                  Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController('btnNotAdjustmentFeed'), label: 'Tidak Yakin', onClick: () => Navigator.pop(Get.context!)))
                                ])),
                            const SizedBox(height: 32)
                          ])))));
        } else {
          GlobalVar.invalidResponse();
        }
      });
}

class AdjustmentFeedBinding extends Bindings {
  BuildContext context;
  AdjustmentFeedBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<AdjustmentFeedController>(() => AdjustmentFeedController(context: context));
}
