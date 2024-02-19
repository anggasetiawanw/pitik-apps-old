
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/media_field/media_field.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:components/suggest_field/suggest_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/mortality_reason_model.dart';
import 'package:model/product_model.dart';
import 'package:model/report.dart';
import 'package:model/response/internal_app/media_upload_response.dart';
import 'package:model/response/products_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/01/2024

class LayerDailyReportFormController extends GetxController {
    BuildContext context;
    LayerDailyReportFormController({required this.context});

    late Coop coop;
    late Report report;
    late ButtonFill bfNext;
    late ButtonFill bfSubmit;

    late RxList<Container> barList = <Container>[].obs;
    late RxList<SvgPicture> pointList = <SvgPicture>[].obs;
    late RxList<Text> textPointLabelList = <Text>[].obs;

    var isLoading = false.obs;
    var isLoadingChickDead = false.obs;
    var isLoadingRecodingCard = false.obs;
    var isSubmitButton = false.obs;
    var state = 0.obs;
    var isFeed = true.obs;
    var totalCount = 0.obs;
    var totalWeightCount = 0.0.obs;

    // for Chicken Production
    EditField efWeight = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormWeight"), label: "Bobot", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "gr", maxInput: 100, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );

    EditField efCulled = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormCulled"), label: "Afkir", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Ekor", maxInput: 100, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );

    SpinnerField spReason = SpinnerField(controller: GetXCreator.putSpinnerFieldController("layerDailyFormReason"), label: "Alasan", hint: "Pilih alasan", alertText: "Harus dipilih..!",
        items: const {'Heat stress': false, 'Terjepit' : false, 'IBD Pinguin': false, 'Kekurangan oksigen': false, 'Snot': false, 'Kanibal': false, 'Prolapsus': false, 'CRD': false, 'Lainnya': false},
        onSpinnerSelected: (text) {}
    );

    EditField efDead = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormDead"), label: "Kematian", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Ekor", maxInput: 100, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );

    late MediaField mfChickDead;
    RxList<MediaUploadModel?> chickDeadPhotoList = <MediaUploadModel?>[].obs;
    late MultipleFormField<MortalityReason> reasonMultipleFormField;

    // for Sapronak
    // for FEED
    late SuggestField feedSuggestField;
    EditField feedQuantityField = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormFeedQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );
    late MultipleFormField<Product> feedMultipleFormField;

    // for OVK
    late SuggestField ovkSuggestField;
    EditField ovkQuantityField = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormOvkQuantity"), label: "Total", hint: "Ketik di sini", alertText: "Total belum diisi..!", textUnit: "", maxInput: 20, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );
    SpinnerField spOvkReason = SpinnerField(controller: GetXCreator.putSpinnerFieldController("layerDailyFormOvkReason"), label: "Alasan", hint: "Pilih salah satu", alertText: "Harus dipilih..!",
        items: const {'Re-Vaccination': false, 'Pemberian Vitamin' : false, 'Pencagahan Penyakit': false},
        onSpinnerSelected: (text) {}
    );
    late MultipleFormField<Product> ovkMultipleFormField;

    // for Egg Production
    late EditField efUtuhCoklat;
    late EditField efUtuhCoklatTotal;
    late EditField efUtuhKrem;
    late EditField efUtuhKremTotal;
    late EditField efRetak;
    late EditField efRetakTotal;
    late EditField efPecah;
    late EditField efPecahTotal;
    late EditField efKotor;
    late EditField efKotorTotal;
    late EditField efEggDisposal;

    SpinnerField spAbnormalEgg = SpinnerField(controller: GetXCreator.putSpinnerFieldController("layerDailyFormAbnormalEgg"), label: "Ada Telur Abnormal?", hint: "Pilih salah satu", alertText: "Harus dipilih..!",
        items: const {'Ya': false, 'Tidak' : false},
        onSpinnerSelected: (text) {}
    );

    EditField efTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormTotal"), label: "Total", hint: "Auto", alertText: "Harus diisi..!", textUnit: "Butir", maxInput: 100, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );

    EditField efBeratTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormBeratTotal"), label: "Berat Total", hint: "Auto", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
        onTyping: (text, field) {}
    );

    EditAreaField eaDesc = EditAreaField(controller: GetXCreator.putEditAreaFieldController("layerDailyFormDesc"), label: "Keterangan", hint: "Tulis keterangan", alertText: "Harus diisi..!", maxInput: 300, onTyping: (text, field) {});

    late MediaField mfRecordingCard;
    RxList<MediaUploadModel?> recordingCardPhotoList = <MediaUploadModel?>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        report = Get.arguments[1];

        bfNext = ButtonFill(controller: GetXCreator.putButtonFillController("btnLayerDailyFormNext"), label: "Selanjutnya", onClick: () => nextPage());
        bfSubmit = ButtonFill(controller: GetXCreator.putButtonFillController("btnLayerDailyFormSubmit"), label: "Simpan", onClick: () => saveDailyReport());

        efTotal.controller.disable();
        efBeratTotal.controller.disable();

        mfChickDead = MediaField(controller: GetXCreator.putMediaFieldController("layerDailyFormChickDead"), label: "Upload foto kematian", hideLabel: true, hint: "Upload foto kematian", alertText: "Harus diisi..!", type: MediaField.PHOTO,
            onMediaResult: (file) => AuthImpl().get().then((auth) {
                if (auth != null) {
                    if (file != null) {
                        isLoadingChickDead.value = true;
                        Service.push(
                            service: ListApi.uploadImage,
                            context: Get.context!,
                            body: ['Bearer ${auth.token}', auth.id, "transfer-request", file],
                            listener: ResponseListener(
                                onResponseDone: (code, message, body, id, packet) {
                                    if ((body as MediaUploadResponse).data != null) {
                                        body.data!.url = Uri.encodeFull(body.data!.url!);
                                    }

                                    chickDeadPhotoList.clear();
                                    chickDeadPhotoList.add(body.data);
                                    mfChickDead.getController().setInformasiText("File telah terupload");
                                    mfChickDead.getController().showInformation();
                                    isLoadingChickDead.value = false;
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

                                    isLoadingChickDead.value = false;
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

                                    isLoadingChickDead.value = false;
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

        mfRecordingCard = MediaField(controller: GetXCreator.putMediaFieldController("layerDailyFormRecordingCard"), label: "Upload Kartu Recording", hideLabel: true, hint: "Upload Kartu Recording", alertText: "Harus diisi..!", type: MediaField.PHOTO,
            onMediaResult: (file) => AuthImpl().get().then((auth) {
                if (auth != null) {
                    if (file != null) {
                        isLoadingRecodingCard.value = true;
                        Service.push(
                            service: ListApi.uploadImage,
                            context: Get.context!,
                            body: ['Bearer ${auth.token}', auth.id, "transfer-request", file],
                            listener: ResponseListener(
                                onResponseDone: (code, message, body, id, packet) {
                                    if ((body as MediaUploadResponse).data != null) {
                                        body.data!.url = Uri.encodeFull(body.data!.url!);
                                    }

                                    recordingCardPhotoList.clear();
                                    recordingCardPhotoList.add(body.data);
                                    mfRecordingCard.getController().setInformasiText("File telah terupload");
                                    mfRecordingCard.getController().showInformation();
                                    isLoadingRecodingCard.value = false;
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

                                    isLoadingRecodingCard.value = false;
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

                                    isLoadingRecodingCard.value = false;
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

        reasonMultipleFormField = MultipleFormField<MortalityReason>(
            controller: GetXCreator.putMultipleFormFieldController<MortalityReason>("layerDailyFormMultipleReason"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah Catatan Kematian',
            initInstance: const {},
            childAdded: () => _createChildAdded(getReason(), getQuantityReason(data: null)),
            increaseWhenDuplicate: (deadReason) => _createChildAdded(getReason(), getQuantityReason(data: deadReason)),
            selectedObject: () => getReasonSelectedObject(),
            selectedObjectWhenIncreased: (deadReason) => getReasonSelectedObjectWhenIncreased(deadReason),
            keyData: () => getReason(),
            onAfterAdded: () {
                spReason.controller.reset();
                efDead.setInput('');
            },
            validationAdded: () {
                bool isPass = true;
                if (efDead.getInputNumber() == null) {
                    efDead.getController().showAlert();
                    isPass = false;
                }

                return isPass;
            },
            child: Column(
                children: [
                    spReason,
                    efDead
                ]
            )
        );

        // SETUP FEED WIDGET
        feedSuggestField = SuggestField(
            controller: GetXCreator.putSuggestFieldController<Product>("layerDailyFormFeedBrand"),
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

        feedMultipleFormField = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("layerDailyFormMultipleFeed"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah Pakan',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getFeedProductName(), getFeedQuantity(product: null)),
            increaseWhenDuplicate: (product) => _createChildAdded(getFeedProductName(), getFeedQuantity(product: product)),
            selectedObject: () => getFeedSelectedObject(),
            selectedObjectWhenIncreased: (product) => getFeedSelectedObjectWhenIncreased(product),
            keyData: () => getFeedProductName(),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
            ),
            onAfterAdded: () {
                feedSuggestField.controller.reset();
                feedQuantityField.setInput('');
            },
            validationAdded: () {
                bool isPass = true;
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
                    feedSuggestField,
                    feedQuantityField
                ]
            )
        );

        // SETUP OVK WIDGET
        ovkSuggestField = SuggestField(
            controller: GetXCreator.putSuggestFieldController<Product>("layerDailyFormOvkBrand"),
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
            controller: GetXCreator.putMultipleFormFieldController<Product>("layerDailyFormMultipleOvk"),
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            labelButtonAdd: 'Tambah OVK',
            initInstance: Product(),
            childAdded: () => _createChildAdded(getOvkProductName(), getOvkQuantity(product: null), reason: spOvkReason.controller.textSelected.value),
            increaseWhenDuplicate: (product) => _createChildAdded(getOvkProductName(), getOvkQuantity(product: product), reason: spOvkReason.controller.textSelected.value),
            selectedObject: () => getOvkSelectedObject(),
            selectedObjectWhenIncreased: (product) => getOvkSelectedObjectWhenIncreased(product),
            keyData: () => getOvkProductName(),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
            ),
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
                if (spOvkReason.controller.selectedIndex == -1) {
                    spOvkReason.controller.showAlert();
                    isPass = false;
                }

                return isPass;
            },
            child: Column(
                children: [
                    ovkSuggestField,
                    ovkQuantityField,
                    spOvkReason
                ]
            )
        );

        // Initialize for Egg Production
        efUtuhCoklat = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormUtuhCoklat"), label: "Utuh Coklat", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Butir", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) =>  countTotal()
        );

        efUtuhCoklatTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormUtuhCoklatTotal"), label: "Total", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotalWeight()
        );

        efUtuhKrem = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormUtuhKrem"), label: "Utuh Krem", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Butir", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotal()
        );

        efUtuhKremTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormUtuhKremTotal"), label: "Total", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotalWeight()
        );

        efRetak = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormRetak"), label: "Retak", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Butir", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotal()
        );

        efRetakTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormRetakTotal"), label: "Total", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotalWeight()
        );

        efPecah = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormPecah"), label: "Pecah", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Butir", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotal()
        );

        efPecahTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormPecahTotal"), label: "Total", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotalWeight()
        );

        efKotor = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormKotor"), label: "Kotor", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "Butir", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotal()
        );

        efKotorTotal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormKotorTotal"), label: "Total", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) => countTotalWeight()
        );

        efEggDisposal = EditField(controller: GetXCreator.putEditFieldController("layerDailyFormEggDisposal"), label: "Pemusnahan", hint: "Ketik di sini", alertText: "Harus diisi..!", textUnit: "kg", maxInput: 100, inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        _toChickenProduction();
    }

    @override
    void onReady() {
        super.onReady();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            spAbnormalEgg.controller.generateItems({'Ya': false, 'Tidak' : false});
            _fillData();
        });
    }

    void _dismissSuggest() {
        feedSuggestField.controller.dissmisDialog();
        ovkSuggestField.controller.dissmisDialog();
    }

    void toFeedConsumption() {
        _dismissSuggest();
        feedSuggestField.controller.reset(useDelayed: true);
        isFeed.value = true;
    }

    void toOvkConsumption() {
        _dismissSuggest();
        ovkSuggestField.controller.reset(useDelayed: true);
        isFeed.value = false;
    }

    void _fillData() {
        efWeight.setInput('${report.averageWeight ?? ''}');
        efCulled.setInput('${report.culling ?? ''}');

        // fill photo mortality
        if (report.mortalityImage != null && report.mortalityImage!.isNotEmpty) {
            chickDeadPhotoList.add(MediaUploadModel(
                url: report.mortalityImage
            ));
            if (chickDeadPhotoList.isNotEmpty) {
                mfChickDead.getController().setInformasiText("File telah terupload");
                mfChickDead.getController().showInformation();
                mfChickDead.getController().setFileName(chickDeadPhotoList[0]!.url ?? '-');
            }
        }

        // fill list reason
        for (var reason in report.mortalityList) {
            reasonMultipleFormField.controller.addData(
                child: _createChildAdded(getReason(data: reason), getQuantityReason(data: reason)),
                object: reason,
                key: getReason(data: reason)
            );
        }

        // fill list product feed
        if (report.feedConsumptions != null) {
            for (var product in report.feedConsumptions!) {
                feedMultipleFormField.getController().addData(
                    child: _createChildAdded(getFeedProductName(product: product), getFeedQuantity(product: product)),
                    object: product,
                    key: getFeedProductName(product: product)
                );
            }
        }

        // fill list product ovk
        if (report.ovkConsumptions != null) {
            for (var product in report.ovkConsumptions!) {
                ovkMultipleFormField.getController().addData(
                    child: _createChildAdded(getOvkProductName(product: product), getOvkQuantity(product: product), reason: product != null ? product.remarks ?? '' : ''),
                    object: product,
                    key: getOvkProductName(product: product)
                );
            }
        }

        // fill harvested egg
        for (var egg in report.harvestedEgg) {
            if (egg != null) {
                if (egg.productItem!.name == 'Telur Utuh Cokelat') {
                    efUtuhCoklat.setInput('${egg.quantity}');
                    efUtuhCoklatTotal.setInput('${egg.weight}');
                } else if (egg.productItem!.name == 'Telur Utuh Krem') {
                    efUtuhKrem.setInput('${egg.quantity}');
                    efUtuhKremTotal.setInput('${egg.weight}');
                } else if (egg.productItem!.name == 'Telur Retak') {
                    efRetak.setInput('${egg.quantity}');
                    efRetakTotal.setInput('${egg.weight}');
                } else if (egg.productItem!.name == 'Telur Pecah') {
                    efPecah.setInput('${egg.quantity}');
                    efPecahTotal.setInput('${egg.weight}');
                } else if (egg.productItem!.name == 'Telur Kotor') {
                    efKotor.setInput('${egg.quantity}');
                    efKotorTotal.setInput('${egg.weight}');
                }
            }
        }

        // fill photo recording card
        if (report.recordingImage != null && report.recordingImage!.isNotEmpty) {
            recordingCardPhotoList.add(MediaUploadModel(
                url: report.recordingImage
            ));
            if (recordingCardPhotoList.isNotEmpty) {
                mfRecordingCard.getController().setInformasiText("File telah terupload");
                mfRecordingCard.getController().showInformation();
                mfRecordingCard.getController().setFileName(recordingCardPhotoList[0]!.url ?? '-');
            }
        }

        efEggDisposal.setInput('${report.eggDisposal ?? ''}');
        spAbnormalEgg.controller.setSelected(report.isAbnormal != null && report.isAbnormal! ? 'Ya' : report.isAbnormal != null && !report.isAbnormal! ? 'Tidak' : '');
        eaDesc.setValue(report.remarks ?? '');
    }

    void _changeHarvestedEggData({required String productName, required EditField editField, required String producItemId, bool isQuantity = true}) {
        bool isContain = false;
        for (int i = 0; i < report.harvestedEgg.length; i++) {
            if (report.harvestedEgg[i]!.productItem!.name == productName) {
                if (isQuantity) {
                    report.harvestedEgg[i]!.quantity = editField.getInputNumber() == null ? null : editField.getInputNumber()!.toInt();
                } else {
                    report.harvestedEgg[i]!.weight = editField.getInputNumber();
                }

                report.harvestedEgg[i]!.productItemId = producItemId;
                isContain = true;
                break;
            }
        }

        if (!isContain) {
            report.harvestedEgg.add(
                Products(
                    quantity: isQuantity ? editField.getInputNumber() == null ? null : editField.getInputNumber()!.toInt() : 0,
                    weight: !isQuantity ? editField.getInputNumber() : 0.0,
                    productItemId: producItemId,
                    productItem: Products(
                        name: productName,
                        uom: 'Butir'
                    )
                )
            );
        }
    }

    void countTotal() {
        totalCount.value = 0;
        totalCount.value += efUtuhCoklat.getInputNumber() == null ? 0 : efUtuhCoklat.getInputNumber()!.toInt();
        totalCount.value += efUtuhKrem.getInputNumber() == null ? 0 : efUtuhKrem.getInputNumber()!.toInt();
        totalCount.value += efRetak.getInputNumber() == null ? 0 : efRetak.getInputNumber()!.toInt();
        totalCount.value += efPecah.getInputNumber() == null ? 0 : efPecah.getInputNumber()!.toInt();
        totalCount.value += efKotor.getInputNumber() == null ? 0 : efKotor.getInputNumber()!.toInt();

        efTotal.setInput(totalCount.value.toStringAsFixed(0));
    }

    void countTotalWeight() {
        totalWeightCount.value = 0;
        totalWeightCount.value += efUtuhCoklatTotal.getInputNumber() == null ? 0 : efUtuhCoklatTotal.getInputNumber()!.toDouble();
        totalWeightCount.value += efUtuhKremTotal.getInputNumber() == null ? 0 : efUtuhKremTotal.getInputNumber()!.toDouble();
        totalWeightCount.value += efRetakTotal.getInputNumber() == null ? 0 : efRetakTotal.getInputNumber()!.toDouble();
        totalWeightCount.value += efPecahTotal.getInputNumber() == null ? 0 : efPecahTotal.getInputNumber()!.toDouble();
        totalWeightCount.value += efKotorTotal.getInputNumber() == null ? 0 : efKotorTotal.getInputNumber()!.toDouble();

        efBeratTotal.setInput(totalWeightCount.value.toStringAsFixed(1));
    }

    Column _createChildAdded(String title, String quantity, {String reason = ''}) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Flexible(child: Text(title, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))),
                        const SizedBox(width: 16),
                        Text(quantity, style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))
                    ]
                ),
                reason.isNotEmpty ? Text('Alasan: $reason', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)) : const SizedBox()
            ]
        );
    }

    String getReason({MortalityReason? data}) {
        if (data != null) {
            return data.cause ?? '-';
        } else {
            if (spReason.controller.selectedIndex == -1) {
                return '';
            } else {
                return spReason.controller.textSelected.value;
            }
        }
    }

    String getQuantityReason({MortalityReason? data}) {
        if (data != null) {
            return data.quantity == null ? '- Ekor' : '${data.quantity!.toStringAsFixed(0)} Ekor';
        } else {
            return efDead.getInputNumber() == null ? '- Ekor' : '${efDead.getInputNumber()!.toStringAsFixed(0)} Ekor';
        }
    }

    MortalityReason getReasonSelectedObject() {
        if (efDead.getInputNumber() != null) {
            MortalityReason deadReason = MortalityReason(
                cause: spReason.controller.textSelected.value,
                quantity: efDead.getInputNumber() != null ? efDead.getInputNumber()!.toInt() : null
            );

            return deadReason;
        } else {
            return MortalityReason();
        }
    }

    MortalityReason getReasonSelectedObjectWhenIncreased(MortalityReason oldReason) {
        if (efDead.getInputNumber() != null) {
            MortalityReason deadReason = MortalityReason(
                cause: spReason.controller.textSelected.value,
                quantity: (oldReason.quantity ?? 0) + (efDead.getInputNumber() ?? 0).toInt()
            );

            return deadReason;
        } else {
            return MortalityReason();
        }
    }

    double _getBarWidth() => (MediaQuery.of(Get.context!).size.width - 80) / 2;

    void nextPage() {
        GlobalVar.track('Click_layer_daily_report_selanjutnya_button');
        if (state.value == 0) {
            bool isPass = true;
            if (efCulled.getInputNumber() == null) {
                efCulled.controller.showAlert();
                isPass = false;
            }
            if (reasonMultipleFormField.controller.listObjectAdded.isEmpty) {
                Get.snackbar(
                    "Pesan",
                    "Alasan kematian masih kosong, silahkan isi minimal satu..!",
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red
                );
                isPass = false;
            }

            if (isPass) {
                _toSapronak();
            }
        } else if (state.value == 1) {
            bool isPass = true;
            if (feedMultipleFormField.controller.listObjectAdded.isEmpty) {
                Get.snackbar(
                    "Pesan",
                    "Konsumsi Pakan masih kosong, silahkan isi minimal satu..!",
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.white,
                    backgroundColor: Colors.red
                );
                isPass = false;
            }

            if (isPass) {
                _toEggProduction();
            }
        }
    }

    void previousPage() {
        if (state.value == 2) {
            _toSapronak();
        } else if (state.value == 1) {
            _toChickenProduction();
        } else {
            Get.back();
        }
    }

    Row getLabelPoint() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Center(child: textPointLabelList[0]),
            Center(child: textPointLabelList[1]),
            Center(child: textPointLabelList[2])
        ]
    );

    void _toChickenProduction() {
        GlobalVar.track('Open_page_chicken_production');
        state.value = 0;
        isSubmitButton.value = false;

        barList.insert(0, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        barList.insert(1, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));

        pointList.insert(0, SvgPicture.asset('images/bar_point_active_orange.svg'));
        pointList.insert(1, SvgPicture.asset('images/bar_point_inactive.svg'));
        pointList.insert(2, SvgPicture.asset('images/bar_point_inactive.svg'));

        textPointLabelList.insert(0, Text("Produksi\nAyam", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
        textPointLabelList.insert(1, Text("Sapronak", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
        textPointLabelList.insert(2, Text("Produksi\nTelur", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
    }

    void _toSapronak() {
        GlobalVar.track('Open_page_sapronak');
        state.value = 1;
        isSubmitButton.value = false;

        barList.insert(0, Container(color: GlobalVar.primaryOrange, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        barList.insert(1, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));

        pointList.insert(0, SvgPicture.asset('images/bar_point_active_green.svg'));
        pointList.insert(1, SvgPicture.asset('images/bar_point_active_orange.svg'));
        pointList.insert(2, SvgPicture.asset('images/bar_point_inactive.svg'));

        textPointLabelList.insert(0, Text("Produksi\nAyam", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
        textPointLabelList.insert(1, Text("Sapronak", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
        textPointLabelList.insert(2, Text("Produksi\nTelur", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
    }

    void _toEggProduction() {
        state.value = 2;
        isSubmitButton.value = true;

        barList.insert(0, Container(color: GlobalVar.greenBackground, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        barList.insert(1, Container(color: GlobalVar.primaryOrange, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));

        pointList.insert(0, SvgPicture.asset('images/bar_point_active_green.svg'));
        pointList.insert(1, SvgPicture.asset('images/bar_point_active_green.svg'));
        pointList.insert(2, SvgPicture.asset('images/bar_point_active_orange.svg'));

        textPointLabelList.insert(2, Text("Produksi\nTelur", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
    }

    void getFeedBrand({String? keyword}) {
        if (keyword != null && keyword.length > 3) {
            AuthImpl().get().then((auth) => {
                if (auth != null) {
                    Service.push(
                        apiKey: 'productReportApi',
                        service: ListApi.getProducts,
                        context: Get.context!,
                        body: ['Bearer ${auth.token}', auth.id, keyword, "PAKAN", null, 1, 100],
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
            product.remarks = spOvkReason.controller.textSelected.value;
            product.subcategoryCode = 'OVK';
            product.subcategoryName = 'OVK';

            return product;
        } else {
            return Product();
        }
    }

    Product getFeedSelectedObjectWhenIncreased(Product oldProduct) {
        if (feedSuggestField.getController().getSelectedObject() != null) {
            Product product = feedSuggestField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (feedQuantityField.getInputNumber() ?? 0);
            product.remarks = spOvkReason.controller.textSelected.value;

            return product;
        } else {
            return Product();
        }
    }

    Product getOvkSelectedObjectWhenIncreased(Product oldProduct) {
        if (ovkSuggestField.getController().getSelectedObject() != null) {
            Product product = ovkSuggestField.getController().getSelectedObject();
            product.quantity = (oldProduct.quantity ?? 0) + (ovkQuantityField.getInputNumber() ?? 0);
            product.subcategoryCode = 'OVK';
            product.subcategoryName = 'OVK';

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

    void saveDailyReport() => AuthImpl().get().then((auth) {
        if (auth != null) {
            bool isPass = true;
            if (efUtuhCoklat.getInputNumber() == null) {
                efUtuhCoklat.controller.showAlert();
                isPass = false;
            }
            if (efUtuhCoklatTotal.getInputNumber() == null) {
                efUtuhCoklatTotal.controller.showAlert();
                isPass = false;
            }
            if (efUtuhKrem.getInputNumber() == null) {
                efUtuhKrem.controller.showAlert();
                isPass = false;
            }
            if (efUtuhKremTotal.getInputNumber() == null) {
                efUtuhKremTotal.controller.showAlert();
                isPass = false;
            }
            if (efRetak.getInputNumber() == null) {
                efRetak.controller.showAlert();
                isPass = false;
            }
            if (efRetakTotal.getInputNumber() == null) {
                efRetakTotal.controller.showAlert();
                isPass = false;
            }
            if (efPecah.getInputNumber() == null) {
                efPecah.controller.showAlert();
                isPass = false;
            }
            if (efPecahTotal.getInputNumber() == null) {
                efPecahTotal.controller.showAlert();
                isPass = false;
            }
            if (efKotor.getInputNumber() == null) {
                efKotor.controller.showAlert();
                isPass = false;
            }
            if (efKotorTotal.getInputNumber() == null) {
                efKotorTotal.controller.showAlert();
                isPass = false;
            }
            if (spAbnormalEgg.controller.selectedIndex == -1) {
                spAbnormalEgg.controller.showAlert();
                isPass = false;
            }
            if (recordingCardPhotoList.isEmpty) {
                mfRecordingCard.controller.showAlert();
                isPass = false;
            }

            if (isPass) {
                showModalBottomSheet(
                    useSafeArea: true,
                    isDismissible: false,
                    enableDrag: false,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                    ),
                    isScrollControlled: true,
                    context: Get.context!,
                    builder: (context) => ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                        child: Container(
                            color: Colors.white,
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
                                            Text('Apakah kamu yakin data yang dimasukan sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                                            const SizedBox(height: 16),
                                            Text('Pastikan semua data yang kamu masukan semua sudah benar', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                            const SizedBox(height: 16),
                                            Center(child: SvgPicture.asset('images/people_ask_confirm_icon.svg')),
                                            const SizedBox(height: 32),
                                            SizedBox(
                                                width: MediaQuery.of(Get.context!).size.width - 32,
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: ButtonFill(controller: GetXCreator.putButtonFillController("btnLayerDailyReportYes"), label: "Yakin", onClick: () {
                                                                Navigator.pop(Get.context!);
                                                                _pushDailyReportToServer();
                                                            })
                                                        ),
                                                        const SizedBox(width: 16),
                                                        Expanded(
                                                            child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnLayerDailyReportNo"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!))
                                                        )
                                                    ]
                                                )
                                            ),
                                            const SizedBox(height: 32)
                                        ]
                                    )
                                )
                            )
                        ),
                    )
                );
            }
        } else {
            GlobalVar.invalidResponse();
        }
    });

    void _pushDailyReportToServer() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            _changeHarvestedEggData(productName: 'Telur Utuh Cokelat', producItemId: 'cc9f03bd-5d75-467f-bada-74382ac7bac2', editField: efUtuhCoklat);
            _changeHarvestedEggData(productName: 'Telur Utuh Cokelat', producItemId: 'cc9f03bd-5d75-467f-bada-74382ac7bac2', editField: efUtuhCoklatTotal, isQuantity: false);
            _changeHarvestedEggData(productName: 'Telur Utuh Krem', producItemId: 'd66aa790-4495-483f-96ce-00214c220a49', editField: efUtuhKrem);
            _changeHarvestedEggData(productName: 'Telur Utuh Krem', producItemId: 'd66aa790-4495-483f-96ce-00214c220a49', editField: efUtuhKremTotal, isQuantity: false);
            _changeHarvestedEggData(productName: 'Telur Retak', producItemId: '96ed27f9-f2a4-4c33-919d-e7ac8d274154', editField: efRetak);
            _changeHarvestedEggData(productName: 'Telur Retak', producItemId: '96ed27f9-f2a4-4c33-919d-e7ac8d274154', editField: efRetakTotal, isQuantity: false);
            _changeHarvestedEggData(productName: 'Telur Pecah', producItemId: '6721a808-ceea-44a9-bbed-eba8b0ccfcb4', editField: efPecah);
            _changeHarvestedEggData(productName: 'Telur Pecah', producItemId: '6721a808-ceea-44a9-bbed-eba8b0ccfcb4', editField: efPecahTotal, isQuantity: false);
            _changeHarvestedEggData(productName: 'Telur Kotor', producItemId: '2186e5cf-feb6-4f9c-ad6e-e43f6957262b', editField: efKotor);
            _changeHarvestedEggData(productName: 'Telur Kotor', producItemId: '2186e5cf-feb6-4f9c-ad6e-e43f6957262b', editField: efKotorTotal, isQuantity: false);

            int mortality = 0;
            reasonMultipleFormField.controller.listObjectAdded.entries.map((entry) {
                if ((entry.value as MortalityReason).quantity != null) {
                    mortality += (entry.value as MortalityReason).quantity!.toInt();
                }
            }).toList();

            Report bodyReport = Report(
                averageWeight: efWeight.getInputNumber(),
                culling: efCulled.getInputNumber()!.toInt(),
                mortality: mortality,
                mortalityImage: chickDeadPhotoList.isNotEmpty ? chickDeadPhotoList[0]!.url : null,
                mortalityList: reasonMultipleFormField.controller.listObjectAdded.entries.map((entry) => entry.value as MortalityReason).toList(),
                feedConsumptions: feedMultipleFormField.controller.listObjectAdded.entries.map((entry) {
                    if ((entry.value as Product).feedStockSummaryId == null) {
                        (entry.value as Product).feedStockSummaryId = (entry.value as Product).id;
                    }
                    return entry.value;
                }).toList().cast<Product>(),
                ovkConsumptions: ovkMultipleFormField.controller.listObjectAdded.entries.map((entry) {
                    if ((entry.value as Product).ovkStockSummaryId == null) {
                        (entry.value as Product).ovkStockSummaryId = (entry.value as Product).id;
                    }
                    return entry.value;
                }).toList().cast<Product>(),
                harvestedEgg: report.harvestedEgg,
                recordingImage: recordingCardPhotoList[0]!.url,
                remarks: eaDesc.getInput(),
                eggDisposal: efEggDisposal.getInputNumber(),
                isAbnormal: spAbnormalEgg.controller.textSelected.value == 'Ya',
                feedTypeCode: "",
                feedQuantity: 0
            );

            Service.push(
                apiKey: ApiMapping.taskApi,
                service: ListApi.addReport,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathAddReport(coop.farmingCycleId!, report.date!), Mapper.asJsonString(bodyReport)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        isLoading.value = false;
                        Get.to(TransactionSuccessActivity(
                            keyPage: "addReportLayerDaily",
                            message: "Kamu telah berhasil melakukan laporan harian",
                            showButtonHome: false,
                            onTapClose: () => Get.back(),
                            onTapHome: () {}
                        ))!.then((value) => Get.back(result: true));
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
        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class LayerDailyReportFormBinding extends Bindings {
    BuildContext context;
    LayerDailyReportFormBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<LayerDailyReportFormController>(() => LayerDailyReportFormController(context: context));
}