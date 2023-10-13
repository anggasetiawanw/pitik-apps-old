
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
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

    final GlobalKey<AutoCompleteTextFieldState<String>> keyFeed = GlobalKey<AutoCompleteTextFieldState<String>>();
    final GlobalKey<AutoCompleteTextFieldState<String>> keyOvk = GlobalKey<AutoCompleteTextFieldState<String>>();
    final GlobalKey<AutoCompleteTextFieldState<String>> keyOvkUnit = GlobalKey<AutoCompleteTextFieldState<String>>();

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
    late MultipleFormField<Product> ovkUnitMultipleFormField;

    var isFeed = true.obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

        orderDateField = DateTimeField(controller: GetXCreator.putDateTimeFieldController("orderDateField"), label: "Tanggal Order", hint: "20/02/2022", alertText: "Tanggal Order harus diisi..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}')
        );

        orderTypeField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderTypeField"), label: "Jenis Order", hint: "Pakan", alertText: "", backgroundField: GlobalVar.primaryLight,
            items: const {"Pakan": true, "OVK": false},
            onSpinnerSelected: (text) => isFeed.value = orderTypeField.getController().selectedIndex != -1 && orderTypeField.getController().selectedIndex == 0
        );

        orderMultipleLogisticField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderMultipleLogisticField"), label: "Apakah Pengiriman Digabung?", hint: "Pilih salah satu", alertText: "", backgroundField: GlobalVar.primaryLight,
            items: const {"Ya": false, "Tidak": false},
            onSpinnerSelected: (text) {}
        );

        // SETUP FEED WIDGET
        feedCategory = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("orderFeedCategory"),
            label: "Kategori Pakan",
            hint: "Pilih Merek Pakan",
            backgroundField: GlobalVar.primaryLight,
            alertText: "Kategori Pakan harus dipilih..!",
            items: const {"PRESTARTER": false, "STARTER": false, "FINISHER": false},
            onSpinnerSelected: (text) {}
        );

        feedSuggestField = (
            SuggestField(
                key: keyFeed,
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

        feedQuantityField = EditField(
            controller: GetXCreator.putEditFieldController("orderFeedQuantity"),
            label: "Total",
            hint: "Ketik di sini",
            alertText: "Total belum diisi..!",
            textUnit: "",
            maxInput: 20,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        feedMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleFeed"),
            childAdded: () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Flexible(child: Text(getFeedProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                    const SizedBox(width: 16),
                    Text(getFeedQuantity(null), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                ],
            ),
            increaseWhenDuplicate: (product) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Flexible(child: Text(getFeedProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                        const SizedBox(width: 16),
                        Text(getFeedQuantity(product), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                    ],
                );
            },
            labelButtonAdd: 'Tambah Pakan',
            initInstance: Product(),
            selectedObject: () => getFeedSelectedObject(),
            selectedObjectWhenIncreased: (product) => getFeedSelectedObjectWhenIncreased(product),
            keyData: () => getFeedProductName(),
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
                key: keyOvk,
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

        ovkQuantityField = EditField(
            controller: GetXCreator.putEditFieldController("orderOvkQuantity"),
            label: "Total",
            hint: "Ketik di sini",
            alertText: "Total belum diisi..!",
            textUnit: "",
            maxInput: 20,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        ovkMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleOvk"),
            childAdded: () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Flexible(child: Text(getOvkProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                    const SizedBox(width: 16),
                    Text(getOvkQuantity(null), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                ],
            ),
            increaseWhenDuplicate: (product) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Flexible(child: Text(getOvkProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                        const SizedBox(width: 16),
                        Text(getOvkQuantity(product), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                    ],
                );
            },
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            selectedObject: () => getOvkSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkSelectedObjectWhenIncreased(product),
            keyData: () => getOvkProductName(),
            child: Column(
                children: [
                    ovkSuggestField,
                    ovkQuantityField
                ]
            )
        );

        // SETUP OVK UNIT WIDGET
        ovkUnitSuggestField = (
            SuggestField(
                key: keyOvkUnit,
                controller: GetXCreator.putSuggestFieldController<Product>("orderOvkUnitSuggest"),
                childPrefix: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset('images/search_icon.svg'),
                ),
                label: "Jenis OVK",
                hint: "Cari merek OVK",
                alertText: "Jenis OVK masih kosong..!",
                suggestList: const [],
                onTyping: (text) => getFeedBrand(keyword: text),
                onSubmitted: (text) => ovkUnitQuantityField.getController().changeTextUnit(_getLatestOvkUnitTextUnit()),
            )
        );

        ovkUnitQuantityField = EditField(
            controller: GetXCreator.putEditFieldController("orderOvkUnitQuantity"),
            label: "Total",
            hint: "Ketik di sini",
            alertText: "Total belum diisi..!",
            textUnit: "",
            maxInput: 20,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        ovkUnitMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleOvkUnit"),
            childAdded: () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Flexible(child: Text(getOvkUnitProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                    const SizedBox(width: 16),
                    Text(getOvkUnitQuantity(null), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                ],
            ),
            increaseWhenDuplicate: (product) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Flexible(child: Text(getOvkUnitProductName(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                        const SizedBox(width: 16),
                        Text(getOvkUnitQuantity(product), style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                    ],
                );
            },
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            selectedObject: () => getOvkUnitSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkUnitSelectedObjectWhenIncreased(product),
            keyData: () => getOvkUnitProductName(),
            child: Column(
                children: [
                    ovkUnitSuggestField,
                    ovkUnitQuantityField
                ]
            )
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