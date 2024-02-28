import 'dart:convert';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/suggest_field/suggest_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/product_model.dart';
import 'package:model/response/products_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 12/12/2023

class AdjustmentProductController extends GetxController {
  BuildContext context;
  AdjustmentProductController({required this.context});

  late Coop coop;
  late bool isFeed;
  late SpinnerField adjustmentTypeField;

  // for FEED
  late SuggestField feedSuggestField;
  late SpinnerField feedCategory;
  late EditField feedQuantityField;
  late MultipleFormField<Product> feedMultipleFormField;

  // for OVK
  late SuggestField ovkSuggestField;
  late SuggestField ovkUnitSuggestField;
  late EditField ovkQuantityField;
  late EditField ovkUnitQuantityField;
  late MultipleFormField<Product> ovkMultipleFormField;
  late MultipleFormField<Product> ovkVendorMultipleFormField;
  late MultipleFormField<Product> ovkUnitMultipleFormField;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    isFeed = Get.arguments[1];

    adjustmentTypeField = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController('adjustmentProductTypeField'),
        label: 'Jenis Penyesuaian',
        hint: 'Pilih salah satu..!',
        alertText: 'Harus pilih salah satu..!',
        items: const {'Pengurangan': true, 'Penambahan': false},
        onSpinnerSelected: (text) {});
    adjustmentTypeField.controller.disable();

    // SETUP FEED WIDGET
    feedCategory = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController('adjustmentProductFeedCategory'),
        label: 'Kategori Pakan',
        hint: 'Pilih Merek Pakan',
        backgroundField: GlobalVar.primaryLight,
        alertText: 'Kategori Pakan harus dipilih..!',
        items: const {'PRESTARTER': false, 'STARTER': false, 'FINISHER': false},
        onSpinnerSelected: (text) {});

    feedSuggestField = SuggestField(
      controller: GetXCreator.putSuggestFieldController<Product>('adjustmentProductFeedSuggest'),
      childPrefix: Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset('images/search_icon.svg'),
      ),
      label: 'Merek Pakan',
      hint: 'Cari merek pakan',
      alertText: 'Merek Pakan masih kosong..!',
      suggestList: const [],
      onTyping: (text) => getFeedBrand(keyword: text),
      onSubmitted: (text) => feedQuantityField.getController().changeTextUnit(_getLatestFeedTextUnit()),
    );

    feedQuantityField = EditField(
        controller: GetXCreator.putEditFieldController('adjustmentProductFeedQuantity'),
        label: 'Total',
        hint: 'Ketik di sini',
        alertText: 'Total belum diisi..!',
        textUnit: '',
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (text, field) {});

    feedMultipleFormField = MultipleFormField<Product>(
        controller: GetXCreator.putMultipleFormFieldController<Product>('adjustmentProductMultipleFeed'),
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
          if (feedSuggestField.getController().selectedObject == null) {
            feedSuggestField.getController().showAlert();
            isPass = false;
          }
          if (feedQuantityField.getInputNumber() == null) {
            feedQuantityField.getController().showAlert();
            isPass = false;
          }

          return isPass;
        },
        child: Column(children: [feedCategory, feedSuggestField, feedQuantityField]));

    // SETUP OVK WIDGET
    ovkSuggestField = SuggestField(
      controller: GetXCreator.putSuggestFieldController<Product>('adjustmentProductOvkSuggest'),
      childPrefix: Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset('images/search_icon.svg'),
      ),
      label: 'Jenis OVK',
      hint: 'Cari merek OVK',
      alertText: 'Jenis OVK masih kosong..!',
      suggestList: const [],
      onTyping: (text) => getOvkBrand(keyword: text),
      onSubmitted: (text) => ovkQuantityField.getController().changeTextUnit(_getLatestOvkTextUnit()),
    );

    ovkQuantityField = EditField(
        controller: GetXCreator.putEditFieldController('adjustmentProductOvkQuantity'),
        label: 'Total',
        hint: 'Ketik di sini',
        alertText: 'Total belum diisi..!',
        textUnit: '',
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (text, field) {});

    ovkMultipleFormField = MultipleFormField<Product>(
        controller: GetXCreator.putMultipleFormFieldController<Product>('adjustmentProductMultipleOvk'),
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        labelButtonAdd: 'Tambah OVK',
        initInstance: Product(),
        childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(product: null)),
        increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product: product)),
        selectedObject: () => getOvkSelectedObject(),
        selectedObjectWhenIncreased: (product) => getOvkSelectedObjectWhenIncreased(product),
        keyData: () => getOvkProductName(),
        validationAdded: () {
          bool isPass = true;
          if (ovkSuggestField.getController().selectedObject == null) {
            ovkSuggestField.getController().showAlert();
            isPass = false;
          }
          if (ovkQuantityField.getInputNumber() == null) {
            ovkQuantityField.getController().showAlert();
            isPass = false;
          }

          return isPass;
        },
        child: Column(children: [ovkSuggestField, ovkQuantityField]));
  }

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
                                          controller: GetXCreator.putButtonFillController('btnAgreeAdjustmentProduct'),
                                          label: 'Yakin',
                                          onClick: () {
                                            Navigator.pop(Get.context!);
                                            isLoading.value = true;

                                            final List<dynamic> body = [];
                                            for (var product in feedMultipleFormField.controller.listObjectAdded.values) {
                                              body.add({
                                                'feedStockSummaryId': isFeed ? (product as Product).id : null,
                                                'ovkStockSummaryId': isFeed ? null : (product as Product).id,
                                                'adjustmentQuantity': product.quantity,
                                                'type': adjustmentTypeField.controller.textSelected.value
                                              });
                                            }

                                            Service.push(
                                                apiKey: 'productReportApi',
                                                service: ListApi.saveStocks,
                                                context: context,
                                                body: ['Bearer ${auth.token}', auth.id, '${isFeed ? 'v2/feedstocks/' : 'v2/ovkstocks/'}${coop.farmingCycleId}/adjustments', jsonEncode(body)],
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
                                  Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController('btnNotAdjustmentProduct'), label: 'Tidak Yakin', onClick: () => Navigator.pop(Get.context!)))
                                ])),
                            const SizedBox(height: 32)
                          ])))));
        } else {
          GlobalVar.invalidResponse();
        }
      });

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

  String _getLatestFeedTextUnit() {
    if (feedSuggestField.getController().selectedObject == null) {
      return '';
    } else {
      if ((feedSuggestField.getController().selectedObject as Product).purchaseUom != null) {
        return (feedSuggestField.getController().selectedObject as Product).purchaseUom!;
      } else if ((feedSuggestField.getController().selectedObject as Product).uom != null) {
        return (feedSuggestField.getController().selectedObject as Product).uom!;
      } else {
        return '';
      }
    }
  }

  String _getLatestOvkTextUnit() {
    if (ovkSuggestField.getController().selectedObject == null) {
      return '';
    } else {
      if ((ovkSuggestField.getController().selectedObject as Product).purchaseUom != null) {
        return (ovkSuggestField.getController().selectedObject as Product).purchaseUom!;
      } else if ((ovkSuggestField.getController().selectedObject as Product).uom != null) {
        return (ovkSuggestField.getController().selectedObject as Product).uom!;
      } else {
        return '';
      }
    }
  }

  void getFeedBrand({String? keyword}) {
    if (feedCategory.getController().selectedIndex == -1) {
      feedCategory.getController().showAlert();
    } else if (keyword != null && keyword.length > 3) {
      AuthImpl().get().then((auth) => {
            if (auth != null)
              {
                Service.push(
                    apiKey: 'productReportApi',
                    service: ListApi.getProducts,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, keyword, 'PAKAN', feedCategory.getController().textSelected.value, 1, 100],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) => _setupSuggestBrand(field: feedSuggestField, productList: (body as ProductsResponse).data),
                        onResponseFail: (code, message, body, id, packet) {},
                        onResponseError: (exception, stacktrace, id, packet) {},
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
              }
            else
              {GlobalVar.invalidResponse()}
          });
    }
  }

  void getOvkBrand({String? keyword}) {
    if (keyword != null && keyword.length > 3) {
      AuthImpl().get().then((auth) => {
            if (auth != null)
              {
                Service.push(
                    apiKey: 'productReportApi',
                    service: ListApi.getProducts,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, keyword, 'OVK', null, 1, 100],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) => _setupSuggestBrand(field: ovkSuggestField, productList: (body as ProductsResponse).data, isFeed: false),
                        onResponseFail: (code, message, body, id, packet) {},
                        onResponseError: (exception, stacktrace, id, packet) {},
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
              }
            else
              {GlobalVar.invalidResponse()}
          });
    }
  }

  void getOvkUnitBrand({String? keyword}) {
    if (keyword != null && keyword.length > 3) {
      AuthImpl().get().then((auth) => {
            if (auth != null)
              {
                Service.push(
                    apiKey: 'productReportApi',
                    service: ListApi.searchOvkUnit,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, keyword, coop.branch?.id, 'OVK', 1, 100],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) => _setupSuggestBrand(field: ovkUnitSuggestField, productList: (body as ProductsResponse).data, isFeed: false),
                        onResponseFail: (code, message, body, id, packet) {},
                        onResponseError: (exception, stacktrace, id, packet) {},
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
              }
            else
              {GlobalVar.invalidResponse()}
          });
    }
  }

  void _setupSuggestBrand({required SuggestField field, required List<Product?> productList, bool isFeed = true}) {
    field.getController().setupObjects(productList);
    final List<String> data = [];
    for (var product in productList) {
      data.add(isFeed
          ? '${product == null || product.subcategoryName == null ? '' : product.subcategoryName} - ${product == null || product.productName == null ? '' : product.productName}'
          : '${product == null || product.productName == null ? '' : product.productName}');
    }
    field.getController().generateItems(data);
  }

  Product getFeedSelectedObject() {
    if (feedSuggestField.getController().getSelectedObject() != null) {
      final Product product = feedSuggestField.getController().getSelectedObject();
      product.quantity = feedQuantityField.getInputNumber() ?? 0;

      return product;
    } else {
      return Product();
    }
  }

  Product getOvkSelectedObject() {
    if (ovkSuggestField.getController().getSelectedObject() != null) {
      final Product product = ovkSuggestField.getController().getSelectedObject();
      product.quantity = ovkQuantityField.getInputNumber() ?? 0;

      return product;
    } else {
      return Product();
    }
  }

  Product getFeedSelectedObjectWhenIncreased(Product oldProduct) {
    if (feedSuggestField.getController().getSelectedObject() != null) {
      final Product product = feedSuggestField.getController().getSelectedObject();
      product.quantity = (oldProduct.quantity ?? 0) + (feedQuantityField.getInputNumber() ?? 0);

      return product;
    } else {
      return Product();
    }
  }

  Product getOvkSelectedObjectWhenIncreased(Product oldProduct) {
    if (ovkSuggestField.getController().getSelectedObject() != null) {
      final Product product = ovkSuggestField.getController().getSelectedObject();
      product.quantity = (oldProduct.quantity ?? 0) + (ovkQuantityField.getInputNumber() ?? 0);

      return product;
    } else {
      return Product();
    }
  }

  String getFeedProductName({Product? product}) {
    if (product != null) {
      return '${product.subcategoryName ?? ''} - ${product.productName ?? ''}';
    } else {
      if (feedSuggestField.getController().selectedObject == null) {
        return '';
      } else {
        return '${(feedSuggestField.getController().selectedObject as Product).subcategoryName ?? ''} - ${(feedSuggestField.getController().selectedObject as Product).productName ?? ''}';
      }
    }
  }

  String getOvkProductName({Product? product}) {
    if (product != null) {
      return product.productName ?? '';
    } else {
      if (ovkSuggestField.getController().selectedObject == null) {
        return '';
      } else {
        return (ovkSuggestField.getController().selectedObject as Product).productName ?? '';
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

  String getOvkQuantity({Product? product}) {
    if (product != null) {
      return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''}';
    } else {
      return '${ovkQuantityField.getInputNumber() == null ? '' : ovkQuantityField.getInputNumber()!.toStringAsFixed(0)} ${ovkQuantityField.getController().textUnit.value}';
    }
  }
}

class AdjustmentProductBinding extends Bindings {
  BuildContext context;
  AdjustmentProductBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<AdjustmentProductController>(() => AdjustmentProductController(context: context));
}
