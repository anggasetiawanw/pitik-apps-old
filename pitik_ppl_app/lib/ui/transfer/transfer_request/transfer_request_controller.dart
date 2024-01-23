
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/media_field/media_field.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/procurement_model.dart';
import 'package:model/product_model.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:model/response/products_response.dart';
import 'package:model/response/stock_summary_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class TransferRequestController extends GetxController {
    BuildContext context;
    TransferRequestController({required this.context});

    late Coop coop;
    late bool isEdit = false;
    late Procurement procurement;
    late bool isOwnFarm = false;

    late DateTimeField transferDateField;
    late SpinnerField transferTypeField;
    late SpinnerField transferPurposeField;
    late SpinnerField transferCoopTargetField;
    late SpinnerField transferMethodField;
    late MediaField transferPhotoField;

    // for FEED
    late SpinnerField feedSpinnerField;
    late EditField feedQuantityField;
    late MultipleFormField<Product> feedMultipleFormField;

    // for OVK
    late SpinnerField ovkSpinnerField;
    late EditField ovkQuantityField;
    late MultipleFormField<Product> ovkMultipleFormField;

    RxList<MediaUploadModel?> transferPhotoList = <MediaUploadModel?>[].obs;

    var isFeed = true.obs;
    var isPurposeCoop = false.obs;
    var isLoading = false.obs;
    var isLoadingPicture = false.obs;
    var countLoading = 0.obs;

    // for stock summary
    var ovkStockSummary = "-".obs;
    var prestarterStockSummary = "-".obs;
    var starterStockSummary = "-".obs;
    var finisherStockSummary = "-".obs;

    RxList<Product?> feedStockSummaryList = <Product?>[].obs;
    RxList<Product?> ovkStockSummaryList = <Product?>[].obs;

    @override
    void onInit() {
        super.onInit();
        isLoading.value = true;
        coop = Get.arguments[0];
        isEdit = Get.arguments[1];
        isOwnFarm = coop.isOwnFarm != null && coop.isOwnFarm!;

        transferDateField = DateTimeField(controller: GetXCreator.putDateTimeFieldController("transferDateField"), label: "Tanggal Pengiriman", hint: "20/02/2022", alertText: "Tanggal Pengiriman harus diisi..!", flag: DateTimeField.DATE_FLAG,
            onDateTimeSelected: (dateTime, dateField) => dateField.controller.setTextSelected('${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}')
        );

        transferTypeField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("transferTypeField"), label: "Jenis Transfer", hint: "Pilih salah satu", alertText: "", backgroundField: GlobalVar.primaryLight,
            items: coop.isOwnFarm == null || !coop.isOwnFarm! ? const {"Pakan": true} : const {"Pakan": true, "OVK": false},
            onSpinnerSelected: (text) => isFeed.value = transferTypeField.getController().selectedIndex != -1 && transferTypeField.getController().selectedIndex == 0
        );

        transferPurposeField = SpinnerField(controller: GetXCreator.putSpinnerFieldController("transferPurposeField"), label: "Tujuan Transfer", hint: "Pilih salah satu", alertText: "Harus dipilih..!", backgroundField: GlobalVar.primaryLight,
            items: const {"Kandang": false, "Unit": false},
            onSpinnerSelected: (text) => isPurposeCoop.value = transferPurposeField.getController().selectedIndex != -1 && transferPurposeField.getController().selectedIndex == 0
        );

        transferCoopTargetField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController<Coop>("transferCoopTargetField"),
            label: "Kandang Tujuan",
            hint: "Pilih kandang tujuan",
            alertText: "Oops Nama kandang tidak ditemukan..!",
            items: const {},
            backgroundField: GlobalVar.primaryLight,
            onSpinnerSelected: (text) {},
        );

        transferMethodField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController("transferMethodField"),
            label: "Metode Pemesanan",
            hint: "Pilih logistik",
            alertText: "Harus diisi..!",
            items: const {"Pribadi": false, "Disediakan Procurement": false},
            onSpinnerSelected: (text) {}
        );

        transferPhotoField = MediaField(controller: GetXCreator.putMediaFieldController("transferPhotoField"), label: "Upload foto Sapronak", hideLabel: true, hint: "Upload foto Sapronak", alertText: "Harus diisi..!", type: MediaField.PHOTO,
            onMediaResult: (file) => AuthImpl().get().then((auth) {
                if (auth != null) {
                    if (file != null) {
                        isLoadingPicture.value = true;
                        Service.push(
                            service: ListApi.uploadImage,
                            context: Get.context!,
                            body: ['Bearer ${auth.token}', auth.id, "transfer-request", file],
                            listener: ResponseListener(
                                onResponseDone: (code, message, body, id, packet) {
                                    transferPhotoList.add(body.data);
                                    transferPhotoField.getController().setInformasiText("File telah terupload");
                                    transferPhotoField.getController().showInformation();
                                    isLoadingPicture.value = false;
                                },
                                onResponseFail: (code, message, body, id, packet) {
                                    Get.snackbar(
                                        "Pesan",
                                        "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                        snackPosition: SnackPosition.TOP,
                                        duration: const Duration(seconds: 5),
                                        colorText: Colors.white,
                                        backgroundColor: Colors.red
                                    );

                                    isLoadingPicture.value = false;
                                },
                                onResponseError: (exception, stacktrace, id, packet) {
                                    Get.snackbar(
                                        "Pesan",
                                        "Terjadi kesalahan internal",
                                        snackPosition: SnackPosition.TOP,
                                        duration: const Duration(seconds: 5),
                                        colorText: Colors.white,
                                        backgroundColor: Colors.red
                                    );

                                    isLoadingPicture.value = false;
                                },
                                onTokenInvalid: () => GlobalVar.invalidResponse()
                            )
                        );
                    }
                } else {
                    GlobalVar.invalidResponse();
                }
            })
        );

        // SETUP FEED WIDGET
        feedSpinnerField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController<Product>("transferFeedSpinnerField"),
            label: "Merek Pakan",
            hint: "Pilih merek pakan",
            alertText: "Merek Pakan masih kosong..!",
            items: const {},
            onSpinnerSelected: (text) => feedQuantityField.getController().changeTextUnit(_getLatestFeedTextUnit())
        );

        feedQuantityField = EditField(controller: GetXCreator.putEditFieldController("transferFeedQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        feedMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("transferMultipleFeed"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah Pakan',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getFeedProductName(), getFeedQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getFeedProductName(), getFeedQuantity(product: product)),
            selectedObject: () => getFeedSelectedObject(),
            selectedObjectWhenIncreased: (product) => getFeedSelectedObjectWhenIncreased(product),
            keyData: () => getFeedProductName(),
            onAfterAdded: () {
                feedSpinnerField.controller.reset();
                feedQuantityField.setInput('');
            },
            validationAdded: () {
                bool isPass = true;
                if (feedSpinnerField.getController().selectedIndex == -1) {
                    feedSpinnerField.getController().showAlert();
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
                    feedSpinnerField,
                    feedQuantityField
                ]
            )
        );

        // SETUP OVK WIDGET
        ovkSpinnerField = SpinnerField(
            controller: GetXCreator.putSpinnerFieldController<Product>("transferOvkSpinnerField"),
            label: "Jenis OVK",
            hint: "Pilih merek OVK",
            alertText: "Jenis OVK masih kosong..!",
            items: const {},
            onSpinnerSelected: (text) => ovkQuantityField.getController().changeTextUnit(_getLatestOvkTextUnit()),
        );

        ovkQuantityField = EditField(controller: GetXCreator.putEditFieldController("transferOvkQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        ovkMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("transferMultipleOvk"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product: product)),
            selectedObject: () => getOvkSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkSelectedObjectWhenIncreased(product),
            keyData: () => getOvkProductName(),
            onAfterAdded: () {
                ovkSpinnerField.controller.reset();
                ovkQuantityField.setInput('');
            },
            validationAdded: () {
                bool isPass = true;
                if (ovkSpinnerField.getController().selectedIndex == -1) {
                    ovkSpinnerField.getController().showAlert();
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
                    ovkSpinnerField,
                    ovkQuantityField
                ]
            )
        );

        _getFeedStockSummary();
        _getOvkStockSummary();
        _getCoopTarget();
        _getFeedBrand();
        _getOvkBrand();
    }

    void _initializeFillForm() {
        // fill delivery date
        DateTime dateTime = Convert.getDatetime(procurement.deliveryDate!);
        transferDateField.getController().setTextSelected('${Convert.getDay(dateTime)}/${Convert.getMonthNumber(dateTime)}/${Convert.getYear(dateTime)}');

        // fill transfer type
        transferTypeField.getController().setSelected(procurement.type == 'pakan' ? 'Pakan' : 'OVK');
        transferTypeField.getController().disable();
        isFeed.value = procurement.type == 'pakan';

        // fill photo sapronak
        transferPhotoList.value = procurement.photos;
        if (transferPhotoList.isNotEmpty) {
            transferPhotoField.getController().setInformasiText("File telah terupload");
            transferPhotoField.getController().showInformation();
            transferPhotoField.getController().setFileName(transferPhotoList[0]!.id!);
        }

        // fill method order
        transferMethodField.getController().setSelected(procurement.logisticOption == null ? '' : procurement.logisticOption == "DisediakanProcurement" ? "Disediakan Procurement" : procurement.logisticOption!);

        // fill list transfer product
        if (isFeed.value) {
            transferCoopTargetField.getController().setSelected(procurement.coopTargetName ?? '');

            // fill list product
            for (var product in procurement.details) {
                feedMultipleFormField.getController().addData(
                    child: _createChildAdded(getFeedProductName(product: product), getFeedQuantity(product: product)),
                    object: product,
                    key: getFeedProductName(product: product)
                );
            }
        } else {
            transferPurposeField.getController().setSelected(procurement.route == null ? '' : procurement.route == "COOP-TO-COOP" ? "Kandang" : "Unit");
            transferCoopTargetField.getController().setSelected(procurement.coopTargetName ?? '');

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
        if (feedSpinnerField.getController().selectedObject == null) {
            return '';
        } else {
            if ((feedSpinnerField.getController().selectedObject as Product).uom != null) {
                return (feedSpinnerField.getController().selectedObject as Product).uom!;
            } else if ((feedSpinnerField.getController().selectedObject as Product).purchaseUom != null) {
                return (feedSpinnerField.getController().selectedObject as Product).purchaseUom!;
            } else {
                return '';
            }
        }
    }

    String _getLatestOvkTextUnit() {
        if (ovkSpinnerField.getController().selectedObject == null) {
            return '';
        } else {
            if ((ovkSpinnerField.getController().selectedObject as Product).uom != null) {
                return (ovkSpinnerField.getController().selectedObject as Product).uom!;
            } else if ((ovkSpinnerField.getController().selectedObject as Product).purchaseUom != null) {
                return (ovkSpinnerField.getController().selectedObject as Product).purchaseUom!;
            } else {
                return '';
            }
        }
    }

    bool _validation() {
        bool isPass = true;
        if (transferDateField.getController().textSelected.isEmpty) {
            transferDateField.getController().showAlert();
            isPass  = false;
        }
        if (transferTypeField.getController().selectedIndex == -1) {
            transferTypeField.getController().showAlert();
            isPass = false;
        }
        if (transferMethodField.getController().selectedIndex == -1) {
            transferMethodField.getController().showAlert();
            isPass = false;
        }
        if (transferPhotoList.isEmpty) {
            transferPhotoField.getController().showAlert();
            isPass = false;
        }

        if (isFeed.isTrue) {
            if (transferCoopTargetField.getController().selectedIndex == -1) {
                transferCoopTargetField.getController().showAlert();
                isPass = false;
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
        } else {
            if (transferPurposeField.getController().selectedIndex == -1) {
                transferPurposeField.getController().showAlert();
                isPass = false;
            }
            if (isPurposeCoop.isTrue && transferCoopTargetField.getController().selectedIndex == -1) {
                transferCoopTargetField.getController().showAlert();
                isPass = false;
            }
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

    void sendTransfer() {
        if (_validation()) {
            _showFeedSummary(isFeed: isFeed.value);
        }
    }

    void showStockSummary() {
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
                                const SizedBox(height: 32),
                                Expandable(
                                    controller: GetXCreator.putAccordionController("accordionFeedStockSummary"),
                                    headerText: 'Pakan',
                                    child: Column(
                                        children: List.generate(feedStockSummaryList.length + 1, (index) {
                                            if (index == 0) {
                                                return Column(
                                                    children: [
                                                        Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('Merek Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                                                Text('Stok', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold))
                                                            ],
                                                        ),
                                                        const SizedBox(height: 8)
                                                    ],
                                                );
                                            } else {
                                                return Column(
                                                    children: [
                                                        Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text(getFeedProductName(product: feedStockSummaryList[index - 1]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                                Text(feedStockSummaryList[index - 1] == null ? '-' : _getRemainingQuantity(feedStockSummaryList[index - 1]!), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                                            ],
                                                        ),
                                                        const SizedBox(height: 4)
                                                    ],
                                                );
                                            }
                                        }),
                                    )
                                ),
                                const SizedBox(height: 16),
                                Expandable(
                                    expanded: true,
                                    controller: GetXCreator.putAccordionController("accordionOvkStockSummary"),
                                    headerText: 'OVK',
                                    child: Column(
                                        children: List.generate(ovkStockSummaryList.length + 1, (index) {
                                            if (index == 0) {
                                                return Column(
                                                    children: [
                                                        Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text('Merek OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                                                Text('Stok', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold))
                                                            ]
                                                        ),
                                                        const SizedBox(height: 8)
                                                    ]
                                                );
                                            } else {
                                                return Column(
                                                    children: [
                                                        Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                                Text(getOvkProductName(product: ovkStockSummaryList[index - 1]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                                Text(ovkStockSummaryList[index - 1] == null ? '-' : _getRemainingQuantity(ovkStockSummaryList[index - 1]!), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                                            ],
                                                        ),
                                                        const SizedBox(height: 4)
                                                    ],
                                                );
                                            }
                                        }),
                                    )
                                ),
                                const SizedBox(height: 32),
                            ]
                        )
                    )
                )
            )
        );
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
                                        Text('Tanggal Pengiriman', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                        Text(transferDateField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Jenis Transfer', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                        Text(isFeed ? 'Pakan' : 'OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                    ],
                                ),
                                if (isFeed) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Kandang Tujuan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Text(transferCoopTargetField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Metode Pemesanan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Text(transferMethodField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    ),
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
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Tujuan Transfer', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Text(isPurposeCoop.isTrue ? 'Kandang' : 'Unit', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    ),
                                    isPurposeCoop.isTrue ? Column(
                                        children: [
                                            const SizedBox(height: 8),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text('Kandang Tujuan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                    Text(transferCoopTargetField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                                ],
                                            )
                                        ],
                                    ) : const SizedBox(),
                                    const SizedBox(height: 8),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text('Metode Pemesanan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            Text(transferMethodField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                        ],
                                    ),
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
                                ],
                                const SizedBox(height: 50),
                                SizedBox(
                                    width: MediaQuery.of(Get.context!).size.width - 32,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: ButtonFill(controller: GetXCreator.putButtonFillController("btnAgreeTransferRequest"), label: "Yakin", onClick: () {
                                                    Navigator.pop(Get.context!);
                                                    isLoading.value = true;
                                                    AuthImpl().get().then((auth) {
                                                        if (auth != null) {
                                                            String requestedDate = '${Convert.getYear(transferDateField.getLastTimeSelected())}-${Convert.getMonthNumber(transferDateField.getLastTimeSelected())}-${Convert.getDay(transferDateField.getLastTimeSelected())}';
                                                            String? coopId = isFeed || transferPurposeField.getController().selectedIndex == 0 ? (transferCoopTargetField.getController().getSelectedObject() as Coop).id! : null;
                                                            String route = "COOP-TO-COOP";
                                                            if (coop.isOwnFarm != null && coop.isOwnFarm! && transferPurposeField.getController().textSelected.value == "Unit") {
                                                                route = "COOP-TO-BRANCH";
                                                            }

                                                            Procurement requestBody = Procurement(
                                                                coopSourceId: coop.id,
                                                                coopTargetId: coopId,
                                                                farmingCycleId: coop.farmingCycleId,
                                                                datePlanned: requestedDate,
                                                                logisticOption: transferMethodField.getController().textSelected.value.replaceAll(" ", ""),
                                                                notes: "",
                                                                route: route,
                                                                photos: transferPhotoList,
                                                                type: isFeed ? "pakan" : "ovk",
                                                                details: isFeed ? feedMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>() :
                                                                         ovkMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>(),
                                                                subcategoryCode: "",
                                                                subcategoryName: "",
                                                                quantity: 1,
                                                                uom: "",
                                                                productName: ""
                                                            );

                                                            if (isEdit) {
                                                                _pushTransferRequestToServer(ListApi.updateOrderOrTransferRequest, [
                                                                    'Bearer ${auth.token}',
                                                                    auth.id,
                                                                    'v2/transfer-requests/${procurement.id}',
                                                                    Mapper.asJsonString(requestBody)
                                                                ]);
                                                            } else {
                                                                _pushTransferRequestToServer(ListApi.saveTransferRequest, ['Bearer ${auth.token}', auth.id, Mapper.asJsonString(requestBody)]);
                                                            }
                                                        } else {
                                                            GlobalVar.invalidResponse();
                                                        }
                                                    });
                                                })
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                                child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnNotAgreeTransferRequest"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!))
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

    void _pushTransferRequestToServer(String route, List<dynamic> body) {
        Service.push(
            apiKey: 'productReportApi',
            service: route,
            context: Get.context!,
            body: body,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    isLoading.value = false;
                    Get.off(TransactionSuccessActivity(
                        keyPage: "transferSaved",
                        message: "Kamu telah berhasil melakukan permintaan transfer pakan ke kandang lain",
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
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: 'coopApi',
                    service: 'getCoopTarget',
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, "v2/transfer-requests/target-coops/${coop.id}", null],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            transferCoopTargetField.getController().setupObjects(body.data);
                            for (var element in (body as CoopListResponse).data) {
                                if (element != null && element.coopName != null) {
                                    transferCoopTargetField.getController().addItems(value: element.coopName!, isActive: false);
                                }
                            }

                            if (Get.arguments.length > 2) {
                                procurement = Get.arguments[2];
                                _initializeFillForm();
                            }

                            _checkCountLoading();
                        },
                        onResponseFail: (code, message, body, id, packet) => _checkCountLoading(),
                        onResponseError: (exception, stacktrace, id, packet) => _checkCountLoading(),
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void _checkCountLoading() {
        countLoading.value++;
        if (countLoading.value == 3) {
            isLoading.value = false;
            countLoading.value = 0;
        }
    }

    void _getFeedBrand() => AuthImpl().get().then((auth) => {
        if (auth != null) {
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getStocks,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathFeedStocks(coop.farmingCycleId!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as ProductsResponse).data.isNotEmpty) {
                            feedStockSummaryList.value = body.data;
                        }

                        _setupSpinnerBrand(field: feedSpinnerField, productList: body.data);
                        _checkCountLoading();
                    },
                    onResponseFail: (code, message, body, id, packet) => _checkCountLoading(),
                    onResponseError: (exception, stacktrace, id, packet) => _checkCountLoading(),
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            )
        } else {
            GlobalVar.invalidResponse()
        }
    });

    void _getOvkBrand() => AuthImpl().get().then((auth) => {
        if (auth != null) {
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getStocks,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathOvkStocks(coop.farmingCycleId!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as ProductsResponse).data.isNotEmpty) {
                            feedStockSummaryList.value = body.data;
                        }

                        _setupSpinnerBrand(field: ovkSpinnerField, productList: body.data, isFeed: false);
                        _checkCountLoading();
                    },
                    onResponseFail: (code, message, body, id, packet) => _checkCountLoading(),
                    onResponseError: (exception, stacktrace, id, packet) => _checkCountLoading(),
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            )
        } else {
            GlobalVar.invalidResponse()
        }
    });

    String _getRemainingQuantity(Product product) => '${product.remainingQuantity == null ? '-' : product.remainingQuantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? 'Karung'}';
    void _getFeedStockSummary() => AuthImpl().get().then((auth) => {
        if (auth != null) {
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
                                    if (product.subcategoryCode != null && product.subcategoryCode == "PRESTARTER") {
                                        prestarterStockSummary.value = _getRemainingQuantity(product);
                                    } else if (product.subcategoryCode != null && product.subcategoryCode == "STARTER") {
                                        starterStockSummary.value = _getRemainingQuantity(product);
                                    } else if (product.subcategoryCode != null && product.subcategoryCode == "FINISHER") {
                                        finisherStockSummary.value = _getRemainingQuantity(product);
                                    }
                                }
                            }
                        }
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

    void _getOvkStockSummary() => AuthImpl().get().then((auth) => {
        if (auth != null) {
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getStocksSummary,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathOvkSummaryStocks(coop.farmingCycleId!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        double ovkStock = 0;
                        String uom = '';

                        if ((body as StockSummaryResponse).data != null && body.data!.summaries.isNotEmpty) {
                            ovkStockSummaryList.value = body.data!.summaries;

                            for (var product in body.data!.summaries) {
                                ovkStock += product == null ? 0.0 : product.remainingQuantity ?? 0.0;
                                uom = product == null ? 'Botol' : product.uom ?? product.purchaseUom ?? 'Botol';
                            }

                            ovkStockSummary.value = '${ovkStock.toStringAsFixed(0)} $uom';
                        }
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

    void _setupSpinnerBrand({required SpinnerField field, required List<Product?> productList, bool isFeed = true}) {
        field.getController().setupObjects(productList);
        for (var product in productList) {
            String key = isFeed ?
                         '${product == null || product.subcategoryCode == null ? '' : product.subcategoryCode} - ${product == null || product.productName == null ? '' : product.productName}' :
                         '${product == null || product.productName == null ? '' : product.productName}';

            field.getController().addItems(value: key, isActive: false);
        }
    }

    Product getFeedSelectedObject() {
        if (feedSpinnerField.getController().getSelectedObject() != null) {
            Product product = feedSpinnerField.getController().getSelectedObject();
            product.quantity = feedQuantityField.getInputNumber() ?? 0;
            product.categoryCode = 'PAKAN';
            product.categoryName = 'PAKAN';

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkSelectedObject() {
        if (ovkSpinnerField.getController().getSelectedObject() != null) {
            Product product = ovkSpinnerField.getController().getSelectedObject();
            product.quantity = ovkQuantityField.getInputNumber() ?? 0;
            product.categoryCode = 'OVK';
            product.categoryName = 'OVK';

            return product;
        } else {
            return Product();
        }
    }

    Product getFeedSelectedObjectWhenIncreased(Product oldProduct) {
        if (feedSpinnerField.getController().getSelectedObject() != null) {
            Product product = feedSpinnerField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (feedQuantityField.getInputNumber() ?? 0);
            product.categoryCode = 'PAKAN';
            product.categoryName = 'PAKAN';

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkSelectedObjectWhenIncreased(Product oldProduct) {
        if (ovkSpinnerField.getController().getSelectedObject() != null) {
            Product product = ovkSpinnerField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (ovkQuantityField.getInputNumber() ?? 0);
            product.categoryCode = 'OVK';
            product.categoryName = 'OVK';

            return product;
        } else {
            return Product();
        }
    }

    String getFeedProductName({Product? product}) {
        if (product != null) {
            return '${product.subcategoryCode ?? ''} - ${product.productName ?? ''}';
        } else {
            if (feedSpinnerField.getController().selectedObject == null) {
                return '';
            } else {
                return '${(feedSpinnerField.getController().selectedObject as Product).subcategoryCode ?? ''} - ${(feedSpinnerField.getController().selectedObject as Product).productName ?? ''}';
            }
        }
    }

    String getOvkProductName({Product? product}) {
        if (product != null) {
            return product.productName ?? '';
        } else {
            if (ovkSpinnerField.getController().selectedObject == null) {
                return '';
            } else {
                return (ovkSpinnerField.getController().selectedObject as Product).productName ?? '';
            }
        }
    }

    String getFeedQuantity({Product? product}) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}';
        } else {
            return '${feedQuantityField.getInputNumber() == null ? '' : feedQuantityField.getInputNumber()!.toStringAsFixed(0)} ${feedQuantityField.getController().textUnit.value}';
        }
    }

    String getOvkQuantity({Product? product}) {
        if (product != null) {
            return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}';
        } else {
            return '${ovkQuantityField.getInputNumber() == null ? '' : ovkQuantityField.getInputNumber()!.toStringAsFixed(0)} ${ovkQuantityField.getController().textUnit.value}';
        }
    }
}

class TransferRequestBinding extends Bindings {
    BuildContext context;
    TransferRequestBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<TransferRequestController>(() => TransferRequestController(context: context));
    }
}