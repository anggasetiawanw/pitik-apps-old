import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
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
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/product_model.dart';
import 'package:model/report.dart';
import 'package:model/response/products_response.dart';
import 'package:model/response/stock_summary_response.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';

class DailyReportFormController extends GetxController with GetSingleTickerProviderStateMixin {
  BuildContext context;
  DailyReportFormController({required this.context});

  var isPurposeCoop = false.obs;
  var isLoading = false.obs;
  var isLoadingPicture = false.obs;
  var countLoading = 0.obs;

  late bool isEdit = false;
  var isFeed = true.obs;
  late TabController tabController = TabController(length: 2, vsync: this);
  Report reportDetail = Report();

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
    textUnit: "Ekor",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  EditField efCulling = EditField(
    controller: GetXCreator.putEditFieldController("efCulling"),
    label: "Culling",
    hint: "Ketik disini",
    alertText: "Culling harus di isi ",
    textUnit: "Ekor",
    maxInput: 20,
    inputType: TextInputType.number,
    onTyping: (value, edit) {},
  );

  late MediaField mfPhoto;
  late EditField efTotalPakan;
  late SpinnerField sfMerkPakan;
  late SpinnerField sfJenisOvk;
  late EditField efTotalOvk;

  late MultipleFormField<Product> mffKonsumsiPakan;
  late MultipleFormField<Product> mffKonsumsiOVK;

  late ButtonFill bfSimpan = ButtonFill(controller: GetXCreator.putButtonFillController("btSimpan"), label: "Simpan", onClick: () => addReport());

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

  var countApi = 0;
  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    report = Get.arguments[1];

    efTotalPakan = EditField(
        controller: GetXCreator.putEditFieldController("efTotalPakanDailyReport"),
        label: "Total",
        hint: "Ketik disini",
        alertText: "Total harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {},
    );

