import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
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
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/product_model.dart';
import 'package:model/report.dart';
import 'package:model/response/products_response.dart';
import 'package:model/response/stock_summary_response.dart';
import 'package:pitik_ppl_app/route.dart';

class DailyReportFormController extends GetxController with GetSingleTickerProviderStateMixin {
  BuildContext context;
  DailyReportFormController({required this.context});

  var isPurposeCoop = false.obs;
  var isLoading = false.obs;
  var isLoadingPicture = false.obs;
  var countLoading = 0.obs;

  var isFeed = true.obs;
  late TabController tabController = TabController(length: 2, vsync: this);

  EditField efBobot = EditField(
    controller: GetXCreator.putEditFieldController("efBobot"),
    label: "Bobot",
    hint: "Ketik disini",
    alertText: "Bobot harus di isi ",
    textUnit: "gr",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  EditField efKematian = EditField(
    controller: GetXCreator.putEditFieldController("efKematian"),
    label: "Kematian",
    hint: "Ketik disini",
    alertText: "Kematian harus di isi ",
    textUnit: "gr",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  EditField efCulling = EditField(
    controller: GetXCreator.putEditFieldController("efCulling"),
    label: "Culling",
    hint: "Ketik disini",
    alertText: "Culling harus di isi ",
    textUnit: "gr",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  late MediaField mfPhoto = MediaField(
      controller: GetXCreator.putMediaFieldController("mfPhoto"),
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
                          reportPhotoList.add(body.data);
                          mfPhoto.getController().setInformasiText("File telah terupload");
                          mfPhoto.getController().showInformation();
                          isLoadingPicture.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                          Get.snackbar("Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);

                          isLoadingPicture.value = false;
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                          Get.snackbar("Pesan", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), colorText: Colors.white, backgroundColor: Colors.red);

                          isLoadingPicture.value = false;
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()));
              }
            } else {
              GlobalVar.invalidResponse();
            }
          }),
      label: "Upload Kartu Recording",
      hint: "Upload Kartu Recording",
      alertText: "Kartu Recording harus dikirim");

  late SpinnerField sfMerkPakan = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("sfMerkPakan"),
    label: "Merk Pakan",
    hint: "Pilih Salah Satu",
    alertText: "Merk Pakan Harus Dipilih",
    items: const {},
    onSpinnerSelected: (text) => efTotalPakan.getController().changeTextUnit(_getLatestFeedTextUnit()),
  );

  late EditField efTotalPakan = EditField(
    controller: GetXCreator.putEditFieldController("efTotalPakan"),
    label: "Total",
    hint: "Ketik disini",
    alertText: "Total harus di isi ",
    textUnit: "gr",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  late SpinnerField sfJenisOvk = SpinnerField(
    controller: GetXCreator.putSpinnerFieldController("sfJenisOvkDailyReport"),
    label: "Jenis OVK",
    hint: "Pilih Salah Satu",
    alertText: "Jenis OVK Harus Dipilih",
    items: const {},
    onSpinnerSelected: (text) => efTotalOvk.getController().changeTextUnit(_getLatestOvkTextUnit()),
  );

  late EditField efTotalOvk = EditField(
    controller: GetXCreator.putEditFieldController("efTotalOvk"),
    label: "Total",
    hint: "Ketik disini",
    alertText: "Total harus di isi ",
    textUnit: "gr",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  late MultipleFormField<Product> mffKonsumsiPakan = MultipleFormField<Product>(
      controller: GetXCreator.putMultipleFormFieldController("mffKonsumsiPakan"),
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
        if (sfMerkPakan.getController().selectedIndex == -1) {
          sfMerkPakan.getController().showAlert();
          isPass = false;
        }
        if (efTotalPakan.getInputNumber() == null) {
          efTotalPakan.getController().showAlert();
          isPass = false;
        }

        return isPass;
      },
      child: Column(
        children: [
          sfMerkPakan,
          efTotalPakan,
        ],
      ));

  late MultipleFormField mffKonsumsiOVK = MultipleFormField(
      controller: GetXCreator.putMultipleFormFieldController<Product>("transferMultipleOvk"),
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
        if (sfJenisOvk.getController().selectedIndex == -1) {
          sfJenisOvk.getController().showAlert();
          isPass = false;
        }
        if (efTotalOvk.getInputNumber() == null) {
          efTotalOvk.getController().showAlert();
          isPass = false;
        }

        return isPass;
      },
      child: Column(
        children: [
          sfJenisOvk,
          efTotalOvk,
        ],
      ));

  ButtonFill bfSimpan = ButtonFill(controller: GetXCreator.putButtonFillController("btSimpan"), label: "Simpan", onClick: () {});

  late Coop coop;
  late Report report;
  RxList<Product?> feedStockSummaryList = <Product?>[].obs;
  RxList<Product?> ovkStockSummaryList = <Product?>[].obs;
  RxList<MediaUploadModel?> reportPhotoList = <MediaUploadModel?>[].obs;
  // for stock summary
  var ovkStockSummary = "-".obs;
  var prestarterStockSummary = "-".obs;
  var starterStockSummary = "-".obs;
  var finisherStockSummary = "-".obs;
  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    report = Get.arguments[1];
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOvkStockSummary();
      _getFeedStockSummary();
      _getOvkBrand();
      _getFeedBrand();
    });
  }

  // @override
  // void onClose() {
  //     super.onClose();
  // }
  Row _createChildAdded(String productName, String quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Flexible(child: Text(productName, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))), const SizedBox(width: 16), Text(quantity, style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium))],
    );
  }

  String _getLatestFeedTextUnit() {
    if (sfMerkPakan.getController().selectedObject == null) {
      return '';
    } else {
      if ((sfMerkPakan.getController().selectedObject as Product).uom != null) {
        return (sfMerkPakan.getController().selectedObject as Product).uom!;
      } else if ((sfMerkPakan.getController().selectedObject as Product).purchaseUom != null) {
        return (sfMerkPakan.getController().selectedObject as Product).purchaseUom!;
      } else {
        return '';
      }
    }
  }

  String _getLatestOvkTextUnit() {
    if (sfJenisOvk.getController().selectedObject == null) {
      return '';
    } else {
      if ((sfJenisOvk.getController().selectedObject as Product).uom != null) {
        return (sfJenisOvk.getController().selectedObject as Product).uom!;
      } else if ((sfJenisOvk.getController().selectedObject as Product).purchaseUom != null) {
        return (sfJenisOvk.getController().selectedObject as Product).purchaseUom!;
      } else {
        return '';
      }
    }
  }

  bool _validation() {
    bool isPass = true;
    if (efBobot.getInput().isEmpty) {
      efBobot.getController().showAlert();
      Scrollable.ensureVisible(efBobot.controller.formKey.currentContext!);
      isPass = false;
    }
    if (efKematian.getInput().isEmpty) {
      efKematian.getController().showAlert();
      Scrollable.ensureVisible(efKematian.controller.formKey.currentContext!);
      isPass = false;
    }
    if (efCulling.getInput().isEmpty) {
      efCulling.getController().showAlert();
      Scrollable.ensureVisible(efCulling.controller.formKey.currentContext!);
      isPass = false;
    }
    if (mfPhoto.getController().fileName.isEmpty) {
      mfPhoto.getController().showAlert();
      Scrollable.ensureVisible(mfPhoto.controller.formKey.currentContext!);
      isPass = false;
    }
    if (mffKonsumsiPakan.getController().listObjectAdded.isEmpty) {
      Get.snackbar(
        "Pesan",
        "Pakan tidak boleh kosong!, silahkan isi terlebih dahulu..!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      isPass = false;
    }

    // if (isFeed.isTrue) {
    //   if (transferCoopTargetField.getController().selectedIndex == -1) {
    //     transferCoopTargetField.getController().showAlert();
    //     isPass = false;
    //   }
    //   if (feedMultipleFormField.getController().listObjectAdded.isEmpty) {
    //     Get.snackbar(
    //       "Pesan",
    //       "Merek Pakan masih kosong, silahkan isi terlebih dahulu..!",
    //       snackPosition: SnackPosition.TOP,
    //       colorText: Colors.white,
    //       backgroundColor: Colors.red,
    //     );
    //     isPass = false;
    //   }
    // } else {
    //   if (transferPurposeField.getController().selectedIndex == -1) {
    //     transferPurposeField.getController().showAlert();
    //     isPass = false;
    //   }
    //   if (isPurposeCoop.isTrue && transferCoopTargetField.getController().selectedIndex == -1) {
    //     transferCoopTargetField.getController().showAlert();
    //     isPass = false;
    //   }
    //   if (mffKonsumsiOVK.getController().listObjectAdded.isEmpty) {
    //     Get.snackbar(
    //       "Pesan",
    //       "Merek OVK masih kosong, silahkan isi terlebih dahulu..!",
    //       snackPosition: SnackPosition.TOP,
    //       colorText: Colors.white,
    //       backgroundColor: Colors.red,
    //     );
    //     isPass = false;
    //   }
    // }

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
                                      children: [Text('Merek Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)), Text('Stok', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold))],
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
                                        Text(
                                          feedStockSummaryList[index - 1] == null ? '-' : _getRemainingQuantity(feedStockSummaryList[index - 1]!),
                                          style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4)
                                  ],
                                );
                              }
                            }),
                          )),
                      const SizedBox(height: 16),
                      Expandable(
                          expanded: true,
                          controller: GetXCreator.putAccordionController("accordionOvkStockSummary"),
                          headerText: 'OVK',
                          child: Column(
                            children: List.generate(ovkStockSummaryList.length + 1, (index) {
                              if (index == 0) {
                                return Column(children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Merek OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                                      Text(
                                        'Stok',
                                        style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8)
                                ]);
                              } else {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(getOvkProductName(product: ovkStockSummaryList[index - 1]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                                        Text(
                                          ovkStockSummaryList[index - 1] == null ? '-' : _getRemainingQuantity(ovkStockSummaryList[index - 1]!),
                                          style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4)
                                  ],
                                );
                              }
                            }),
                          )),
                      const SizedBox(height: 32),
                    ])))));
  }

  void _showFeedSummary({bool isFeed = true}) {
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
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                // const SizedBox(height: 16),
                // Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                // const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [Text('Tanggal Pengiriman', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(transferDateField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                // ),
                // const SizedBox(height: 8),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [Text('Jenis Transfer', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(isFeed ? 'Pakan' : 'OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                // ),
                // if (isFeed) ...[
                //   const SizedBox(height: 8),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [Text('Kandang Tujuan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(transferCoopTargetField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                //   ),
                //   const SizedBox(height: 8),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [Text('Metode Pemesanan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(transferMethodField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                //   ),
                //   const SizedBox(height: 16),
                //   Text('Total Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                //   Padding(
                //     padding: const EdgeInsets.only(left: 12),
                //     child: Column(
                //         children: mffKonsumsiPakan.getController().listAdded.entries.map((entry) {
                //       return Padding(
                //           padding: const EdgeInsets.only(top: 8),
                //           child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [Expanded(child: Text(getFeedProductName(product: mffKonsumsiPakan.getController().listObjectAdded[entry.key]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))), Text(getFeedQuantity(product: feedMultipleFormField.getController().listObjectAdded[entry.key]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))]));
                //     }).toList()),
                //   )
                // ] else ...[
                //   const SizedBox(height: 8),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [Text('Tujuan Transfer', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(isPurposeCoop.isTrue ? 'Kandang' : 'Unit', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                //   ),
                //   isPurposeCoop.isTrue
                //       ? Column(
                //           children: [
                //             const SizedBox(height: 8),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [Text('Kandang Tujuan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(transferCoopTargetField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                //             )
                //           ],
                //         )
                //       : const SizedBox(),
                //   const SizedBox(height: 8),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [Text('Metode Pemesanan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(transferMethodField.getController().textSelected.value, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                //   ),
                //   const SizedBox(height: 16),
                //   Text('Total OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                //   Padding(
                //     padding: const EdgeInsets.only(left: 12),
                //     child: Column(
                //         children: mffKonsumsiOVK.getController().listAdded.entries.map((entry) {
                //       return Padding(
                //           padding: const EdgeInsets.only(top: 8),
                //           child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(getOvkProductName(product: mffKonsumsiOVK.getController().listObjectAdded[entry.key]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))), Text(getOvkQuantity(product: mffKonsumsiOVK.getController().listObjectAdded[entry.key]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))]));
                //     }).toList()),
                //   )
                // ],
                // const SizedBox(height: 50),
                // SizedBox(
                //   width: MediaQuery.of(Get.context!).size.width - 32,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //           child: ButtonFill(
                //               controller: GetXCreator.putButtonFillController("btnAgreeTransferRequest"),
                //               label: "Yakin",
                //               onClick: () {
                //                 Get.back();
                //                 isLoading.value = true;
                //                 AuthImpl().get().then((auth) {
                //                   if (auth != null) {
                //                     //   String requestedDate = '${Convert.getYear(transferDateField.getLastTimeSelected())}-${Convert.getMonthNumber(transferDateField.getLastTimeSelected())}-${Convert.getDay(transferDateField.getLastTimeSelected())}';
                //                     //   String? coopId = isFeed || transferPurposeField.getController().selectedIndex == 0 ? (transferCoopTargetField.getController().getSelectedObject() as Coop).id! : null;
                //                     //   String route = "COOP-TO-COOP";
                //                     //   if (coop.isOwnFarm != null && coop.isOwnFarm! && transferPurposeField.getController().textSelected.value == "Unit") {
                //                     //     route = "COOP-TO-BRANCH";
                //                     //   }

                //                     //   Procurement requestBody = Procurement(
                //                     //       coopSourceId: coop.id,
                //                     //       coopTargetId: coopId,
                //                     //       farmingCycleId: coop.farmingCycleId,
                //                     //       datePlanned: requestedDate,
                //                     //       logisticOption: transferMethodField.getController().textSelected.value.replaceAll(" ", ""),
                //                     //       notes: "",
                //                     //       route: route,
                //                     //       photos: transferPhotoList,
                //                     //       type: isFeed ? "pakan" : "ovk",
                //                     //       details: isFeed ? feedMultipleFormField.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>() : mffKonsumsiOVK.getController().listObjectAdded.entries.map((entry) => entry.value).toList().cast<Product>(),
                //                     //       subcategoryCode: "",
                //                     //       subcategoryName: "",
                //                     //       quantity: 1,
                //                     //       uom: "",
                //                     //       productName: "");

                //                     //   if (isEdit) {
                //                     //     _pushTransferRequestToServer(ListApi.updateOrderOrTransferRequest, ['Bearer ${auth.token}', auth.id, 'v2/transfer-requests/${procurement.id}', Mapper.asJsonString(requestBody)]);
                //                     //   } else {
                //                     //     _pushTransferRequestToServer(ListApi.saveTransferRequest, ['Bearer ${auth.token}', auth.id, Mapper.asJsonString(requestBody)]);
                //                     //   }
                //                   } else {
                //                     GlobalVar.invalidResponse();
                //                   }
                //                 });
                //               })),
                //       const SizedBox(width: 16),
                //       Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnNotAgreeTransferRequest"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!)))
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
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
              Get.off(TransactionSuccessActivity(keyPage: "transferSaved", message: "Kamu telah berhasil melakukan permintaan transfer pakan ke kandang lain", showButtonHome: false, onTapClose: () => Get.toNamed(RoutePage.dailyReport, arguments: coop), onTapHome: () {}));
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
            onTokenInvalid: () => GlobalVar.invalidResponse()));
  }

  void _checkCountLoading() {
    countLoading.value++;
    if (countLoading.value == 3) {
      isLoading.value = false;
      countLoading.value = 0;
    }
  }

  void _getFeedBrand() => AuthImpl().get().then((auth) => {
        if (auth != null)
          {
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getStocks,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathFeedStocks(coop.farmingCycleId!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                      feedStockSummaryList.value = body.data;
                      _setupSpinnerBrand(field: sfMerkPakan, productList: (body as ProductsResponse).data);
                      _checkCountLoading();
                    },
                    onResponseFail: (code, message, body, id, packet) => _checkCountLoading(),
                    onResponseError: (exception, stacktrace, id, packet) => _checkCountLoading(),
                    onTokenInvalid: () => GlobalVar.invalidResponse()))
          }
        else
          {GlobalVar.invalidResponse()}
      });

  void _getOvkBrand() => AuthImpl().get().then((auth) => {
        if (auth != null)
          {
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getStocks,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, ListApi.pathOvkStocks(coop.farmingCycleId!)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                      ovkStockSummaryList.value = body.data;
                        _setupSpinnerBrand(field: sfJenisOvk, productList: (body as ProductsResponse).data, isFeed: false);
                      _checkCountLoading();
                    },
                    onResponseFail: (code, message, body, id, packet) => _checkCountLoading(),
                    onResponseError: (exception, stacktrace, id, packet) => _checkCountLoading(),
                    onTokenInvalid: () => GlobalVar.invalidResponse()))
          }
        else
          {GlobalVar.invalidResponse()}
      });

  String _getRemainingQuantity(Product product) {
    return '${product.remainingQuantity == null ? '-' : product.remainingQuantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}';
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
                    onTokenInvalid: () => GlobalVar.invalidResponse()))
          }
        else
          {GlobalVar.invalidResponse()}
      });

  void _getOvkStockSummary() => AuthImpl().get().then((auth) => {
        if (auth != null)
          {
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
                          uom = product == null ? '' : product.uom ?? product.purchaseUom ?? '';
                        }

                        ovkStockSummary.value = '${ovkStock.toStringAsFixed(0)} $uom';
                      }
                    },
                    onResponseFail: (code, message, body, id, packet) {},
                    onResponseError: (exception, stacktrace, id, packet) {},
                    onTokenInvalid: () => GlobalVar.invalidResponse()))
          }
        else
          {GlobalVar.invalidResponse()}
      });

  void _setupSpinnerBrand({required SpinnerField field, required List<Product?> productList, bool isFeed = true}) {
    field.getController().setupObjects(productList);
    for (var product in productList) {
      String key = isFeed ? '${product == null || product.subcategoryCode == null ? '' : product.subcategoryCode} - ${product == null || product.productName == null ? '' : product.productName}' : product == null || product.productName == null ? '' : "${product.productName}(${product.remainingQuantity} ${product.uom ?? product.purchaseUom ?? ''})";

      field.getController().addItems(value: key, isActive: false);
    }
  }

  Product getFeedSelectedObject() {
    if (sfMerkPakan.getController().getSelectedObject() != null) {
      Product product = sfMerkPakan.getController().getSelectedObject();
      product.quantity = efTotalPakan.getInputNumber() ?? 0;

      return product;
    } else {
      return Product();
    }
  }

  Product getOvkSelectedObject() {
    if (sfJenisOvk.getController().getSelectedObject() != null) {
      Product product = sfJenisOvk.getController().getSelectedObject();
      product.quantity = efTotalOvk.getInputNumber() ?? 0;

      return product;
    } else {
      return Product();
    }
  }

  Product getFeedSelectedObjectWhenIncreased(Product oldProduct) {
    if (sfMerkPakan.getController().getSelectedObject() != null) {
      Product product = sfMerkPakan.getController().getSelectedObject();
      product.quantity = (oldProduct.quantity ?? 0) + (efTotalPakan.getInputNumber() ?? 0);

      return product;
    } else {
      return Product();
    }
  }

  Product getOvkSelectedObjectWhenIncreased(Product oldProduct) {
    if (sfJenisOvk.getController().getSelectedObject() != null) {
      Product product = sfJenisOvk.getController().getSelectedObject();
      product.quantity = (oldProduct.quantity ?? 0) + (efTotalOvk.getInputNumber() ?? 0);

      return product;
    } else {
      return Product();
    }
  }

  String getFeedProductName({Product? product}) {
    if (product != null) {
      return '${product.subcategoryCode ?? ''} - ${product.productName ?? ''}';
    } else {
      if (sfMerkPakan.getController().selectedObject == null) {
        return '';
      } else {
        return '${(sfMerkPakan.getController().selectedObject as Product).subcategoryCode ?? ''} - ${(sfMerkPakan.getController().selectedObject as Product).productName ?? ''}';
      }
    }
  }

  String getOvkProductName({Product? product}) {
    if (product != null) {
      return product.productName ?? '';
    } else {
      if (sfJenisOvk.getController().selectedObject == null) {
        return '';
      } else {
        return (sfJenisOvk.getController().selectedObject as Product).productName ?? '';
      }
    }
  }

  String getFeedQuantity({Product? product}) {
    if (product != null) {
      return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}';
    } else {
      return '${efTotalPakan.getInputNumber() == null ? '' : efTotalPakan.getInputNumber()!.toStringAsFixed(0)} ${efTotalPakan.getController().textUnit.value}';
    }
  }

  String getOvkQuantity({Product? product}) {
    if (product != null) {
      return '${product.quantity == null ? '' : product.quantity!.toStringAsFixed(0)} ${product.uom ?? product.purchaseUom ?? ''}';
    } else {
      return '${efTotalOvk.getInputNumber() == null ? '' : efTotalOvk.getInputNumber()!.toStringAsFixed(0)} ${efTotalOvk.getController().textUnit.value}';
    }
  }
}

class DailyReportFormBindings extends Bindings {
  BuildContext context;
  DailyReportFormBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => DailyReportFormController(context: context));
  }
}
