
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
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
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/procurement_model.dart';
import 'package:model/product_model.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:model/response/products_response.dart';
import 'package:common_page/transaction_success_activity.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class OrderRequestController extends GetxController {
    BuildContext context;
    OrderRequestController({required this.context});

    late Coop coop;
    late bool isEdit = false;
    late bool fromCoopRest;
    late Procurement procurement;
    late bool isOwnFarm = false;

    late DateTimeField orderDateField;
    late SpinnerField orderTypeField;
    late SpinnerField orderMultipleLogisticField;
    late SuggestField orderCoopTargetLogisticField;

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
    var isMerge = false.obs;
    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_order_form');
        isLoading.value = true;

        coop = Get.arguments[0];
        isEdit = Get.arguments[1];
        fromCoopRest = Get.arguments[2];
        isOwnFarm = coop.isOwnFarm != null && coop.isOwnFarm!;

        orderDateField = DateTimeField(controller: GetXCreator.putDateTimeFieldController("orderDateField"), label: "Tanggal Order", hint: "20/02/2022", alertText: "Tanggal Order harus diisi..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}')
        );

        orderTypeField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderTypeField"), label: "Jenis Order", hint: "Pakan", alertText: "", backgroundField: GlobalVar.primaryLight,
            items: const {"Pakan": true, "OVK": false},
            onSpinnerSelected: (text) => isFeed.value = orderTypeField.getController().selectedIndex != -1 && orderTypeField.getController().selectedIndex == 0
        );

        orderMultipleLogisticField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderMultipleLogisticField"), label: "Digabung?", hint: "Pilih salah satu", alertText: "Harus dipilih..!", backgroundField: GlobalVar.primaryLight,
            items: const {"Ya": false, "Tidak": false},
            onSpinnerSelected: (text) => isMerge.value = orderMultipleLogisticField.getController().selectedIndex != -1 && orderMultipleLogisticField.getController().selectedIndex == 0
        );

        orderCoopTargetLogisticField = SuggestField(
            controller: GetXCreator.putSuggestFieldController<Coop>("orderCoopTargetLogisticField"),
            childPrefix: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset('images/search_icon.svg'),
            ),
            label: "Nama Kandang",
            hint: "Cari Kandang",
            alertText: "Oops Nama kandang tidak ditemukan..!",
            suggestList: const [],
            onTyping: (text) {},
            onSubmitted: (text) {},
        );

        // SETUP FEED WIDGET
        feedCategory = SpinnerField(controller: GetXCreator.putSpinnerFieldController("orderFeedCategory"), label: "Kategori Pakan", hint: "Pilih Merek Pakan", backgroundField: GlobalVar.primaryLight, alertText: "Kategori Pakan harus dipilih..!",
            items: const {"PRESTARTER": false, "STARTER": false, "FINISHER": false},
            onSpinnerSelected: (text) {
                feedSuggestField.controller.listObject.clear();
                feedSuggestField.controller.suggestList.clear();
                feedSuggestField.controller.textEditingController.value.text = '';
            }
        );

        feedSuggestField = SuggestField(
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
        );

        feedQuantityField = EditField(controller: GetXCreator.putEditFieldController("orderFeedQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        feedMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleFeed"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah Pakan',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getFeedProductName(), getFeedQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getFeedProductName(), getFeedQuantity(product: product)),
            selectedObject: () => getFeedSelectedObject(),
            selectedObjectWhenIncreased: (product) => getFeedSelectedObjectWhenIncreased(product),
            keyData: () => getFeedProductName(),
            onAfterAdded: () {
                feedSuggestField.controller.reset();
                feedQuantityField.setInput('');
            },
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
        ovkSuggestField = SuggestField(
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
        );

        ovkQuantityField = EditField(controller: GetXCreator.putEditFieldController("orderOvkQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        ovkMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("orderMultipleOvk"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product: product)),
            selectedObject: () => getOvkSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkSelectedObjectWhenIncreased(product),
            keyData: () => getOvkProductName(),
            onAfterAdded: () {
                ovkSuggestField.controller.reset();
                ovkQuantityField.setInput('');
            },
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
        ovkUnitSuggestField = SuggestField(
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
            childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product: product)),
            selectedObject: () => getOvkSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkSelectedObjectWhenIncreased(product),
            keyData: () => getOvkProductName(),
            onAfterAdded: () {
                ovkSuggestField.controller.reset();
                ovkQuantityField.setInput('');
            },
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
            childAdded: () => _createChildAdded(getOvkUnitProductName(), getOvkUnitQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkUnitProductName(), getOvkUnitQuantity(product: product)),
            selectedObject: () => getOvkUnitSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkUnitSelectedObjectWhenIncreased(product),
            keyData: () => getOvkUnitProductName(),
            onAfterAdded: () {
                ovkUnitSuggestField.controller.reset();
                ovkUnitQuantityField.setInput('');
            },
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
        _getCoopTarget();
    }

    void _initializeFillForm() {
        // fill delivery date
        DateTime dateTime = Convert.getDatetime(procurement.deliveryDate!);
        orderDateField.getController().setTextSelected('${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}');

        // fill order type
        orderTypeField.getController().setSelected(procurement.type == 'pakan' ? 'Pakan' : 'OVK');
        orderTypeField.getController().disable();
        isFeed.value = procurement.type == 'pakan';

        // fill list order product
        if (isFeed.value) {
            // fill merged logistic
            orderMultipleLogisticField.getController().setSelected(procurement.mergedLogistic != null && procurement.mergedLogistic! ? "Ya" : "Tidak");
            orderCoopTargetLogisticField.getController().setSelectedObject(procurement.mergedLogisticCoopName == null ? "" : procurement.mergedLogisticCoopName!);
            isMerge.value = procurement.mergedLogistic != null && procurement.mergedLogistic!;

            // fill list product
            for (var product in procurement.details) {
                feedMultipleFormField.getController().addData(
                    child: _createChildAdded(getFeedProductName(product: product), getFeedQuantity(product: product)),
                    object: product,
                    key: getFeedProductName(product: product)
                );
            }
        } else {
            if (isOwnFarm) {
                // fill list product VENDOR
                for (var product in procurement.details) {
                    ovkVendorMultipleFormField.getController().addData(
                        child: _createChildAdded(getOvkProductName(product: product), getOvkQuantity(product: product)),
                        object: product,
                        key: getOvkProductName(product: product)
                    );
                }

                // fill list product UNIT
                if (procurement.internalOvkTransferRequest != null) {
                    for (var product in procurement.internalOvkTransferRequest!.details) {
                        ovkUnitMultipleFormField.getController().addData(
                            child: _createChildAdded(getOvkUnitProductName(product: product), getOvkUnitQuantity(product: product)),
                            object: product,
                            key: getOvkUnitProductName(product: product)
                        );
                    }
                }
            } else {
                // fill list product
                for (var product in procurement.details) {
                    ovkMultipleFormField.getController().addData(
                        child: _createChildAdded(getOvkProductName(product: product), getOvkQuantity(product: product)),
                        object: product,
                        key: getOvkProductName(product: product)
                    );
                }
            }
        }
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

    String _getLatestOvkUnitTextUnit() {
        if (ovkUnitSuggestField.getController().selectedObject == null) {
            return '';
        } else {
            if ((ovkUnitSuggestField.getController().selectedObject as Product).purchaseUom != null) {
                return (ovkUnitSuggestField.getController().selectedObject as Product).purchaseUom!;
            } else if ((ovkUnitSuggestField.getController().selectedObject as Product).uom != null) {
                return (ovkUnitSuggestField.getController().selectedObject as Product).uom!;
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
            if (orderMultipleLogisticField.getController().selectedIndex == 0 && orderCoopTargetLogisticField.getController().selectedObject == null) {
                orderCoopTargetLogisticField.getController().showAlert();
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
        } else if (isOwnFarm) {
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
            _showFeedSummary(isFeed: isFeed.value);
        }
    }

    void _showFeedSummary({bool isFeed = true}) {
        showModalBottomSheet(
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                )
            ),
            isScrollControlled: true,
            context: Get.context!,
            builder: (context) => Container(
                color: Colors.transparent,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Center(
                                    child: Container(
                                        width: 60,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: GlobalVar.outlineColor
                                        )
                                    )
                                ),
                                const SizedBox(height: 16),
                                Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                                const SizedBox(height: 16),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Tanggal Order', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                        Text(orderDateField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Jenis Order', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                        Text(isFeed ? 'Pakan' : 'OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                    ],
                                ),
                                if (isFeed) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Digabung?', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Text(isMerge.isTrue ? 'Ya' : 'Tidak', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    )
                                ],
                                if (isFeed && isMerge.isTrue) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Nama Kandang', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Text(orderCoopTargetLogisticField.controller.textEditingController.value.text, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    )
                                ],
                                if (isFeed) ...[
                                    const SizedBox(height: 16),
                                    Text('Total Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 12),
                                        child: Column(
                                            children: feedMultipleFormField.getController().listAdded.entries.map((entry) {
                                                return Padding(
                                                    padding: const EdgeInsets.only(top: 8),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Expanded(
                                                                child: Text(
                                                                    getFeedProductName(product: feedMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                    style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                )
                                                            ),
                                                            Text(
                                                                getFeedQuantity(product: feedMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                            )
                                                        ]
                                                    )
                                                );
                                            }).toList()
                                        ),
                                    )
                                ] else ...[
                                    if (isOwnFarm) ...[
                                        if (ovkVendorMultipleFormField.getController().listObjectAdded.isNotEmpty) ...[
                                            const SizedBox(height: 16),
                                            Text('Total OVK Vendor', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Padding(
                                                padding: const EdgeInsets.only(left: 12),
                                                child: Column(
                                                    children: ovkVendorMultipleFormField.getController().listAdded.entries.map((entry) {
                                                        return Padding(
                                                            padding: const EdgeInsets.only(top: 8),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Expanded(
                                                                        child: Text(
                                                                            getOvkProductName(product: ovkVendorMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                            style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                        )
                                                                    ),
                                                                    Text(
                                                                        getOvkQuantity(product: ovkVendorMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                        style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                    )
                                                                ]
                                                            )
                                                        );
                                                    }).toList()
                                                ),
                                            )
                                        ],
                                        if (ovkUnitMultipleFormField.getController().listObjectAdded.isNotEmpty) ...[
                                            const SizedBox(height: 16),
                                            Text('Total OVK Unit', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Padding(
                                                padding: const EdgeInsets.only(left: 12),
                                                child: Column(
                                                    children: ovkUnitMultipleFormField.getController().listAdded.entries.map((entry) {
                                                        return Padding(
                                                            padding: const EdgeInsets.only(top: 8),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Expanded(
                                                                        child: Text(
                                                                            getOvkProductName(product: ovkUnitMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                            style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                        )
                                                                    ),
                                                                    Text(
                                                                        getOvkQuantity(product: ovkUnitMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                        style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                    )
                                                                ]
                                                            )
                                                        );
                                                    }).toList()
                                                ),
                                            )
                                        ]
                                    ] else ...[
                                        const SizedBox(height: 16),
                                        Text('Total OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: Column(
                                                children: ovkMultipleFormField.getController().listAdded.entries.map((entry) {
                                                    return Padding(
                                                        padding: const EdgeInsets.only(top: 8),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        getOvkProductName(product: ovkMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                        style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                    )
                                                                ),
                                                                Text(
                                                                    getOvkQuantity(product: ovkMultipleFormField.getController().listObjectAdded[entry.key]),
                                                                    style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                                )
                                                            ]
                                                        )
                                                    );
                                                }).toList()
                                            ),
                                        )
                                    ]
                                ],
                                const SizedBox(height: 50),
                                SizedBox(
                                    width: MediaQuery.of(Get.context!).size.width - 32,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: ButtonFill(controller: GetXCreator.putButtonFillController("btnAgreeOrderRequest"), label: "Yakin", onClick: () {
                                                    Navigator.pop(Get.context!);
                                                    GlobalVar.track('Click_kirim_button_order');
                                                    isLoading.value = true;

                                                    AuthImpl().get().then((auth) {
                                                        if (auth != null) {
                                                            String requestedDate = '${Convert.getYear(orderDateField.getLastTimeSelected())}-${Convert.getMonthNumber(orderDateField.getLastTimeSelected())}-${Convert.getDay(orderDateField.getLastTimeSelected())}';
                                                            Procurement requestBody = Procurement(
                                                                type: isFeed ? "pakan" : "ovk",
                                                                coopId: coop.id,
                                                                farmingCycleId: coop.farmingCycleId,
                                                                requestSchedule: requestedDate
                                                            );

                                                            if (isFeed) {
                                                                requestBody.mergedLogistic = orderMultipleLogisticField.getController().textSelected.value == "Ya";
                                                                requestBody.mergedCoopId = orderMultipleLogisticField.getController().textSelected.value == "Ya" ? (orderCoopTargetLogisticField.getController().selectedObject as Coop).id : null;
                                                            }

                                                            if (isOwnFarm) {
                                                                if (ovkUnitMultipleFormField.getController().listObjectAdded.isNotEmpty) {
                                                                    Procurement internalRequest = Procurement(
                                                                        coopSourceId: "",
                                                                        coopTargetId: coop.id,
                                                                        branchSourceId: "",
                                                                        branchTargetId: "",
                                                                        subcategoryCode: "",
                                                                        subcategoryName: "",
                                                                        productName: "productName",
                                                                        quantity: 1.0,
                                                                        notes: "",
                                                                        logisticOption: "DisediakanProcurement",
                                                                        type: isFeed ? "pakan" : "ovk",
                                                                        details: ovkUnitMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>(),
                                                                        farmingCycleId: coop.farmingCycleId,
                                                                        datePlanned: requestedDate,
                                                                        photos: const []
                                                                    );

                                                                    requestBody.internalOvkTransferRequest = internalRequest;
                                                                }

                                                                requestBody.details = isFeed ? feedMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>() :
                                                                                      ovkVendorMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>();
                                                            } else {
                                                                requestBody.details = isFeed ? feedMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>() :
                                                                                      ovkMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>();
                                                            }

                                                            if (isEdit) {
                                                                _pushPurchaseRequestToServer(ListApi.updateOrderOrTransferRequest, [
                                                                    'Bearer ${auth.token}',
                                                                    auth.id,
                                                                    '${fromCoopRest ? "v2/purchase-requests/sapronak-doc-in/" : "v2/purchase-requests/"}${procurement.id}',
                                                                    Mapper.asJsonString(requestBody)
                                                                ]);
                                                            } else {
                                                                _pushPurchaseRequestToServer(fromCoopRest ? ListApi.saveOrderRequestForCoopRest : ListApi.saveOrderRequest, ['Bearer ${auth.token}', auth.id, Mapper.asJsonString(requestBody)]);
                                                            }
                                                        } else {
                                                            GlobalVar.invalidResponse();
                                                        }
                                                    });
                                                }),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                                child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnNotAgreeOrderRequest"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!))
                                            )
                                        ],
                                    ),
                                ),
                                const SizedBox(height: 32),
                            ]
                        )
                    )
                )
            )
        );
    }

    void _pushPurchaseRequestToServer(String route, List<dynamic> body) {
        Service.push(
            apiKey: 'productReportApi',
            service: route,
            context: Get.context!,
            body: body,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    isLoading.value = false;
                    GlobalVar.track('Open_success_order_page');
                    Get.off(TransactionSuccessActivity(
                        keyPage: "orderSaved",
                        message: "Kamu telah berhasil melakukan pengajuan permintaan sapronak",
                        showButtonHome: false,
                        onTapClose: () {
                            Get.back(result: true);
                            if (isEdit) {
                                Get.back(result: true);
                            }
                        },
                        onTapHome: () {}
                    ));
                },
                onResponseFail: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onResponseError: (exception, stacktrace, id, packet) {
                    isLoading.value = false;
                    Get.snackbar(
                        "Pesan",
                        "Terjadi Kesalahan, $exception",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                    );
                },
                onTokenInvalid: () => GlobalVar.invalidResponse()
            )
        );
    }

    void _getCoopTarget() {
        isLoading.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'coopApi',
                    service: 'getCoopTarget',
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, "v2/purchase-requests/target-coops/${coop.id}", ""],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            List<String> data = [];
                            for (var coop in body.data) {
                                data.add('${coop == null || coop.coopName == null ? '' : coop.coopName}');
                            }

                            orderCoopTargetLogisticField = SuggestField(
                                controller: GetXCreator.putSuggestFieldController<Coop>("orderCoopTargetLogisticField"),
                                childPrefix: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SvgPicture.asset('images/search_icon.svg'),
                                ),
                                label: "Nama Kandang",
                                hint: "Cari Kandang",
                                alertText: "Oops Nama kandang tidak ditemukan..!",
                                suggestList: data,
                                onTyping: (text) {},
                                onSubmitted: (text) {},
                            );
                            orderCoopTargetLogisticField.getController().setupObjects((body as CoopListResponse).data);

                            if (Get.arguments.length > 3) {
                                procurement = Get.arguments[3];
                                _initializeFillForm();
                            }
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) => isLoading.value = false,
                        onResponseError: (exception, stacktrace, id, packet) => isLoading.value = false,
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
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
                        body: ['Bearer ${auth.token}', auth.id, keyword, coop.branch?.id, "OVK", 1, 100],
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

    String getOvkUnitProductName({Product? product}) {
        if (product != null) {
            return product.productName ?? '';
        } else {
            if (ovkUnitSuggestField.getController().selectedObject == null) {
                return '';
            } else {
                return (ovkUnitSuggestField.getController().selectedObject as Product).productName ?? '';
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

    String getOvkUnitQuantity({Product? product}) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.purchaseUom ?? product.uom ?? ''}';
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