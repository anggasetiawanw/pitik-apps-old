
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
import 'package:model/auth_model.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/media_upload_model.dart';
import 'package:model/realization_model.dart';
import 'package:model/realization_record_model.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_realization/bundle/harvest_realization_bundle.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/11/2023

class HarvestRealizationFormController extends GetxController {
    BuildContext context;
    HarvestRealizationFormController({required this.context});

    late HarvestRealizationBundle bundle;

    late DateTimeField harvestDateField;
    late DateTimeField harvestHourField;
    late DateTimeField ongoingHourField;
    late EditField driverNameField;
    late EditField truckPlateField;
    late EditField weighingNumberField;
    late EditField totalChickenField;
    late EditField tonnageField;
    late EditField averageWeightField;
    late MediaField weightMediaField;

    var isLoading = false.obs;
    var isLoadingPicture = false.obs;

    RxList<MediaUploadModel?> weighingMediaList = <MediaUploadModel?>[].obs;

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_form_realisasi_page');
        bundle = Get.arguments;

        _fillRealizationData();
    }

    void _fillRealizationData() {
        harvestDateField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("harvestRealizationDate"),
            flag: DateTimeField.DATE_FLAG,
            label: "Tanggal Tangkap",
            hint: "20/03/2022",
            alertText: "Oops tanggal tangkap belum dipilih",
            onDateTimeSelected: (dateTime, field) => field.controller.setTextSelected('${Convert.getYear(dateTime)}-${Convert.getMonthNumber(dateTime)}-${Convert.getDay(dateTime)}')
        );

        harvestHourField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("harvestRealizationHour"),
            flag: DateTimeField.TIME_FLAG,
            label: "Jam Tangkap",
            hint: "Pilih disini",
            alertText: "Oops jam tangkap belum dipilih",
            onDateTimeSelected: (dateTime, field) => field.controller.setTextSelected('${Convert.getHour(dateTime)}:${Convert.getMinute(dateTime)}')
        );

        ongoingHourField = DateTimeField(
            controller: GetXCreator.putDateTimeFieldController("harvestRealizationOngoing"),
            flag: DateTimeField.TIME_FLAG,
            label: "Jam Berangkat",
            hint: "Pilih disini",
            alertText: "Oops jam berangkat belum dipilih",
            onDateTimeSelected: (dateTime, field) => field.controller.setTextSelected('${Convert.getHour(dateTime)}:${Convert.getMinute(dateTime)}')
        );

        driverNameField = EditField(
            controller: GetXCreator.putEditFieldController("harvestRealizationDriverName"),
            label: "Nama Sopir",
            hint: "Ketik disini",
            alertText: "Oops nama sopir belum diisi",
            textUnit: "",
            maxInput: 100,
            onTyping: (text, field) {}
        );

        truckPlateField = EditField(
            controller: GetXCreator.putEditFieldController("harvestRealizationTruckPlate"),
            label: "Nopol Kendaraan",
            hint: "Ketik disini",
            alertText: "Oops nopol kendaraan belum diisi",
            textUnit: "",
            maxInput: 15,
            onTyping: (text, field) {}
        );

        weighingNumberField = EditField(
            controller: GetXCreator.putEditFieldController("harvestRealizationWeighingNumber"),
            label: "No. Data Timbang",
            hint: "Ketik disini",
            alertText: "Oops No. Data Timbang belum diisi",
            textUnit: "",
            maxInput: 100,
            onTyping: (text, field) {}
        );

        totalChickenField = EditField(
            controller: GetXCreator.putEditFieldController("harvestRealizationTotalChicken"),
            label: "Jumlah Ayam",
            hint: "Ketik disini",
            alertText: "Oops jumlah ayam belum diisi",
            textUnit: "Ekor",
            maxInput: 100,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        tonnageField = EditField(
            controller: GetXCreator.putEditFieldController("harvestRealizationTonase"),
            label: "Total Tonase",
            hint: "Ketik disini",
            alertText: "Oops total tonase belum diisi",
            textUnit: "Kg",
            maxInput: 100,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        averageWeightField = EditField(
            controller: GetXCreator.putEditFieldController("harvestRealizationAverageWeight"),
            label: "Berat Rata-rata",
            hint: "Ketik disini",
            alertText: "Oops berat rata-rata belum diisi",
            textUnit: "Gr",
            maxInput: 100,
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );

        weightMediaField = MediaField(
            controller: GetXCreator.putMediaFieldController("harvestRealizationMedia"),
            type: MediaField.PHOTO,
            label: "Upload data timbang",
            hideLabel: true,
            hint: "Upload data timbang",
            alertText: "Data timbang masih kosong",
            onMediaResult: (media) => AuthImpl().get().then((auth) {
                if (auth != null) {
                    if (media != null) {
                        isLoadingPicture.value = true;
                        Service.push(
                            service: ListApi.uploadImage,
                            context: Get.context!,
                            body: ['Bearer ${auth.token}', auth.id, "harvest-records", media],
                            listener: ResponseListener(
                                onResponseDone: (code, message, body, id, packet) {
                                    weighingMediaList.clear();
                                    weighingMediaList.add(body.data);
                                    weightMediaField.getController().setInformasiText("File telah terupload");
                                    weightMediaField.getController().showInformation();
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

        if (bundle.getRealization != null) {
            harvestDateField.controller.setTextSelected(bundle.getRealization!.harvestDate ?? '');
            harvestHourField.controller.setTextSelected(bundle.getRealization!.weighingTime ?? '');
            ongoingHourField.controller.setTextSelected(bundle.getRealization!.truckDepartingTime ?? '');
            driverNameField.setInput(bundle.getRealization!.driver ?? '');
            truckPlateField.setInput(bundle.getRealization!.truckLicensePlate ?? '');

            weighingNumberField.setInput(bundle.getRealization!.records.isNotEmpty && bundle.getRealization!.records[0] != null ? bundle.getRealization!.records[0]!.weighingNumber ?? '' : '');
            totalChickenField.setInput('${bundle.getRealization!.quantity ?? ''}');
            tonnageField.setInput('${bundle.getRealization!.tonnage ?? ''}');
            averageWeightField.setInput('${bundle.getRealization!.averageChickenWeighed ?? ''}');

            for (var record in bundle.getRealization!.records) {
                weighingMediaList.add(MediaUploadModel(url: record?.image));
            }

            if (weighingMediaList.isNotEmpty) {
                weightMediaField.getController().setInformasiText("File telah terupload");
                weightMediaField.getController().showInformation();
                weightMediaField.getController().setFileName(bundle.getRealization!.weighingNumber ?? '');
            }
        } else {
            harvestDateField.controller.setTextSelected(bundle.getHarvest!.dateHarvest ?? '');
            truckPlateField.setInput(bundle.getHarvest!.truckLicensePlate ?? '');
        }
    }

    Widget getRealizationStatusWidget({required String statusText}) {
        Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryLight2 :
                           statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                           statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.greenBackground:
                           statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE ? GlobalVar.blueBackground :
                           Colors.white;

        Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryOrange :
                          statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.red :
                          statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.green:
                          statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE ? GlobalVar.blue :
                          Colors.white;

        return Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                color: background
            ),
            child: Text(
                statusText,
                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: textColor)
            ),
        );
    }

    String getDeliveryOrder() {
        if (bundle.getRealization != null) {
            return bundle.getRealization!.deliveryOrder ?? '-';
        } else if (bundle.getHarvest != null) {
            return bundle.getHarvest!.deliveryOrder ?? '-';
        } else {
            return '-';
        }
    }

    String getBakulName() {
        if (bundle.getRealization != null) {
            return bundle.getRealization!.bakulName ?? '-';
        } else if (bundle.getHarvest != null) {
            return bundle.getHarvest!.bakulName ?? '-';
        } else {
            return '-';
        }
    }

    String getBwText() {
        if (bundle.getRealization != null) {
            return '${bundle.getRealization!.minWeight == null ? '-' : bundle.getRealization!.minWeight!.toStringAsFixed(1)} Kg '
                   's.d '
                   '${bundle.getRealization!.maxWeight == null ? '-' : bundle.getRealization!.maxWeight!.toStringAsFixed(1)} Kg';
        } else if (bundle.getHarvest != null) {
            return '${bundle.getHarvest!.minWeight == null ? '-' : bundle.getHarvest!.minWeight!.toStringAsFixed(1)} Kg '
                   's.d '
                   '${bundle.getHarvest!.maxWeight == null ? '-' : bundle.getHarvest!.maxWeight!.toStringAsFixed(1)} Kg';
        } else {
            return '-';
        }
    }

    String getQuantityText() {
        if (bundle.getRealization != null) {
            return '${bundle.getRealization!.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(bundle.getRealization!.quantity.toString(), '', '.')} Ekor';
        } else if (bundle.getHarvest != null) {
            return '${bundle.getHarvest!.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(bundle.getHarvest!.quantity.toString(), '', '.')} Ekor';
        } else {
            return '-';
        }
    }

    bool _validation() {
        bool isPass = true;

        if (harvestDateField.getLastTimeSelectedText().isEmpty) {
            harvestDateField.controller.showAlert();
            isPass  = false;
        }
        if (harvestHourField.getLastTimeSelectedText().isEmpty) {
            harvestHourField.controller.showAlert();
            isPass  = false;
        }
        if (ongoingHourField.getLastTimeSelectedText().isEmpty) {
            ongoingHourField.controller.showAlert();
            isPass = false;
        }
        if (driverNameField.getInput().isEmpty) {
            driverNameField.controller.showAlert();
            isPass = false;
        }
        if (truckPlateField.getInput().isEmpty) {
            truckPlateField.controller.showAlert();
            isPass = false;
        }
        if (weighingNumberField.getInput().isEmpty) {
            weighingNumberField.controller.showAlert();
            isPass = false;
        }
        if (tonnageField.getInput().isEmpty) {
            tonnageField.controller.showAlert();
            isPass = false;
        }
        if (totalChickenField.getInput().isEmpty) {
            totalChickenField.controller.showAlert();
            isPass = false;
        }
        if (averageWeightField.getInput().isEmpty) {
            averageWeightField.controller.showAlert();
            isPass = false;
        }
        if (weighingMediaList.isEmpty) {
            weightMediaField.controller.showAlert();
            isPass = false;
        }

        return isPass;
    }

    void _pushHarvestRealizationToServer(Auth auth) {
        isLoading.value = true;

        String route = bundle.getRealization == null ? ListApi.saveHarvestRealization : ListApi.updateHarvestRealization;
        List<dynamic> bodyRequest = ['Bearer ${auth.token}', auth.id];
        if (bundle.getRealization != null) {
            bodyRequest.add('v2/harvest-realizations/${bundle.getRealization!.id}');
        } else {
            bundle.getRealization = Realization(
                harvestRequestId: bundle.getHarvest?.harvestRequestId,
                harvestDealId: bundle.getHarvest?.id,
                deliveryOrder: bundle.getHarvest?.deliveryOrder,
                bakulName: bundle.getHarvest?.bakulName,
            );
        }

        bundle.getRealization!.farmingCycleId = bundle.getCoop.farmingCycleId;
        bundle.getRealization!.harvestDate = harvestDateField.getLastTimeSelectedText();
        bundle.getRealization!.weighingTime = '${harvestHourField.getLastTimeSelectedText()}:00';
        bundle.getRealization!.truckDepartingTime = '${ongoingHourField.getLastTimeSelectedText()}:00';
        bundle.getRealization!.driver = driverNameField.getInput();
        bundle.getRealization!.truckLicensePlate = truckPlateField.getInput();

        RealizationRecord realizationRecord = RealizationRecord(
            weighingNumber: weighingNumberField.getInput(),
            tonnage: tonnageField.getInputNumber(),
            quantity: totalChickenField.getInputNumber() != null ? totalChickenField.getInputNumber()!.toInt() : null,
            averageWeight: averageWeightField.getInputNumber(),
            image: weighingMediaList[0]?.url
        );
        bundle.getRealization!.records = [realizationRecord];
        bundle.getRealization!.additionalRequests = [];
        bodyRequest.add(Mapper.asJsonString(bundle.getRealization));

        Service.push(
            apiKey: 'harvestApi',
            service: route,
            context: Get.context!,
            body: bodyRequest,
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet) {
                    isLoading.value = false;
                    GlobalVar.track('Open_success_realisasi_panen_page');
                    Get.to(TransactionSuccessActivity(
                        keyPage: "harvestRealizationSubmitSuccess",
                        message: bundle.getRealization == null ? "Kamu telah berhasil melakukan realisasi panen" : "Kamu telah berhasil mengubah data realisasi panen",
                        showButtonHome: false,
                        onTapClose: () => Get.back(result: true),
                        onTapHome: () {}
                    ))!.then((value) => Get.back());
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

                    isLoading.value = false;
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

                    isLoading.value = false;
                },
                onTokenInvalid: () => GlobalVar.invalidResponse()
            )
        );
    }

    void saveOrUpdateHarvestRealization() => AuthImpl().get().then((auth) {
        if (auth != null) {
            if (_validation()) {
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
                                        Text('Data Timbang', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Tanggal Tangkap', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(harvestDateField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jam Tangkap', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(harvestHourField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jam Berangkat', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(ongoingHourField.getLastTimeSelectedText(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Nama Sopir', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(driverNameField.getInput(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Nopol Kendaraan', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(truckPlateField.getInput(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        ),
                                        const SizedBox(height: 16),
                                        const Divider(height: 1.4, color: GlobalVar.outlineColor),
                                        const SizedBox(height: 16),
                                        Text('Kartu Timbang', style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.bold)),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Nomor Data Timbang', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(weighingNumberField.getInput(), style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium))
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Jumlah Ayam', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(
                                                    totalChickenField.getInputNumber() != null ? '${Convert.toCurrencyWithoutDecimal(totalChickenField.getInputNumber()!.toString(), '', '.')} Ekor' : '-',
                                                    style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                )
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Total Tonase', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(
                                                    tonnageField.getInputNumber() != null ? '${Convert.toCurrencyWithDecimalAndPrecision(tonnageField.getInputNumber()!.toString(), '', '.', ',', 1)} Kg' : '-',
                                                    style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                )
                                            ]
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('Berat Rata-rata', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                                Text(
                                                    averageWeightField.getInputNumber() != null ? '${Convert.toCurrencyWithDecimalAndPrecision(averageWeightField.getInputNumber()!.toString(), '', '.', ',', 1)} Kg' : '-',
                                                    style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.medium)
                                                )
                                            ]
                                        ),
                                        const SizedBox(height: 32),
                                        SizedBox(
                                            width: MediaQuery.of(Get.context!).size.width - 32,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(
                                                        child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSubmitHarvestRealization"), label: "Yakin", onClick: () {
                                                            Navigator.pop(Get.context!);
                                                            _pushHarvestRealizationToServer(auth);
                                                        })
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnCancelHarvestRealization"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!)))
                                                ]
                                            )
                                        ),
                                        const SizedBox(height: 32)
                                    ]
                                )
                            )
                        )
                    )
                );
            }
        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class HarvestRealizationFormBinding extends Bindings {
    BuildContext context;
    HarvestRealizationFormBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestRealizationFormController>(() => HarvestRealizationFormController(context: context));
}