    sfMerkPakan = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController<Product>("sfMerkPakanDailyReport"),
        label: "Merk Pakan",
        hint: "Pilih Salah Satu",
        alertText: "Merk Pakan Harus Dipilih",
        items: const {},
        onSpinnerSelected: (text) => efTotalPakan.getController().changeTextUnit(_getLatestFeedTextUnit()),
    );

    efTotalOvk = EditField(
        controller: GetXCreator.putEditFieldController("efTotalOvk"),
        label: "Total",
        hint: "Ketik disini",
        alertText: "Total harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {},
    );

    sfJenisOvk = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController<Product>("sfJenisOvkDailyReport"),
        label: "Jenis OVK",
        hint: "Pilih Salah Satu",
        alertText: "Jenis OVK Harus Dipilih",
        items: const {},
        onSpinnerSelected: (text) => efTotalOvk.getController().changeTextUnit(_getLatestOvkTextUnit()),
    );

    mfPhoto = MediaField(
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
        alertText: "Kartu Recording harus dikirim",
        type: MediaField.PHOTO,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
        mffKonsumsiPakan = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController("mffKonsumsiPakanDailyReport"),
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

        mffKonsumsiOVK = MultipleFormField<Product>(
            controller: GetXCreator.putMultipleFormFieldController<Product>("MultipleOvkDailyReport"),
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
            )
        );
    });

    if (Get.arguments.length > 2) {
        isEdit = Get.arguments[2];
        reportDetail = Get.arguments[3];
    }
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
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

    return isPass;
  }

  void addReport() {
    if (_validation()) {
      _showReportSummary();
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
                                        Expanded(child: Text(getFeedProductName(product: feedStockSummaryList[index - 1]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),overflow: TextOverflow.clip,)),
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
                                        Expanded(child: Text(getOvkProductName(product: ovkStockSummaryList[index - 1]), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),overflow: TextOverflow.clip,)),
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

  void _showReportSummary() {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 60, height: 4, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: GlobalVar.outlineColor))),
                const SizedBox(height: 16),
                Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Tanggal Pengiriman', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text(report.date!, style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Bobot', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text("${efBobot.getInputNumber()} gr", style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Kematian', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text("${efKematian.getInputNumber()} ekor", style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Culling', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)), Text("${efCulling.getInputNumber()} Ekor", style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))],
                ),
                const SizedBox(height: 16),
                Text('Komsumsi Pakan', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                      children: mffKonsumsiPakan.getController().listAdded.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              getFeedProductName(product: mffKonsumsiPakan.getController().listObjectAdded[entry.key]),
                              style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),
                            ),
                          ),
                          Text(
                            getFeedQuantity(product: mffKonsumsiPakan.getController().listObjectAdded[entry.key]),
                            style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ),
                const SizedBox(height: 16),
                Text('Komsumsi OVK', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                      children: mffKonsumsiOVK.getController().listAdded.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              getOvkProductName(product: mffKonsumsiOVK.getController().listObjectAdded[entry.key]),
                              style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),
                            ),
                          ),
                          Text(
                            getOvkQuantity(product: mffKonsumsiOVK.getController().listObjectAdded[entry.key]),
                            style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(Get.context!).size.width - 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ButtonFill(
                              controller: GetXCreator.putButtonFillController("btnAgreeDailyRepor"),
                              label: "Yakin",
                              onClick: () {
                                Get.back();
                                isLoading.value = true;
                                AuthImpl().get().then((auth) {
                                  if (auth != null) {
                                    Report requestBody = Report(
                                      averageWeight: efBobot.getInputNumber(),
                                      mortality: (efKematian.getInputNumber() ?? 0).toInt(),
                                      culling: (efCulling.getInputNumber() ?? 0).toInt(),
                                      images: reportPhotoList,
                                      feedConsumptions: mffKonsumsiPakan.getController().listObjectAdded.entries.map((entry) {
                                          if ((entry.value as Product).feedStockSummaryId == null) {
                                              (entry.value as Product).feedStockSummaryId = (entry.value as Product).id;
                                          }
                                          return entry.value;
                                      }).toList().cast<Product>(),
                                      ovkConsumptions: mffKonsumsiOVK.getController().listObjectAdded.entries.map((entry) {
                                          if ((entry.value as Product).ovkStockSummaryId == null) {
                                              (entry.value as Product).ovkStockSummaryId = (entry.value as Product).id;
                                          }
                                          return entry.value;
                                      }).toList().cast<Product>(),
                                      feedTypeCode: "",
                                      feedQuantity: 0,
                                    );

                                    if (isEdit) {
                                      _pushDailyReportToServer(['Bearer ${auth.token}', auth.id, ListApi.pathAddReport(coop.farmingCycleId!, report.taskTicketId!), Mapper.asJsonString(requestBody)]);
                                    } else {
                                      _pushDailyReportToServer(['Bearer ${auth.token}', auth.id, ListApi.pathAddReport(coop.farmingCycleId!, report.taskTicketId!), Mapper.asJsonString(requestBody)]);
                                    }
                                  } else {
                                    GlobalVar.invalidResponse();
                                  }
                                });
                              })),
                      const SizedBox(width: 16),
                      Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnNotAgreeDailyRepo"), label: "Tidak Yakin", onClick: () => Get.back()))
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pushDailyReportToServer(List<dynamic> body) {
    Service.push(
        apiKey: ApiMapping.taskApi,
        service: ListApi.addReport,
        context: Get.context!,
        body: body,
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.to(TransactionSuccessActivity(keyPage: "Add Report Succes", message: "Kamu telah berhasil melakukan laporan harian", showButtonHome: false, onTapClose: () => Get.back(), onTapHome: () {}))!.then((value) => Get.back(result: true));
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
      if (isEdit) {
        fillEditForm();
      }
      isLoading.value = false;
      countLoading.value = 0;
    }
  }

  void fillEditForm() {
    efBobot.setInput(reportDetail.averageWeight?.toString() ?? '');
    efKematian.setInput(reportDetail.mortality?.toString() ?? '');
    efCulling.setInput(reportDetail.culling?.toString() ?? '');

    // fill photo
    reportPhotoList.value = reportDetail.images ?? [];
    if (reportPhotoList.isNotEmpty) {
        mfPhoto.getController().setInformasiText("File telah terupload");
        mfPhoto.getController().showInformation();
        mfPhoto.getController().setFileName(reportPhotoList[0]!.id!);
    }

    // fill feed
    if (reportDetail.feedConsumptions != null && reportDetail.feedConsumptions!.isNotEmpty) {
        for (var product in reportDetail.feedConsumptions!) {
            mffKonsumsiPakan.getController().addData(
                child: _createChildAdded(getFeedProductName(product: product), getFeedQuantity(product: product)),
                object: product,
                key: getFeedProductName(product: product)
            );
        }
    }

    // fill ovk
    if (reportDetail.ovkConsumptions != null && reportDetail.ovkConsumptions!.isNotEmpty) {
        for (var product in reportDetail.ovkConsumptions!) {
            mffKonsumsiOVK.getController().addData(
                child: _createChildAdded(getOvkProductName(product: product), getOvkQuantity(product: product)),
                object: product,
                key: getOvkProductName(product: product)
            );
        }
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
                      Future.delayed(const Duration(milliseconds: 500), () {
                        _setupSpinnerBrand(field: sfMerkPakan, productList: (body as ProductsResponse).data);
                        _checkCountLoading();
                      });
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
                      Future.delayed(const Duration(milliseconds: 500), () {
                        _setupSpinnerBrand(field: sfJenisOvk, productList: (body as ProductsResponse).data, isFeed: false);
                        _checkCountLoading();
                      });
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
                      _checkCountLoading();
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
                      _checkCountLoading();
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
      String key = isFeed
          ? '${product == null || product.subcategoryCode == null ? '' : product.subcategoryCode} - ${product == null || product.productName == null ? '' : product.productName}'
          : product == null || product.productName == null
              ? ''
              : "${product.productName}(${product.remainingQuantity} ${product.uom ?? product.purchaseUom ?? ''})";

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
