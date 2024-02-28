import 'package:common_page/library/component_library.dart';
import 'package:common_page/smart_scale/bundle/smart_scale_weighing_bundle.dart';
import 'package:common_page/smart_scale/weighing_smart_scale/smart_scale_weighing.dart';
import 'package:common_page/transaction_success_activity.dart';
import 'package:components/date_time_field/datetime_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/global_var.dart';
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
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:model/realization_record_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/12/2023

class SmartScaleHarvestFormController extends GetxController {
  BuildContext context;
  SmartScaleHarvestFormController({required this.context});

  late Coop coop;
  late Harvest harvest;

  late EditField efWeighingNumber;
  late DateTimeField dtfHarvestedDate;
  late EditField efCoopName;
  late EditField efAddress;
  late DateTimeField dtfHarvestedTime;
  late DateTimeField dtfOngoingTime;
  late EditField efBakulName;
  late EditField efDriverName;
  late EditField efPlateNumber;
  late EditField efWitnessName;
  late EditField efReceiverName;
  late EditField efWeighersName;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    harvest = Get.arguments[1];

    efWeighingNumber = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormWeighingNumber'), label: 'No. Timbang', hint: '', alertText: '', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    dtfHarvestedDate = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController('smartScaleHarvestFormHarvestedDate'),
        label: 'Tanggal Tangkap',
        hint: '2022-08-25',
        alertText: 'Harus Diisi..!',
        flag: DateTimeField.DATE_FLAG,
        onDateTimeSelected: (date, field) => field.controller.setTextSelected('${Convert.getYear(date)}-${Convert.getMonth(date)}-${Convert.getDay(date)}'));
    efCoopName = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormCoopName'), label: 'Nama Kandang', hint: '', alertText: '', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    efAddress = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormAddress'), label: 'Alamat', hint: '', alertText: '', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    dtfHarvestedTime = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController('smartScaleHarvestFormHarvestedTime'),
        label: 'Jam Tangkap',
        hint: 'Ketik disini',
        alertText: 'Harus Diisi..!',
        flag: DateTimeField.TIME_FLAG,
        onDateTimeSelected: (date, field) => field.controller.setTextSelected('${Convert.getHour(date)}:${Convert.getMinute(date)}:${Convert.getSecond(date)}'));
    dtfOngoingTime = DateTimeField(
        controller: GetXCreator.putDateTimeFieldController('smartScaleHarvestFormOngoingTime'),
        label: 'Jam Berangkaat',
        hint: 'Ketik disini',
        alertText: 'Harus Diisi..!',
        flag: DateTimeField.TIME_FLAG,
        onDateTimeSelected: (date, field) => field.controller.setTextSelected('${Convert.getHour(date)}:${Convert.getMinute(date)}:${Convert.getSecond(date)}'));
    efBakulName = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormBakulName'), label: 'Bakul', hint: 'Ketik disini', alertText: 'Harus Diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    efDriverName = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormDriverName'), label: 'Nama Sopir', hint: 'Ketik disini', alertText: 'Harus Diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    efPlateNumber = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormPlateNumber'), label: 'Nopol Kendaraan', hint: 'Ketik disini', alertText: 'Harus Diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    efWitnessName = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormWitnessName'), label: 'Diketahui Oleh', hint: 'Ketik disini', alertText: 'Harus Diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    efReceiverName = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormReceiverName'), label: 'Diterima Oleh', hint: 'Ketik disini', alertText: 'Harus Diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});
    efWeighersName = EditField(controller: GetXCreator.putEditFieldController('smartScaleHarvestFormWeighersName'), label: 'Ditimbang Oleh', hint: 'Ketik disini', alertText: 'Harus Diisi..!', textUnit: '', maxInput: 100, onTyping: (text, field) {});

    dtfHarvestedDate.controller.setTextSelected(harvest.datePlanned ?? '');
    efBakulName.setInput(harvest.bakulName ?? '');
    efPlateNumber.setInput(harvest.truckLicensePlate ?? '');

    efWeighingNumber.setInput(harvest.weighingNumber ?? '${harvest.branchCode}${harvest.seqNo}');
    efWeighingNumber.controller.disable();

    efCoopName.setInput(harvest.coopName ?? '');
    efCoopName.controller.disable();

    efAddress.setInput(harvest.addressName ?? '');
    efAddress.controller.disable();

    if (Get.arguments.length > 2) {
      dtfHarvestedTime.controller.setTextSelected(Get.arguments[2] ?? '');
      dtfOngoingTime.controller.setTextSelected(Get.arguments[3] ?? '');
      efDriverName.setInput(Get.arguments[4] ?? '');
      efWitnessName.setInput(Get.arguments[5] ?? '');
      efReceiverName.setInput(Get.arguments[6] ?? '');
      efWeighersName.setInput(Get.arguments[7] ?? '');
    }
  }

  String getBwText() => '${harvest.minWeight == null ? '-' : harvest.minWeight!.toStringAsFixed(1)} Kg s.d ${harvest.maxWeight == null ? '-' : harvest.maxWeight!.toStringAsFixed(1)} Kg';
  String getQuantityText() => '${harvest.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(harvest.quantity.toString(), '', '.')} Ekor';
  String getQuantityLeftOverText() => '${harvest.quantityLeftOver == null ? '-' : Convert.toCurrencyWithoutDecimal(harvest.quantityLeftOver.toString(), '', '.')} Ekor';

  Widget getSubmittedStatusWidget({required String statusText}) {
    final Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL
        ? GlobalVar.primaryLight2
        : statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT
            ? GlobalVar.redBackground
            : statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI
                ? GlobalVar.greenBackground
                : statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE
                    ? GlobalVar.blueBackground
                    : Colors.white;

    final Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL
        ? GlobalVar.primaryOrange
        : statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT
            ? GlobalVar.red
            : statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI
                ? GlobalVar.green
                : statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE
                    ? GlobalVar.blue
                    : Colors.white;

    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), color: background),
        child: Text(statusText, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: textColor)));
  }

  void submit() => AuthImpl().get().then((auth) {
        if (auth != null) {
          if (harvest.weighingNumber != null) {
            final Realization realization = Realization(
                id: harvest.id,
                deliveryOrder: harvest.deliveryOrder,
                weighingNumber: efWeighingNumber.getInput(),
                farmingCycleId: coop.farmingCycleId,
                harvestRequestId: harvest.id,
                bakulName: efBakulName.getInput(),
                harvestDate: dtfHarvestedDate.getLastTimeSelectedText(),
                weighingTime: dtfHarvestedTime.getLastTimeSelectedText(),
                truckDepartingTime: dtfOngoingTime.getLastTimeSelectedText(),
                driver: efDriverName.getInput(),
                truckLicensePlate: efPlateNumber.getInput(),
                witnessName: efWitnessName.getInput(),
                receiverName: efReceiverName.getInput(),
                weigherName: efWeighersName.getInput(),
                minWeight: harvest.minWeight,
                maxWeight: harvest.maxWeight);

            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.updateSmartScaleHarvest,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, 'v2/harvest-realizations/with-deal/${harvest.id}', Mapper.asJsonString(realization)],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                      isLoading.value = false;
                      Get.off(TransactionSuccessActivity(
                          keyPage: 'updateSmartScaleHarvest',
                          message: 'Kamu telah berhasil mengedit realisasi timbang',
                          showButtonHome: false,
                          icon: Image.asset(
                            'images/information_orange_icon.gif',
                            height: 200,
                            width: 200,
                          ),
                          onTapClose: () => Get.back(result: true),
                          onTapHome: () {}));
                    },
                    onResponseFail: (code, message, body, id, packet) {
                      Get.snackbar('Pesan', '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                      isLoading.value = false;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                      Get.snackbar('Pesan', exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                      isLoading.value = false;
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()));
          } else {
            Get.to(SmartScaleWeighingActivity(), arguments: [coop, _getSmartScaleWeighingBundle(coop: coop)]);
          }
        } else {
          GlobalVar.invalidResponse();
        }
      });

  SmartScaleWeighingBundle _getSmartScaleWeighingBundle({required Coop coop}) => SmartScaleWeighingBundle(
      routeSave: () => ListApi.saveSmartScaleHarvest,
      routeEdit: () => '',
      routeDetail: () => '',
      saveToDb: false,
      weighingNumber: efWeighingNumber.getInput(),
      onGetSubmitResponse: (response) => Navigator.pop(Get.context!),
      getBodyRequest: (controller, auth, isEdit) async {
        // count tonnage & quantity
        double tonnage = 0;
        int quantity = 0;

        controller.smartScaleRecords.forEach((key, value) {
          tonnage += value.weight ?? 0;
          quantity += value.count ?? 0;
        });

        final RealizationRecord realizationRecord = RealizationRecord(
          weighingNumber: efWeighingNumber.getInput(),
          tonnage: tonnage,
          quantity: quantity,
          averageWeight: tonnage / controller.smartScaleRecords.length,
          details: controller.smartScaleRecords.entries.map((e) => e.value).toList(),
        );

        // create body realization smart scale
        final Realization realization = Realization(
            deliveryOrder: harvest.deliveryOrder,
            weighingNumber: efWeighingNumber.getInput(),
            farmingCycleId: coop.farmingCycleId,
            harvestRequestId: harvest.id,
            bakulName: efBakulName.getInput(),
            harvestDate: dtfHarvestedDate.getLastTimeSelectedText(),
            weighingTime: dtfHarvestedTime.getLastTimeSelectedText(),
            truckDepartingTime: dtfOngoingTime.getLastTimeSelectedText(),
            driver: efDriverName.getInput(),
            truckLicensePlate: efPlateNumber.getInput(),
            witnessName: efWitnessName.getInput(),
            receiverName: efReceiverName.getInput(),
            weigherName: efWeighersName.getInput(),
            minWeight: harvest.minWeight,
            maxWeight: harvest.maxWeight,
            records: [realizationRecord]);

        return ['Bearer ${auth.token}', auth.id, Mapper.asJsonString(realization)];
      },
      getBodyDetail: (controller, auth) => []);
}

class SmartScaleHarvestFormBinding extends Bindings {
  BuildContext context;
  SmartScaleHarvestFormBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<SmartScaleHarvestFormController>(() => SmartScaleHarvestFormController(context: context));
}
