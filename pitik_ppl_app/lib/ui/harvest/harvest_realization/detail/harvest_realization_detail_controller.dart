
import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/realization_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/11/2023

class HarvestRealizationDetailController extends GetxController {
    BuildContext context;
    HarvestRealizationDetailController({required this.context});

    late Coop coop;
    late Realization realization;

    var isLoading = false.obs;

    @override
    void onInit() {
        super.onInit();
        GlobalVar.track('Open_detail_page_realisasi_panen');

        coop = Get.arguments[0];
        realization = Get.arguments[1];
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

    String getBwText() => '${realization.minWeight == null ? '-' : realization.minWeight!.toStringAsFixed(1)} Kg '
                          's.d '
                          '${realization.maxWeight == null ? '-' : realization.maxWeight!.toStringAsFixed(1)} Kg';

    String getQuantityText() => '${realization.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.quantity.toString(), '', '.')} Ekor';
}

class HarvestRealizationDetailBinding extends Bindings {
    BuildContext context;
    HarvestRealizationDetailBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<HarvestRealizationDetailController>(() => HarvestRealizationDetailController(context: context));
}