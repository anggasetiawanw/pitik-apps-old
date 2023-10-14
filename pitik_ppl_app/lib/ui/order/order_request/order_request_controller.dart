
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/suggest_field/suggest_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/product_model.dart';
import 'package:model/response/products_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderRequestController extends GetxController {
    BuildContext context;
    OrderRequestController({required this.context});

    late Coop coop;
    late DateTimeField orderDateField;
    late SpinnerField orderTypeField;
    late SpinnerField orderMultipleLogisticField;

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

    var isFeed = true.obs;
    var isVendor = true.obs;
    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        isLoading.value = true;
        coop = Get.arguments[0];

        orderDateField = DateTimeField(controller: GetXCreator.putDateTimeFieldController("orderDateField"), label: "Tanggal Order", hint: "20/02/2022", alertText: "Tanggal Order harus diisi..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}')
        );

        orderTypeField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderTypeField"), label: "Jenis Order", hint: "Pakan", alertText: "", backgroundField: GlobalVar.primaryLight,
            items: const {"Pakan": true, "OVK": false},
            onSpinnerSelected: (text) => isFeed.value = orderTypeField.getController().selectedIndex != -1 && orderTypeField.getController().selectedIndex == 0
        );

        orderMultipleLogisticField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderMultipleLogisticField"), label: "Apakah Pengiriman Digabung?", hint: "Pilih salah satu", alertText: "Harus dipilih..!", backgroundField: GlobalVar.primaryLight,
            items: const {"Ya": false, "Tidak": false},
            onSpinnerSelected: (text) {}
        );

        // SETUP FEED WIDGET
        feedCategory = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderFeedCategory"), label: "Kategori Pakan", hint: "Pilih Merek Pakan", backgroundField: GlobalVar.primaryLight, alertText: "Kategori Pakan harus dipilih..!",
            items: const {"PRESTARTER": false, "STARTER": false, "FINISHER": false},
            onSpinnerSelected: (text) {}
        );

        feedSuggestField = (
            SuggestField(
                controller: GetXCreator.putSuggestFieldController<Product>("orderFeedSuggest"),
                childPrefix: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset('images/search_icon.svg'),
                ),
                label: "Merek Pakan",
                hint: "Cari merek pakan",
                alertText: "Merek Pakan masih kosong..!",
                suggestList: const [],
                onTyping: (text) => getFeedBrand(keyword: text),
                onSubmitted: (text) => feedQuantityField.getController().changeTextUnit(_getLatestFeedTextUnit()),
            )
        );

        feedQuantityField = EditField(controller: GetXCreator.putEditFieldController("orderFeedQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        feedMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleFeed"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah Pakan',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getFeedProductName(), getFeedQuantity(null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getFeedProductName(), getFeedQuantity(product)),
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
            child: Column(
                children: [
                    feedCategory,
                    feedSuggestField,
                    feedQuantityField
                ]
            )
        );

        // SETUP OVK WIDGET
        ovkSuggestField = (
            SuggestField(
                controller: GetXCreator.putSuggestFieldController<Product>("orderOvkSuggest"),
                childPrefix: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset('images/search_icon.svg'),
                ),
                label: "Jenis OVK",
                hint: "Cari merek OVK",
                alertText: "Jenis OVK masih kosong..!",
                suggestList: const [],
                onTyping: (text) => getOvkBrand(keyword: text),
                onSubmitted: (text) => ovkQuantityField.getController().changeTextUnit(_getLatestOvkTextUnit()),
            )
        );

        ovkQuantityField = EditField(controller: GetXCreator.putEditFieldController("orderOvkQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        ovkMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleOvk"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product)),
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
            child: Column(
                children: [
                    ovkSuggestField,
                    ovkQuantityField
                ]
            )
        );

        // SETUP OVK OWN FARM WIDGET
        ovkUnitSuggestField = (
            SuggestField(
                controller: GetXCreator.putSuggestFieldController<Product>("orderOvkUnitSuggest"),
                childPrefix: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset('images/search_icon.svg'),
                ),
                label: "Jenis OVK",
                hint: "Cari merek OVK",
                alertText: "Jenis OVK masih kosong..!",
                suggestList: const [],
                onTyping: (text) => getOvkUnitBrand(keyword: text),
                onSubmitted: (text) => ovkUnitQuantityField.getController().changeTextUnit(_getLatestOvkUnitTextUnit()),
            )
        );

        ovkUnitQuantityField = EditField(controller: GetXCreator.putEditFieldController("orderOvkUnitQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        ovkVendorMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleOvkVendor"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
            ),
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product)),
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
            child: Column(
                children: [
                    ovkSuggestField,
                    ovkQuantityField
                ]
            )
        );

        ovkUnitMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleOvkUnit"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
            ),
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getOvkUnitProductName(), getOvkUnitQuantity(null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkUnitProductName(), getOvkUnitQuantity(product)),
            selectedObject: () => getOvkUnitSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkUnitSelectedObjectWhenIncreased(product),
            keyData: () => getOvkUnitProductName(),
            validationAdded: () {
                bool isPass = true;
                if (ovkUnitSuggestField.getController().selectedObject == null) {
                    ovkUnitSuggestField.getController().showAlert();
                    isPass = false;
                }
                if (ovkUnitQuantityField.getInputNumber() == null) {
                    ovkUnitQuantityField.getController().showAlert();
                    isPass = false;
                }

                return isPass;
            },
            child: Column(
                children: [
                    ovkUnitSuggestField,
                    ovkUnitQuantityField
                ]
            )
        );

        isLoading.value = false;
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

    String _getLatestFeedTextUnit() {
        if (feedSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            if ((feedSuggestField.getController().selectedObject as Product).uom != null) {
                return (feedSuggestField.getController().selectedObject as Product).uom!;
            } else if ((feedSuggestField.getController().selectedObject as Product).purchaseUom != null) {
                return (feedSuggestField.getController().selectedObject as Product).purchaseUom!;
            } else {
                return '';
            }
        }
    }

    String _getLatestOvkTextUnit() {
        if (ovkSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            if ((ovkSuggestField.getController().selectedObject as Product).uom != null) {
                return (ovkSuggestField.getController().selectedObject as Product).uom!;
            } else if ((ovkSuggestField.getController().selectedObject as Product).purchaseUom != null) {
                return (ovkSuggestField.getController().selectedObject as Product).purchaseUom!;
            } else {
                return '';
            }
        }
    }

    String _getLatestOvkUnitTextUnit() {
        if (ovkUnitSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            if ((ovkUnitSuggestField.getController().selectedObject as Product).uom != null) {
                return (ovkUnitSuggestField.getController().selectedObject as Product).uom!;
            } else if ((ovkUnitSuggestField.getController().selectedObject as Product).purchaseUom != null) {
                return (ovkUnitSuggestField.getController().selectedObject as Product).purchaseUom!;
            } else {
                return '';
            }
        }
    }

    bool _validation() {
        bool isPass = true;
        if (orderDateField.getController().textSelected.isEmpty) {
            orderDateField.getController().showAlert();
            isPass  = false;
        }

        if (isFeed.isTrue) {
            if (orderMultipleLogisticField.getController().selectedIndex == -1) {
                orderMultipleLogisticField.getController().showAlert();
                isPass  = false;
            }
            if (feedMultipleFormField.getController().listObjectAdded.isEmpty) {
                Get.snackbar(
                    "Pesan",
                    "Merek Pakan masih kosong, silahkan isi terlebih dahulu..!",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isPass  = false;
            }
        } else if (coop.isOwnFarm != null && coop.isOwnFarm!) {
            if (ovkVendorMultipleFormField.getController().listObjectAdded.isEmpty && ovkUnitMultipleFormField.getController().listObjectAdded.isEmpty) {
                Get.snackbar(
                    "Pesan",
                    "Merek OVK Vendor ataupun Unit masih kosong, silahkan isi terlebih dahulu..!",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isPass  = false;
            }
        } else {
            if (ovkMultipleFormField.getController().listObjectAdded.isEmpty) {
                Get.snackbar(
                    "Pesan",
                    "Merek OVK masih kosong, silahkan isi terlebih dahulu..!",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
                isPass  = false;
            }
        }

        return isPass;
    }

    void sendOrder() {
        if (_validation()) {
            isLoading.value = true;
            AuthImpl().get().then((auth) => {
                if (auth != null) {

                } else {
                    GlobalVar.invalidResponse()
                }
            });
        }
    }

    void getFeedBrand({String? keyword}) {
        if (feedCategory.getController().selectedIndex == -1) {
            feedCategory.getController().showAlert();
        } else if (keyword != null && keyword.length > 3) {
            AuthImpl().get().then((auth) => {
                if (auth != null) {
                    Service.push(
                        apiKey: 'productReportApi',
                        service: ListApi.getProducts,
                        context: Get.context!,
                        body: ['Bearer ${auth.token}', auth.id, keyword, "PAKAN", feedCategory.getController().textSelected.value, 1, 100],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) => _setupSuggestBrand(field: feedSuggestField, productList: (body as ProductsResponse).data),
                            onResponseFail: (code, message, body, id, packet) {},
                            onResponseError: (exception, stacktrace, id, packet) {},
                            onTokenInvalid: () => GlobalVar.invalidResponse()
                        )
                    )
                } else {
                    GlobalVar.invalidResponse()
                }
            });
        }
    }

    void getOvkBrand({String? keyword}) {
        if (keyword != null && keyword.length > 3) {
            AuthImpl().get().then((auth) => {
                if (auth != null) {
                    Service.push(
                        apiKey: 'productReportApi',
                        service: ListApi.getProducts,
                        context: Get.context!,
                        body: ['Bearer ${auth.token}', auth.id, keyword, "OVK", null, 1, 100],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) => _setupSuggestBrand(field: ovkSuggestField, productList: (body as ProductsResponse).data, isFeed: false),
                            onResponseFail: (code, message, body, id, packet) {},
                            onResponseError: (exception, stacktrace, id, packet) {},
                            onTokenInvalid: () => GlobalVar.invalidResponse()
                        )
                    )
                } else {
                    GlobalVar.invalidResponse()
                }
            });
        }
    }

    void getOvkUnitBrand({String? keyword}) {
        if (keyword != null && keyword.length > 3) {
            AuthImpl().get().then((auth) => {
                if (auth != null) {
                    Service.push(
                        apiKey: 'productReportApi',
                        service: ListApi.searchOvkUnit,
                        context: Get.context!,
                        body: ['Bearer ${auth.token}', auth.id, keyword, coop.branch == null ? null : coop.branch!.id, "OVK", 1, 100],
                        listener: ResponseListener(
                            onResponseDone: (code, message, body, id, packet) => _setupSuggestBrand(field: ovkUnitSuggestField, productList: (body as ProductsResponse).data, isFeed: false),
                            onResponseFail: (code, message, body, id, packet) {},
                            onResponseError: (exception, stacktrace, id, packet) {},
                            onTokenInvalid: () => GlobalVar.invalidResponse()
                        )
                    )
                } else {
                    GlobalVar.invalidResponse()
                }
            });
        }
    }

    void _setupSuggestBrand({required SuggestField field, required List<Product?> productList, bool isFeed = true}) {
        field.getController().setupObjects(productList);
        List<String> data = [];
        for (var product in productList) {
            data.add(
                isFeed ?
                '${product == null || product.subcategoryName == null ? '' : product.subcategoryName} - ${product == null || product.productName == null ? '' : product.productName}' :
                '${product == null || product.productName == null ? '' : product.productName}'
            );
        }
        field.getController().generateItems(data);
    }

    Product getFeedSelectedObject() {
        if (feedSuggestField.getController().getSelectedObject() != null) {
            Product product = feedSuggestField.getController().getSelectedObject();
            product.quantity = feedQuantityField.getInputNumber() ?? 0;

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkSelectedObject() {
        if (ovkSuggestField.getController().getSelectedObject() != null) {
            Product product = ovkSuggestField.getController().getSelectedObject();
            product.quantity = ovkQuantityField.getInputNumber() ?? 0;

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkUnitSelectedObject() {
        if (ovkUnitSuggestField.getController().getSelectedObject() != null) {
            Product product = ovkUnitSuggestField.getController().getSelectedObject();
            product.quantity = ovkUnitQuantityField.getInputNumber() ?? 0;

            return product;
        } else {
            return Product();
        }
    }

    Product getFeedSelectedObjectWhenIncreased(Product oldProduct) {
        if (feedSuggestField.getController().getSelectedObject() != null) {
            Product product = feedSuggestField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (feedQuantityField.getInputNumber() ?? 0);

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkSelectedObjectWhenIncreased(Product oldProduct) {
        if (ovkSuggestField.getController().getSelectedObject() != null) {
            Product product = ovkSuggestField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (ovkQuantityField.getInputNumber() ?? 0);

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkUnitSelectedObjectWhenIncreased(Product oldProduct) {
        if (ovkUnitSuggestField.getController().getSelectedObject() != null) {
            Product product = ovkUnitSuggestField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (ovkUnitQuantityField.getInputNumber() ?? 0);

            return product;
        } else {
            return Product();
        }
    }

    String getFeedProductName() {
        if (feedSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            return '${(feedSuggestField.getController().selectedObject as Product).subcategoryName ?? ''} - ${(feedSuggestField.getController().selectedObject as Product).productName ?? ''}';
        }
    }

    String getOvkProductName() {
        if (ovkSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            return (ovkSuggestField.getController().selectedObject as Product).productName ?? '';
        }
    }

    String getOvkUnitProductName() {
        if (ovkUnitSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            return (ovkUnitSuggestField.getController().selectedObject as Product).productName ?? '';
        }
    }

    String getFeedQuantity(Product? product) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${feedQuantityField.getController().textUnit.value}';
        } else {
            return '${feedQuantityField.getInputNumber() == null ? '' : feedQuantityField.getInputNumber()!.toStringAsFixed(0)} ${feedQuantityField.getController().textUnit.value}';
        }
    }

    String getOvkQuantity(Product? product) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${ovkQuantityField.getController().textUnit.value}';
        } else {
            return '${ovkQuantityField.getInputNumber() == null ? '' : ovkQuantityField.getInputNumber()!.toStringAsFixed(0)} ${ovkQuantityField.getController().textUnit.value}';
        }
    }

    String getOvkUnitQuantity(Product? product) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${ovkUnitQuantityField.getController().textUnit.value}';
        } else {
            return '${ovkUnitQuantityField.getInputNumber() == null ? '' : ovkUnitQuantityField.getInputNumber()!.toStringAsFixed(0)} ${ovkUnitQuantityField.getController().textUnit.value}';
        }
    }
}

class OrderRequestBinding extends Bindings {
    BuildContext context;
    OrderRequestBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<OrderRequestController>(() => OrderRequestController(context: context));
    }
}