import 'dart:io';

import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/media_field/media_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/procurement_model.dart';
import 'package:model/request_chickin.dart';
import 'package:model/response/internal_app/media_upload_response.dart';
import 'package:model/response/request_chickin_response.dart';
import 'package:share_plus/share_plus.dart';

class DocInController extends GetxController {
    BuildContext context;
    DocInController({required this.context});

    var isLoading = false.obs;
    Coop coop = Coop();
    Rx<Procurement> proc = Procurement().obs;
    Rx<RequestChickin?> request = RequestChickin().obs;

    RxList<MediaUploadModel?> mediaListDoc = <MediaUploadModel?>[].obs;
    RxList<MediaUploadModel?> mediaListSuratJalan = <MediaUploadModel?>[].obs;
    RxList<MediaUploadModel?> mediaListLainnya = <MediaUploadModel?>[].obs;

    var dateDoc = "".obs;
    var showRecord = false.obs;
    var totalPopulation = 0.0.obs;
    var isLoadingPicture = false.obs;
    var isAlreadySubmit = false.obs;

    late EditField efReceiveDoc = EditField(
        controller: GetXCreator.putEditFieldController("receiveDoc"),
        label: "Jumlah DOC Diterima",
        hint: "Masukan Jumlah DOC Diterima",
        alertText: "Jumlah DOC Diterima belum disi",
        textUnit: "Ekor",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {
            if (!(control.getInputNumber()!.toInt() == totalPopulation.value)) {
                control.controller.setAlertText("Jumlah DOC yang Anda input berbeda dengan yang dipesan");
                control.controller.showAlert();
            } else {
                control.controller.setAlertText("Jumlah DOC Diterima belum disi");
                control.controller.hideAlert();
            }
        }
    );

    EditField efMoreDOC = EditField(
        controller: GetXCreator.putEditFieldController("MoreDOC"),
        label: "Lebihan DOC",
        hint: "Masukan Lebihan DOC",
        alertText: "Lebihan DOC belum disi",
        textUnit: "Ekor",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {});

    EditField efBw = EditField(
        controller: GetXCreator.putEditFieldController("bwDOC"),
        label: "BW",
        hint: "BW",
        alertText: "BW belum disi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {});

    EditField efUniform = EditField(
        controller: GetXCreator.putEditFieldController("uniformDOC"),
        label: "Uniformity",
        hint: "Uniformity",
        alertText: "Uniformity belum disi",
        textUnit: "%",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {});

    DateTimeField dtTanggal = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("dtTanggal"),
        label: "Tanggal",
        hint: "dd/MM/yyyy",
        alertText: "Oops tanggal Permintaan belum dipilih!",
        onDateTimeSelected: (time, dateField) => dateField.controller.setTextSelected(DateFormat("dd/MM/yyyy").format(time)),
        flag: 1,
    );

