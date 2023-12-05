
import 'package:components/button_fill/button_fill.dart';
import 'package:components/custom_dialog.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/listener/custom_dialog_listener.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:model/response/adjusment_mortality_response.dart';
import 'package:model/response/left_over_response.dart';
import 'package:model/response/procurement_list_response.dart';
import 'package:pitik_ppl_app/ui/harvest/harvest_common.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/12/2023

class FarmClosingController extends GetxController with GetSingleTickerProviderStateMixin {
    BuildContext context;
    FarmClosingController({required this.context});

    late TabController harvestTabController;
    late Coop coop;
    late ButtonFill bfNext;
    late ButtonFill bfCloseFarm;

    var isLoading = false.obs;
    var isClosingButton = false.obs;
    var state = 0.obs;
    var populationPrediction = '- Ekor'.obs;

    RxList<Harvest?> harvestList = <Harvest?>[].obs;
    RxList<Realization?> realizationList = <Realization?>[].obs;

    late RxList<Container> barList = <Container>[].obs;
    late RxList<SvgPicture> pointList = <SvgPicture>[].obs;
    late RxList<Text> textPointLabelList = <Text>[].obs;
    late CustomDialog _customDialog;

    late EditField efTotalMortality;
    late EditAreaField eaRemarks;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];

        bfNext = ButtonFill(controller: GetXCreator.putButtonFillController("btnFarmClosingNext"), label: "Selanjutnya", onClick: () => nextPage());
        bfCloseFarm = ButtonFill(controller: GetXCreator.putButtonFillController("btnFarmClosingSubmit"), label: "Tutup Farm", onClick: () => closeFarming());

        harvestTabController = TabController(vsync: this, length: 2);
        harvestTabController.addListener(() {
            if (harvestTabController.index == 0) {
                HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList);
            } else {
                HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList);
            }
        });

        efTotalMortality = EditField(
            controller: GetXCreator.putEditFieldController("farmClosingTotalMortality"), 
            label: "Total Mortalitas", 
            hint: "Ketik disini..!", 
            alertText: "Harus diisi..!", 
            textUnit: "Ekor", 
            maxInput: 100, 
            inputType: TextInputType.number,
            onTyping: (text, field) {}
        );
        
        eaRemarks = EditAreaField(
            controller: GetXCreator.putEditAreaFieldController("farmClosingMortalityRemarks"),
            label: "Catatan",
            hint: "Tulis catatan",
            alertText: "Harus diisi..!",
            maxInput: 500,
            onTyping: (text, field) {}
        );

        _customDialog = CustomDialog(Get.context!, Dialogs.YES_OPTION)
            .listener(CustomDialogListener(
                onDialogOk: (context, id, packet) =>  _customDialog.hide(),
                onDialogCancel: (context, id, packet) {}
        ));

        _toCheckHarvest();
        _getInitialPopulation();
        // _checkStatusFullFiled();
    }

    void refreshHarvestList() {
        if (harvestTabController.index == 0) {
            HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList, onCallBack: () => _isHarvestDealAvailableExist());
        } else {
            HarvestCommon.getRealizationList(isLoading: isLoading, coop: coop, realizationList: realizationList);
        }
    }

    void _isHarvestDealAvailableExist() {
        for (var harvest in harvestList) {
            if (harvest != null && harvest.status == "AVAILABLE") {
                bfNext.controller.disable();
                break;
            }
        }
    }

    bool isOwnFarm() => coop.isOwnFarm != null && coop.isOwnFarm!;
    double _getBarWidth() => (MediaQuery.of(Get.context!).size.width - 80) / (isOwnFarm() ? 3 : 2);

    void _toCheckHarvest() {
        state.value = 0;
        isClosingButton.value = false;

        barList.insert(0, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        barList.insert(1, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));

        pointList.insert(0, SvgPicture.asset('images/bar_point_active_orange.svg'));
        pointList.insert(1, SvgPicture.asset('images/bar_point_inactive.svg'));
        pointList.insert(2, SvgPicture.asset('images/bar_point_inactive.svg'));

        textPointLabelList.insert(0, Text("Periksa\nPanen", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
        textPointLabelList.insert(1, Text("Periksa\nMortality", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
        textPointLabelList.insert(2, Text("Periksa\nPakan", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));

        if (isOwnFarm()) {
            barList.insert(2, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
            pointList.insert(3, SvgPicture.asset('images/bar_point_inactive.svg'));
            textPointLabelList.insert(3, Text("Periksa\nOVK", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
        }

        harvestTabController.index = 0;
        HarvestCommon.getDealList(isLoading: isLoading, coop: coop, harvestList: harvestList, onCallBack: () => _isHarvestDealAvailableExist());
    }

    void _toCheckMortality() {
        state.value = 1;
        isClosingButton.value = false;

        barList.insert(0, Container(color: GlobalVar.primaryOrange, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        barList.insert(1, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));

        pointList.insert(0, SvgPicture.asset('images/bar_point_active_green.svg'));
        pointList.insert(1, SvgPicture.asset('images/bar_point_active_orange.svg'));
        pointList.insert(2, SvgPicture.asset('images/bar_point_inactive.svg'));

        textPointLabelList.insert(0, Text("Periksa\nPanen", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
        textPointLabelList.insert(1, Text("Periksa\nMortality", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
        textPointLabelList.insert(2, Text("Periksa\nPakan", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));

        if (isOwnFarm()) {
            barList.insert(2, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
            pointList.insert(3, SvgPicture.asset('images/bar_point_inactive.svg'));
            textPointLabelList.insert(3, Text("Periksa\nOVK", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
        }

        _getAdjustmentMortality();
    }

    void _toCheckFeed() {
        state.value = 2;
        if (!isOwnFarm()) {
            isClosingButton.value = true;
        } else {
            isClosingButton.value = false;
        }

        barList.insert(0, Container(color: GlobalVar.greenBackground, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        barList.insert(1, Container(color: GlobalVar.primaryOrange, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));

        pointList.insert(0, SvgPicture.asset('images/bar_point_active_green.svg'));
        pointList.insert(1, SvgPicture.asset('images/bar_point_active_green.svg'));
        pointList.insert(2, SvgPicture.asset('images/bar_point_active_orange.svg'));

        textPointLabelList.insert(2, Text("Periksa\nPakan", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));

        if (isOwnFarm()) {
            barList.insert(2, Container(color: GlobalVar.primaryLight, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
            pointList.insert(3, SvgPicture.asset('images/bar_point_inactive.svg'));
            textPointLabelList.insert(3, Text("Periksa\nOVK", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.medium, color: GlobalVar.grayText), textAlign: TextAlign.center));
        }
    }

    void _toCheckOvk() {
        state.value = 3;
        isClosingButton.value = true;

        barList.insert(1, Container(color: GlobalVar.greenBackground, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        pointList.insert(2, SvgPicture.asset('images/bar_point_active_green.svg'));

        barList.insert(2, Container(color: GlobalVar.primaryOrange, height: 8, width: _getBarWidth(), padding: const EdgeInsets.only(top: 8)));
        pointList.insert(3, SvgPicture.asset('images/bar_point_active_orange.svg'));
        textPointLabelList.insert(3, Text("Periksa\nOVK", style: GlobalVar.subTextStyle.copyWith(fontSize: 11, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center));
    }

    Row getLabelPoint() {
        if (isOwnFarm()) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Center(child: textPointLabelList[0]),
                    Center(child: textPointLabelList[1]),
                    Center(child: textPointLabelList[2]),
                    Center(child: textPointLabelList[3])
                ]
            );
        } else {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Center(child: textPointLabelList[0]),
                    Center(child: textPointLabelList[1]),
                    Center(child: textPointLabelList[2])
                ]
            );
        }
    }

    void nextPage() {
        if (state.value == 0) {
            _toCheckMortality();
        } else if (state.value == 1) {
            _toCheckFeed();
        } else if (state.value == 2) {
            _toCheckOvk();
        }
    }

    void previousPage() {
        if (state.value == 3) {
            _toCheckFeed();
        } else if (state.value == 2) {
            _toCheckMortality();
        } else if (state.value == 1) {
            _toCheckHarvest();
        } else {
            Get.back();
        }
    }

    void closeFarming() => AuthImpl().get().then((auth) {
        if (auth != null) {

        } else {
            GlobalVar.invalidResponse();
        }
    });

    void _checkStatusFullFiled() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'productReportApi',
                service: ListApi.getListPurchaseOrder,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, coop.farmingCycleId, null, null, null, null, "approved", false],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as ProcurementListResponse).data.isNotEmpty) {
                            String message = "Ada Penerimaan yang belum lengkap\n";

                            for (var procurement in body.data) {
                                message += '\t- ${procurement!.erpCode}\n';
                            }

                            message += "Segera lengkapi penerimaan atau hubungi admin bila terjadi ketidaksesuaian";
                            _customDialog
                                .title("Perhatian!")
                                .message(message)
                                .show();
                        }

                        isLoading.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        isLoading.value = false;
                        Get.back();
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
                        Get.back();
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

    void _getAdjustmentMortality() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: 'farmMonitoringApi',
                service: ListApi.getAdjustment,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop.farmingCycleId}/closing/mortality-adjustment'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as AdjustmentMortalityResponse).data != null) {
                            efTotalMortality.setInput(body.data!.value == null ? '' : body.data!.value!.toStringAsFixed(0));
                            eaRemarks.setValue(body.data!.remarks ?? '');
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

    void _getInitialPopulation() => AuthImpl().get().then((auth) {
        if (auth != null) {
            Service.push(
                apiKey: 'farmMonitoringApi',
                service: ListApi.getLeftOver,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop.farmingCycleId}/closing/remaining-population'],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if ((body as LeftOverResponse).data != null) {
                            populationPrediction.value = '${body.data!.remainingPopulation == null ? '-' : Convert.toCurrencyWithoutDecimal(body.data!.remainingPopulation.toString(), '', '.')} Ekor';
                        }
                    },
                    onResponseFail: (code, message, body, id, packet) {},
                    onResponseError: (exception, stacktrace, id, packet) {},
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class FarmClosingBinding extends Bindings {
    BuildContext context;
    FarmClosingBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<FarmClosingController>(() => FarmClosingController(context: context));
}