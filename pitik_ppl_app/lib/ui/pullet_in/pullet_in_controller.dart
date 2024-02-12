
import 'dart:io';

import 'package:common_page/transaction_success_activity.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
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
import 'package:model/request_chickin.dart';
import 'package:model/response/internal_app/media_upload_response.dart';
import 'package:model/response/request_chickin_response.dart';
import 'package:share_plus/share_plus.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 05/10/2023

class PulletInController extends GetxController {
    BuildContext context;
    PulletInController({required this.context});

    late Coop coop;

    var isLoading = false.obs;
    var isLoadingSuratJalan = false.obs;
    var isLoadingFormPulletIn = false.obs;
    var isLoadingAnotherPullet = false.obs;
    var isAlreadySubmit = false.obs;

    Rx<RequestChickin?> request = RequestChickin().obs;
    RxList<MediaUploadModel?> mediaListPulletIn = <MediaUploadModel?>[].obs;
    RxList<MediaUploadModel?> mediaListSuratJalan = <MediaUploadModel?>[].obs;
    RxList<MediaUploadModel?> mediaListLainnya = <MediaUploadModel?>[].obs;

    DateTimeField dtTanggal = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("pulletInTanggal"),
        flag: DateTimeField.DATE_FLAG,
        label: "Tanggal",
        hint: "yyyy-MM-dd",
        alertText: "",
        onDateTimeSelected: (time, dateField) => '${Convert.getYear(time)}-${Convert.getMonthNumber(time)}-${Convert.getDay(time)}'
    );

    EditField efPopulation = EditField(
        controller: GetXCreator.putEditFieldController("pulletInPopulation"),
        label: "Populasi",
        hint: "",
        alertText: "",
        textUnit: "Ekor",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {}
    );

    EditField efAge = EditField(
        controller: GetXCreator.putEditFieldController("pulletInAge"),
        label: "Umur",
        hint: "",
        alertText: "",
        textUnit: "Minggu",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {}
    );

    EditField efBw = EditField(
        controller: GetXCreator.putEditFieldController("pulletInBw"),
        label: "BW",
        hint: "BW",
        alertText: "Harus diisi..!",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {}
    );

    EditField efUniform = EditField(
        controller: GetXCreator.putEditFieldController("pulletInUniform"),
        label: "Uniformity",
        hint: "Uniformity",
        alertText: "Harus diisi..!",
        textUnit: "%",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, control) {}
    );

    DateTimeField dtTruckGo = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("pulletInTruckGo"),
        label: "Jam Truck Berangkat",
        hint: "08:00",
        alertText: "Harus diisi..!",
        onDateTimeSelected: (time, dateField) => dateField.controller.setTextSelected('${Convert.getHour(time)}:${Convert.getMinute(time)}:${Convert.getSecond(time)}')
    );

    DateTimeField dtTruckCome = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("pulletInTruckCome"),
        label: "Jam Truck Tiba",
        hint: "12:00",
        alertText: "Harus diisi..!",
        onDateTimeSelected: (time, dateField) => dateField.controller.setTextSelected('${Convert.getHour(time)}:${Convert.getMinute(time)}:${Convert.getSecond(time)}')
    );

    DateTimeField dtFinishPulletIn = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("pulletInFinishPullet"),
        label: "Selesai Pullet In",
        hint: "04/06/2023 - 12:00",
        alertText: "Harus diisi..!",
        onDateTimeSelected: (time, dateField) => dateField.controller.setTextSelected('${Convert.getYear(time)}-${Convert.getMonthNumber(time)}-${Convert.getDay(time)} ${Convert.getHour(time)}:${Convert.getMinute(time)}:${Convert.getSecond(time)}')
    );

    EditAreaField eaDesc = EditAreaField(
        controller: GetXCreator.putEditAreaFieldController("pulletInDesc"),
        label: "Keterangan",
        hint: "Keterangan",
        alertText: "",
        textUnit: "",
        maxInput: 500,
        onTyping: (value, editField) {}
    );

    late MediaField mfSuratJalan = MediaField(
        controller: GetXCreator.putMediaFieldController("pulletInSuratJalan"),
        label: "Upload Surat Jalan",
        hint: "",
        alertText: "Harus menyertakan media foto",
        showGalleryOptions: true,
        type: MediaField.PHOTO,
        onMediaResult: (file) {
            if (file != null) {
                uploadFile(file, "pulletInSuratJalan");
            }
        },
    );

    late MediaField mfFormPullet = MediaField(
        controller: GetXCreator.putMediaFieldController("pulletInFormPullet"),
        label: "Upload Form Pullet In",
        hint: "",
        alertText: "Harus menyertakan media foto",
        showGalleryOptions: true,
        type: MediaField.PHOTO,
        onMediaResult: (file) {
            if (file != null) {
                uploadFile(file, "pulletInFormPullet");
            }
        },
    );

    late MediaField mfAnotherPullet = MediaField(
        controller: GetXCreator.putMediaFieldController("pulletInAnotherPullet"),
        label: "Upload Dokumen Lainnya",
        hint: "",
        alertText: "",
        showGalleryOptions: true,
        type: MediaField.PHOTO,
        onMediaResult: (file) {
            if (file != null) {
                uploadFile(file, "pulletInAnotherPullet");
            }
        },
    );

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_PulletIn_form_active');
        coop = Get.arguments[0];

        // disable some field init
        dtTanggal.controller.disable();
        efAge.controller.disable();
    }

    @override
    void onReady() {
        super.onReady();
        getRequestDoc();
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

                            if (body.data != null) {
                                dtTanggal.controller.setTextSelected(Convert.getDate(body.data!.startDate ?? ""));
                                efPopulation.setInput('${body.data!.initialPopulation ?? ''}');
                                efAge.setInput('${body.data!.pulletInWeeks ?? ''}');
                            }

                            setDetailForm((body).data!);
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


        efBw.setInput((request.bw ?? 0).toString());
        efUniform.setInput((request.uniformity ?? 0).toString());
        dtTruckGo.controller.setTextSelected(truckGo);
        dtTruckCome.controller.setTextSelected(truckCome);
        dtFinishPulletIn.controller.setTextSelected(doneDocIn);
        eaDesc.setValue(request.remarks ?? '');

        if (request.hasFinishedDOCin != null && request.hasFinishedDOCin!) {
            efPopulation.controller.disable();
            efBw.controller.disable();
            efUniform.controller.disable();
            dtTruckGo.controller.disable();
            dtTruckCome.controller.disable();
            dtFinishPulletIn.controller.disable();
            eaDesc.controller.disable();
            mfAnotherPullet.controller.disable();
            mfFormPullet.controller.disable();
            mfSuratJalan.controller.disable();

            isAlreadySubmit.value = true;
        }
    }

    void uploadFile(File? file, String mediaField) {
        if (mediaField == "pulletInSuratJalan") {
            isLoadingSuratJalan.value = true;
        } else if (mediaField == "pulletInFormPullet") {
            isLoadingFormPulletIn.value = true;
        } else if (mediaField == "pulletInAnotherPullet") {
            isLoadingAnotherPullet.value = true;
        }

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

                            if (mediaField == "pulletInSuratJalan") {
                                mediaListSuratJalan.add(body.data);
                                mfSuratJalan.controller.setFileName(body.data!.url ?? '-');
                                mfSuratJalan.controller.setInformasiText("File telah terupload");
                                mfSuratJalan.controller.showInformation();
                                isLoadingSuratJalan.value = false;
                            } else if (mediaField == "pulletInFormPullet") {
                                mediaListPulletIn.add(body.data);
                                mfFormPullet.controller.setFileName(body.data!.url ?? '-');
                                mfFormPullet.controller.setInformasiText("File telah terupload");
                                mfFormPullet.controller.showInformation();
                                isLoadingFormPulletIn.value = false;
                            } else if (mediaField == "pulletInAnotherPullet") {
                                mediaListLainnya.add(body.data);
                                mfAnotherPullet.controller.setFileName(body.data!.url ?? '-');
                                mfAnotherPullet.controller.setInformasiText("File telah terupload");
                                mfAnotherPullet.controller.showInformation();
                                isLoadingAnotherPullet.value = false;
                            }
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

                            if (mediaField == "pulletInSuratJalan") {
                                mfSuratJalan.controller.hideInformation();
                                isLoadingSuratJalan.value = false;
                            } else if(mediaField == "pulletInFormPullet") {
                                mfFormPullet.controller.hideInformation();
                                isLoadingFormPulletIn.value = false;
                            } else if(mediaField == "pulletInAnotherPullet") {
                                mfAnotherPullet.controller.hideInformation();
                                isLoadingAnotherPullet.value = false;
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

                            if (mediaField == "mfSuratJalan") {
                                mfSuratJalan.controller.hideInformation();
                                isLoadingSuratJalan.value = false;
                            } else if (mediaField == "mfFormDOC") {
                                mfFormPullet.controller.hideInformation();
                                isLoadingFormPulletIn.value = false;
                            } else if (mediaField == "mfAnotherDoc") {
                                mfAnotherPullet.controller.hideInformation();
                                isLoadingAnotherPullet.value = false;
                            }
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                )
            } else {
                GlobalVar.invalidResponse()
            }
        });
    }

    void submitPulletIn() {
        if (isValid()) {
            _showBottomDialog();
        }
    }

    bool isValid() {
        if (dtTanggal.controller.textSelected.value.isEmpty) {
            dtTanggal.controller.showAlert();
            Scrollable.ensureVisible(dtTanggal.controller.formKey.currentContext!);
            return false;
        }

        if (efPopulation.getInput().isEmpty) {
            efPopulation.controller.showAlert();
            Scrollable.ensureVisible(efPopulation.controller.formKey.currentContext!);
            return false;
        }

        if (efAge.getInput().isEmpty) {
            efAge.controller.showAlert();
            Scrollable.ensureVisible(efAge.controller.formKey.currentContext!);
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

        if (dtFinishPulletIn.controller.textSelected.value.isEmpty) {
            dtFinishPulletIn.controller.showAlert();
            Scrollable.ensureVisible(dtFinishPulletIn.controller.formKey.currentContext!);
            return false;
        }

        if (mediaListPulletIn.isEmpty) {
            mfFormPullet.controller.showAlert();
            Scrollable.ensureVisible(mfFormPullet.controller.formKey.currentContext!);
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
            builder: (context) => ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                child: Container(
                    color: Colors.white,
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
                                                Text("Tanggal Pullet In", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text(dtTanggal.getLastTimeSelectedText(), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Populasi", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text("${efPopulation.getInput()} Ekor", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Umur", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text("${efAge.getInput()} Minggu", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("BW", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text("${efBw.getInput()} gr", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Uniformity", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text("${efUniform.getInput()} %", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Jam Truck Berangkat", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text(dtTruckGo.getLastTimeSelectedText(), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Jam Truck Tiba", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12)),
                                                Text(dtTruckCome.getLastTimeSelectedText(), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text("Selesai Pullet In", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),
                                                Text(dtFinishPulletIn.getLastTimeSelectedText(), style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold))
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
                                        Expanded(
                                            child: ButtonFill(controller: GetXCreator.putButtonFillController("btnAgreePulletIn"), label: "Yakin", onClick: () {
                                                Navigator.pop(Get.context!);
                                                AuthImpl().get().then((auth) {
                                                    if (auth != null) {
                                                        isLoading.value = true;
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
                                                                        keyPage: "pulletInSaved",
                                                                        message: "Selamat kamu sudah selesai melakukan Pullet in",
                                                                        showButtonHome: false,
                                                                        showButtonShare: true,
                                                                        onTapClose: () => Get.back(result: true),
                                                                        onTapHome: () {},
                                                                        onTapShare: () async {
                                                                            String text = 'Pullet In Kawan Pitik\n\n';
                                                                            text += 'Cabang : ${coop.coopCity}\n';
                                                                            text += 'Kandang : ${coop.coopName}\n';
                                                                            text += 'Populasi : ${bodyPayload.initialPopulation ?? '-'} Ekor\n';
                                                                            text += 'Umur : ${bodyPayload.pulletInWeeks ?? '-'} Minggu\n';
                                                                            text += 'Pullet Strain : ${request.value!.chickType != null ? request.value!.chickType!.name ?? '-' : '-'}\n';
                                                                            text += 'BW : ${bodyPayload.bw ?? '-'} gr\n';
                                                                            text += 'Uniformity : ${bodyPayload.uniformity ?? '-'} %\n';
                                                                            text += 'Jam truk berangkat : ${bodyPayload.truckLeaving ?? '-'}\n';
                                                                            text += 'Jam truk tiba : ${bodyPayload.truckArrival ?? '-'}\n';
                                                                            text += 'Selesai Pullet In : ${bodyPayload.finishChickIn ?? '-'}\n';

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
                                                    } else {
                                                        GlobalVar.invalidResponse();
                                                    }
                                                });
                                            }),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnNotAgreePulletIn"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!)))
                                    ]
                                )
                            ),
                            const SizedBox(height: GlobalVar.bottomSheetMargin)
                        ]
                    )
                ),
            )
        );
    }

    RequestChickin generatePayload() {
        RequestChickin requestChickin = RequestChickin();
        if (request.value != null) {
            requestChickin.poCode = request.value!.poCode;
            requestChickin.erpCode = request.value!.erpCode;
        }
        requestChickin.startDate = dtTanggal.getLastTimeSelectedText();
        requestChickin.initialPopulation = (efPopulation.getInputNumber() ?? 0).toInt();
        requestChickin.pulletInWeeks = (efAge.getInputNumber() ?? 0).toInt();
        requestChickin.additionalPopulation = 0;
        requestChickin.bw = (efBw.getInputNumber() ?? 0).toInt();
        requestChickin.uniformity = (efUniform.getInputNumber() ?? 0).toInt();
        requestChickin.truckLeaving = dtTruckGo.getLastTimeSelectedText();
        requestChickin.truckArrival = dtTruckCome.getLastTimeSelectedText();
        requestChickin.finishChickIn = dtFinishPulletIn.getLastTimeSelectedText();
        requestChickin.remarks = eaDesc.getInput();
        requestChickin.suratJalanPhotos = mediaListSuratJalan;
        requestChickin.pulletInFormPhotos = mediaListPulletIn;
        requestChickin.photos = mediaListLainnya;

        return requestChickin;
    }
}

class PulletInBinding extends Bindings {
    BuildContext context;
    PulletInBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<PulletInController>(() => PulletInController(context: context));
}