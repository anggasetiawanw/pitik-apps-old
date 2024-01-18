
import 'dart:io';

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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/request_chickin.dart';
import 'package:model/response/request_chickin_response.dart';

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
        onDateTimeSelected: (time, dateField) => '${Convert.getHour(time)}:${Convert.getMinute(time)}:${Convert.getSecond(time)}'
    );

    DateTimeField dtTruckCome = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController("pulletInTruckCome"),
        label: "Jam Truck Tiba",
        hint: "12:00",
        alertText: "Harus diisi..!",
        onDateTimeSelected: (time, dateField) => '${Convert.getHour(time)}:${Convert.getMinute(time)}:${Convert.getSecond(time)}'
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
        multi: true,
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
        multi: true,
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
        multi: true,
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
        efPopulation.controller.disable();
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

        efBw.setInput((request.bw ?? 0).toString());
        efBw.controller.disable();

        efUniform.setInput((request.uniformity ?? 0).toString());
        efUniform.controller.disable();

        dtTruckGo.controller.setTextSelected(truckGo);
        dtTruckGo.controller.disable();

        dtTruckCome.controller.setTextSelected(truckCome);
        dtTruckCome.controller.disable();

        dtFinishPulletIn.controller.setTextSelected(doneDocIn);
        dtFinishPulletIn.controller.disable();

        eaDesc.setValue(request.remarks ?? '');
        eaDesc.controller.disable();

        mfAnotherPullet.controller.disable();
        mfFormPullet.controller.disable();
        mfSuratJalan.controller.disable();

        isAlreadySubmit.value = true;
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
                            if (mediaField == "pulletInSuratJalan") {
                                mediaListSuratJalan.add(body.data);
                                mfSuratJalan.controller.setInformasiText("File telah terupload");
                                mfSuratJalan.controller.showInformation();
                                isLoadingSuratJalan.value = false;
                            } else if (mediaField == "pulletInFormPullet") {
                                mediaListPulletIn.add(body.data);
                                mfFormPullet.controller.setInformasiText("File telah terupload");
                                mfFormPullet.controller.showInformation();
                                isLoadingFormPulletIn.value = false;
                            } else if (mediaField == "pulletInAnotherPullet") {
                                mediaListLainnya.add(body.data);
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

    void submitPulletIn() => AuthImpl().get().then((auth) {
        if (auth != null) {

        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class PulletInBinding extends Bindings {
    BuildContext context;
    PulletInBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<PulletInController>(() => PulletInController(context: context));
}