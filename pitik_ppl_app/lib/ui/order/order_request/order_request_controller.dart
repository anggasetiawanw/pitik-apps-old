
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/suggest_field/suggest_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
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

    final GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey<AutoCompleteTextFieldState<String>>();
    late Coop coop;
    late SuggestField feedSuggestField;
    late SpinnerField feedCategory;
    late EditField feedQuantityField;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

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
                key: key,
                controller: GetXCreator.putSuggestFieldController<Product>("orderFeedSuggest"),
                label: "Merek Pakan",
                hint: "Cari merek pakan",
                alertText: "Merek Pakan masih kosong..!",
                suggestList: const [],
                onTyping: (text) => getFeedBrand(keyword: text)
            )
        );

        feedQuantityField = EditField(
            controller: GetXCreator.putEditFieldController("orderFeedQuantity"),
            label: "Total",
            hint: "Ketik di sini",
            alertText: "Total belum diisi..!",
            textUnit: "Karung",
            maxInput: 20,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );
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
                            onResponseDone: (code, message, body, id, packet) {
                                feedSuggestField.getController().setupObjects((body as ProductsResponse).data);
                                List<String> data = [];
                                for (var product in body.data) {
                                    data.add('${product == null || product.subcategoryName == null ? '' : product.subcategoryName} - ${product == null || product.productName == null ? '' : product.productName}');
                                }
                                feedSuggestField.getController().generateItems(data);
                            },
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

    Product getSelectedObject() {
        if (feedSuggestField.getController().getSelectedObject() != null) {
            Product product = feedSuggestField.getController().getSelectedObject();
            product.quantity = feedQuantityField.getInputNumber() ?? 0;

            return product;
        } else {
            return Product();
        }
    }

    Product getSelectedObjectWhenIncreased(Product oldProduct) {
        if (feedSuggestField.getController().getSelectedObject() != null) {
            Product product = feedSuggestField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (feedQuantityField.getInputNumber() ?? 0);

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

    String getFeedQuantity(Product? product) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${feedQuantityField.getTextUnit()}';
        } else {
            return '${feedQuantityField.getInputNumber() == null ? '' : feedQuantityField.getInputNumber()!.toStringAsFixed(0)} ${feedQuantityField.getTextUnit()}';
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