    DateTimeField dtTruckGo = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("dtTruckGo"),
        label: "Jam Truck Berangkat",
        hint: "08:00",
        alertText: "Jam Truck Berangkat belum dipilih",
        onDateTimeSelected: (time, dateField) => dateField.controller.setTextSelected(DateFormat("HH:mm").format(time)),
    );

    DateTimeField dtTruckCome = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("dtTruckCome"),
        label: "Jam Truck Tiba",
        hint: "08:00",
        alertText: "Jam Truck Tiba belum dipilih",
        onDateTimeSelected: (time, dateField) => dateField.controller.setTextSelected(DateFormat("HH:mm").format(time)),
    );

    late DateTimeField dtFinishDoc = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("dtFinishDoc"),
        label: "Selesai DOC In",
        hint: "04/06/2023 - 12:00",
        alertText: "Selesai DOC In belum dipilih",
        onDateTimeSelected: (time, dateField) {
            dateField.controller.setTextSelected(DateFormat("dd/MM/yyyy - HH:mm").format(time));
            String timeLimit = "12:00:00";
            DateTime limit = DateFormat("HH:mm:ss").parse(timeLimit);
            DateTime docTime =DateFormat("HH:mm:ss").parse(DateFormat("HH:mm:ss").format(time));

            if (docTime.compareTo(limit) > 0) {
                final dateDocNow = time;
                final dateDocAdd = dateDocNow.add(const Duration(days: 1));
                dateDoc.value = DateFormat("dd/MM/yyyy").format(dateDocAdd);
                showRecord.value = true;
            } else {
                dateDoc.value = DateFormat("dd/MM/yyyy").format(time);
                showRecord.value = false;
            }
        });

    EditField efDesc = EditField(
        controller: GetXCreator.putEditFieldController("efDesc"),
        label: "Keterangan",
        hint: "Keterangan",
        alertText: "",
        textUnit: "",
        maxInput: 500,
        inputType: TextInputType.multiline,
        height: 160,
        onTyping: (value, editField) {});

    late MediaField mfSuratJalan = MediaField(
        controller: GetXCreator.putMediaFieldController("mfSuratJalan"),
        label: "Upload Surat Jalan",
        hint: "",
        alertText: "Harus menyertakan media foto",
        showGalleryOptions: true,
        type: 2,
        onMediaResult: (file) {
            if (file != null) {
                uploadFile(file, "mfSuratJalan");
            }
        },
    );

    late MediaField mfFormDOC = MediaField(
        controller: GetXCreator.putMediaFieldController("mfFormDOC"),
        label: "Upload Form DOC In",
        hint: "",
        alertText: "Harus menyertakan media foto",
        showGalleryOptions: true,
        type: 2,
        onMediaResult: (file) {
            if (file != null) {
                uploadFile(file, "mfFormDOC");
            }
        },
    );

    late MediaField mfAnotherDoc = MediaField(
        controller: GetXCreator.putMediaFieldController("mfAnotherDoc"),
        label: "Upload Dokumen Lainnya",
        hint: "",
        alertText: "",
        showGalleryOptions: true,
        type: 2,
        onMediaResult: (file) {
            if (file != null) {
                uploadFile(file, "mfAnotherDoc");
            }
        },
    );

    late ButtonFill btSave = ButtonFill(
        controller: GetXCreator.putButtonFillController("Sampe"),
        label: "Simpan",
        onClick: () {
            if (isValid()) {
                _showBottomDialog();
            }
        }
    );

    late ButtonFill btYakin = ButtonFill(controller: GetXCreator.putButtonFillController("byYakin"), label: "Yakin", onClick: () {
        Get.back();
        addChickin();
    });

    ButtonOutline btTidakYakin = ButtonOutline(controller: GetXCreator.putButtonOutlineController("btTidakYakin"), label: "Tidak Yakin", onClick: () => Get.back());

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_DOCin_form_active');
        isLoading.value = true;
        coop = Get.arguments[0];
    }

    @override
    void onReady() {
        super.onReady();
        getListReceive();
        getRequestDoc();
    }

    void getListReceive() {
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: "productReportApi",
                    service: ListApi.getReceiveProcurement,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, false, "doc", null, null, null],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            proc.value = (body.data as List<Procurement?>).first!;
                            if (proc.value.details.isNotEmpty) {
                                totalPopulation.value = proc.value.details[0]!.quantity ?? 0;
                            }
                        },
                        onResponseFail: (code, message, body, id, packet) => Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        ),
                        onResponseError: (exception, stacktrace, id, packet) => Get.snackbar(
                            "Pesan",
                            "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.red
                        ),
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void getRequestDoc() {
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    apiKey: "productReportApi",
                    service: ListApi.getRequestDoc,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetRequestDocByFarmingId(coop.farmingCycleId!)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            request.value = (body as RequestChickinResponse).data;
                            if (body.data != null && body.data!.hasFinishedDOCin != null && body.data!.hasFinishedDOCin!) {
                                setDetailForm((body).data!);
                            }
                            isLoading.value = false;
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                                Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()))
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void setDetailForm(RequestChickin request) {
        String truckGo = "";
        String truckCome = "";
        String doneDocIn = "";
        try {
            DateFormat formatTime = DateFormat("HH:mm");

            DateTime newTruckGo = DateFormat("HH:mm:ss").parse(request.truckLeaving ?? "");
            truckGo = formatTime.format(newTruckGo);

            DateTime newTruckCome = DateFormat("HH:mm:ss").parse(request.truckArrival ?? "");
            truckCome = formatTime.format(newTruckCome);

            DateTime newDoneDocIn = DateFormat("HH:mm:ss").parse(request.finishChickIn ?? "");
            doneDocIn = DateFormat("HH:mm").format(newDoneDocIn);
        } catch (_) {}

        dtTanggal.controller.setTextSelected(Convert.getDate(request.startDate ?? ""));
        dtTanggal.controller.disable();
        dtTruckGo.controller.setTextSelected(truckGo);
        dtTruckGo.controller.disable();
        dtTruckCome.controller.setTextSelected(truckCome);
        dtTruckCome.controller.disable();
        dtFinishDoc.controller.setTextSelected(doneDocIn);
        dtFinishDoc.controller.disable();

        efReceiveDoc.setInput(request.initialPopulation.toString());
        efReceiveDoc.controller.disable();
        efMoreDOC.setInput((request.additionalPopulation ?? 0).toString());
        efMoreDOC.controller.disable();
        efBw.setInput((request.bw ?? 0).toString());
        efBw.controller.disable();
        efUniform.setInput((request.uniformity ?? 0).toString());
        efUniform.controller.disable();
        efDesc.setInput(request.remarks ?? '');
        efDesc.controller.disable();

        mfAnotherDoc.controller.disable();
        mfFormDOC.controller.disable();
        mfSuratJalan.controller.disable();

        isAlreadySubmit.value = true;
    }

    void uploadFile(File? file, String mediaField) {
        isLoadingPicture.value = true;
        AuthImpl().get().then((auth) => {
            if (auth != null) {
                Service.push(
                    service: ListApi.uploadImage,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, "goods-receipt-purchase-order", file],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as MediaUploadResponse).data != null) {
                                body.data!.url = Uri.encodeFull(body.data!.url!);
                            }

                            if (mediaField == "mfSuratJalan") {
                                mediaListSuratJalan.add(body.data);
                                mfSuratJalan.controller.setFileName(body.data!.url ?? '-');
                                mfSuratJalan.controller.setInformasiText("File telah terupload");
                                mfSuratJalan.controller.showInformation();
                            } else if (mediaField == "mfFormDOC") {
                                mediaListDoc.add(body.data);
                                mfFormDOC.controller.setFileName(body.data!.url ?? '-');
                                mfFormDOC.controller.setInformasiText("File telah terupload");
                                mfFormDOC.controller.showInformation();
                            } else if (mediaField == "mfAnotherDoc") {
                                mediaListLainnya.add(body.data);
                                mfAnotherDoc.controller.setFileName(body.data!.url ?? '-');
                                mfAnotherDoc.controller.setInformasiText("File telah terupload");
                                mfAnotherDoc.controller.showInformation();
                            }
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
                            if (mediaField == "mfSuratJalan") {
                                mfSuratJalan.controller.hideInformation();
                            } else if(mediaField == "mfFormDOC") {
                                mfFormDOC.controller.hideInformation();
                            } else if(mediaField == "mfAnotherDoc") {
                                mfAnotherDoc.controller.hideInformation();
                            }
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
                            if (mediaField == "mfSuratJalan") {
                                mfSuratJalan.controller.hideInformation();
                            } else if (mediaField == "mfFormDOC") {
                                mfFormDOC.controller.hideInformation();
                            } else if (mediaField == "mfAnotherDoc") {
                                mfAnotherDoc.controller.hideInformation();
                            }
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse(),
                isLoadingPicture.value = false
            }
        });
    }

    bool isValid() {
        if (dtTanggal.controller.textSelected.value.isEmpty) {
            dtTanggal.controller.showAlert();
            Scrollable.ensureVisible(dtTanggal.controller.formKey.currentContext!);
            return false;
        }

        if (efReceiveDoc.getInput().isEmpty) {
            efReceiveDoc.controller.showAlert();
            Scrollable.ensureVisible(efReceiveDoc.controller.formKey.currentContext!);
            return false;
        }

        if (efMoreDOC.getInput().isEmpty) {
            efMoreDOC.controller.showAlert();
            Scrollable.ensureVisible(efMoreDOC.controller.formKey.currentContext!);
            return false;
        }

        if (efBw.getInput().isEmpty) {
            efBw.controller.showAlert();
            Scrollable.ensureVisible(efBw.controller.formKey.currentContext!);
            return false;
        }

        if (efUniform.getInput().isEmpty) {
            efUniform.controller.showAlert();
            Scrollable.ensureVisible(efUniform.controller.formKey.currentContext!);
            return false;
        }

        if (dtTruckGo.controller.textSelected.value.isEmpty) {
            dtTruckGo.controller.showAlert();
            Scrollable.ensureVisible(dtTruckGo.controller.formKey.currentContext!);
            return false;
        }

        if (dtTruckCome.controller.textSelected.value.isEmpty) {
            dtTruckCome.controller.showAlert();
            Scrollable.ensureVisible(dtTruckCome.controller.formKey.currentContext!);
            return false;
        }

        if (dtFinishDoc.controller.textSelected.value.isEmpty) {
            dtFinishDoc.controller.showAlert();
            Scrollable.ensureVisible(dtFinishDoc.controller.formKey.currentContext!);
            return false;
        }

        if (mediaListDoc.isEmpty) {
            mfFormDOC.controller.showAlert();
            Scrollable.ensureVisible(mfFormDOC.controller.formKey.currentContext!);
            return false;
        }

        if (mediaListSuratJalan.isEmpty) {
            mfSuratJalan.controller.showAlert();
            Scrollable.ensureVisible(mfSuratJalan.controller.formKey.currentContext!);
            return false;
        }
        return true;
    }

    _showBottomDialog() {
        return showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: Get.context!,
            builder: (context) => Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                    ),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 60,
                            height: 4,
                            decoration: BoxDecoration(
                                color: GlobalVar.outlineColor,
                                borderRadius: BorderRadius.circular(2),
                            ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                            child: Text("Apakah kamu yakin data yang dimasukan sudah benar?", style: GlobalVar.primaryTextStyle.copyWith(fontSize: 21, fontWeight: GlobalVar.bold))
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Populasi", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text("${efReceiveDoc.getInput()} Ekor", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Lebihan DOC", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text("${efMoreDOC.getInput()} Ekor", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("BW", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text("${efBw.getInput()} gr", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Uniformity", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text("${efUniform.getInput()} %", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Jam Truck Berangkat", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text(DateFormat("HH:mm").format(dtTruckGo.getLastTimeSelected()), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Jam Truck Tiba", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text(DateFormat("HH:mm").format(dtTruckCome.getLastTimeSelected()), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Selesai DOC In", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text(DateFormat("dd/MM/yyyy - HH:mm").format(dtFinishDoc.getLastTimeSelected()), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ],
                                    ),
                                    const SizedBox(height: 8,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text("Awal Recording", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                            Text(dateDoc.value, style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold),)
                                        ]
                                    )
                                ]
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(child: btYakin),
                                    const SizedBox(width: 16),
                                    Expanded(child: btTidakYakin)
                                ]
                            )
                        ),
                        const SizedBox(height: GlobalVar.bottomSheetMargin)
                    ]
                )
            )
        );
    }

    void addChickin() {
        AuthImpl().get().then((auth) {
            isLoading.value = false;
            if (auth != null) {
                RequestChickin bodyPayload = generatePayload();
                Service.push(
                    apiKey: "productReportApi",
                    service: ListApi.updateRequestChickin,
                    context: context,
                    body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetRequestDocByFarmingId(coop.farmingCycleId!), Mapper.asJsonString(bodyPayload)],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.off(TransactionSuccessActivity(
                                keyPage: "docInSaved",
                                message: "Selamat kamu sudah selesai melakukan chickin",
                                showButtonHome: false,
                                showButtonShare: true,
                                onTapClose: () => Get.back(result: true),
                                onTapHome: () {},
                                onTapShare: () async {
                                    String text = 'DOC-in Kawan Pitik\n\n';
                                    text += 'Cabang : ${coop.coopCity}\n';
                                    text += 'Kandang : ${coop.coopName}\n';
                                    text += 'Populasi : ${bodyPayload.initialPopulation ?? '-'} Ekor\n';
                                    text += 'BW : ${bodyPayload.bw ?? '-'} gr\n';
                                    text += 'Uniformity : ${bodyPayload.uniformity ?? '-'} %\n';
                                    text += 'Jam truk berangkat : ${bodyPayload.truckLeaving ?? '-'}\n';
                                    text += 'Jam truk tiba : ${bodyPayload.truckArrival ?? '-'}\n';
                                    text += 'Selesai DOC In : ${bodyPayload.finishChickIn ?? '-'}\n';

                                    Share.share(text);
                                },
                            ));
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar(
                                "Pesan",
                                "Terjadi Kesalahan Internal",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.red
                            );
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            } else{
                GlobalVar.invalidResponse();
            }
        });
    }

    RequestChickin generatePayload() {
        RequestChickin requestChickin = RequestChickin();
        requestChickin.poCode = proc.value.poCode;
        requestChickin.erpCode = proc.value.erpCode;
        requestChickin.startDate = DateFormat("yyyy-MM-dd").format(dtTanggal.getLastTimeSelected());
        requestChickin.initialPopulation = (efReceiveDoc.getInputNumber()??0).toInt();
        requestChickin.additionalPopulation = (efMoreDOC.getInputNumber()??0).toInt();
        requestChickin.bw = (efBw.getInputNumber()??0).toInt();
        requestChickin.uniformity = (efUniform.getInputNumber()??0).toInt();
        requestChickin.truckLeaving = DateFormat("yyyy-MM-dd HH:mm:ss").format(dtTruckGo.getLastTimeSelected());
        requestChickin.truckArrival = DateFormat("yyyy-MM-dd HH:mm:ss").format(dtTruckCome.getLastTimeSelected());
        requestChickin.finishChickIn = DateFormat("yyyy-MM-dd HH:mm:ss").format(dtFinishDoc.getLastTimeSelected());
        requestChickin.remarks = efDesc.getInput();
        requestChickin.suratJalanPhotos = mediaListSuratJalan;
        requestChickin.docInFormPhotos = mediaListDoc;
        requestChickin.photos = mediaListLainnya;
        return requestChickin;
    }
}

class DocInBindings extends Bindings {
    BuildContext context;
    DocInBindings({required this.context});

    @override
    void dependencies() => Get.lazyPut(() => DocInController(context: context));
}
