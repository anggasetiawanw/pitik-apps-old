
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/12/2023

class SmartScaleHarvestDetailController extends GetxController {
    BuildContext context;
    SmartScaleHarvestDetailController({required this.context});

    late Coop coop;
    late Realization realization;

    var isLoading = false.obs;
    var isEdit = true.obs;
    var isPreview = false.obs;
    Rx<Widget> containerButtonEditAndPreview = (const SizedBox(width: 0, height: 0)).obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        realization = Get.arguments[1];

        if (realization.statusText != GlobalVar.TEREALISASI) {
            isEdit.value = false;
        }
        _generateButtonBottom();
    }

    void _generateButtonBottom() => {
        if (isEdit.isTrue) {
            containerButtonEditAndPreview.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSmartScaleHarvestEditRealization"), label: "Edit", onClick: () {
                                        Harvest harvest = Harvest(
                                            id: realization.id,
                                            deliveryOrder: realization.deliveryOrder,
                                            status: realization.status.toString(),
                                            statusText: realization.statusText,
                                            datePlanned: realization.harvestRequestDate,
                                            minWeight: realization.minWeight,
                                            maxWeight: realization.maxWeight,
                                            quantity: realization.quantity,
                                            reason: realization.reason,
                                            weighingNumber: realization.weighingNumber,
                                            coopName: realization.coopName,
                                            addressName: realization.addressName,
                                            bakulName: realization.bakulName,
                                            truckLicensePlate: realization.truckLicensePlate
                                        );

                                        Get.toNamed(RoutePage.smartScaleHarvestForm, arguments: [
                                            coop,
                                            harvest,
                                            realization.weighingTime,
                                            realization.truckDepartingTime,
                                            realization.driver,
                                            realization.witnessName,
                                            realization.receiverName,
                                            realization.weigherName
                                        ])!.then((value) => Get.back());
                                    })
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnSmartScaleHarvestPreviewRealization"), label: "Preview", onClick: () => isPreview.value = true))
                            ]
                        )
                    )
                )
            )
        } else if (isPreview.isTrue) {
            containerButtonEditAndPreview.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSmartScaleHarvestNextRealization"), label: "Selanjutnya", onClick: () {}),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnSmartScaleHarvestDownloadRealization"), label: "Download PDF", onClick: () {}))
                            ]
                        )
                    )
                )
            )
        } else {
            containerButtonEditAndPreview.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnSmartScaleHarvestPreviewRealization"), label: "Preview", onClick: () => isPreview.value = true))
                            ]
                        )
                    )
                )
            )
        }
    };

    String getQuantityText() => '${realization.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.quantity.toString(), '', '.')} Ekor';
    String getTonnageText() => '${realization.tonnage == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.tonnage.toString(), '', '.')} Kg';
    String getAverageWeightText() => '${realization.averageChickenWeighed == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.averageChickenWeighed.toString(), '', '.')} Kg';
    String getBwText() => '${realization.minWeight == null ? '-' : realization.minWeight!.toStringAsFixed(1)} Kg s.d ${realization.maxWeight == null ? '-' : realization.maxWeight!.toStringAsFixed(1)} Kg';

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
            )
        );
    }
}

class SmartScaleHarvestDetailBinding extends Bindings {
    BuildContext context;
    SmartScaleHarvestDetailBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartScaleHarvestDetailController>(() => SmartScaleHarvestDetailController(context: context));
}