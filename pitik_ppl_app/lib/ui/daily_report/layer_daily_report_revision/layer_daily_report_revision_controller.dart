
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/daily_report_revision_model.dart';
import 'package:model/error/error.dart';
import 'package:model/report.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/02/2024

class LayerDailyReportRevisionController extends GetxController {
    BuildContext context;
    LayerDailyReportRevisionController({required this.context});

    late Coop coop;
    late Report report;
    late ButtonFill bfRevision;

    var isLoading = false.obs;
    var isAgree = false.obs;
    var stateReasonRevision = 0.obs;
    RxList<String> revisionReasonList = <String>[].obs;

    EditField efOtherReasonRevision = EditField(
        controller: GetXCreator.putEditFieldController("layerDailyRevisionOtherReasonField"),
        label: "",
        hideLabel: true,
        hint: 'Ketik di sini',
        alertText: 'Harus diisi..!',
        textUnit: '',
        maxInput: 200,
        onTyping: (text, field) {}
    );

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        report = Get.arguments[1];

        bfRevision = ButtonFill(controller: GetXCreator.putButtonFillController("layerDailyBtnRevision"), label: "Permintaan Edit", onClick: () {
            if (stateReasonRevision.value == 2 && efOtherReasonRevision.getInput().isEmpty) {
                efOtherReasonRevision.controller.showAlert();
            } else if (revisionReasonList.isEmpty) {
                Get.snackbar(
                    "Pesan",
                    "Revisi apa yang anda lakukan..?",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                );
            } else {
                _pushRevisionToServer();
            }
        });
        bfRevision.controller.disable();
    }

    void updateRevisionReasonList({required String reason, required bool isAdd}) {
        if (revisionReasonList.contains(reason)) {
            revisionReasonList.remove(reason);
            if (isAdd) {
                revisionReasonList.add(reason);
            }
        } else {
            if (isAdd) {
                revisionReasonList.add(reason);
            }
        }
    }

    String _getReasonRevision() {
        if (stateReasonRevision.value == 0) {
            return 'Perubahan data recording karena adjustment';
        } else if (stateReasonRevision.value == 1) {
            return 'Recording tidak jelas karena terkena air coretan';
        } else {
            return efOtherReasonRevision.getInput();
        }
    }

    void _pushRevisionToServer() => AuthImpl().get().then((auth) {
        if (auth != null) {
            showModalBottomSheet(
                useSafeArea: true,
                isDismissible: false,
                enableDrag: false,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
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
                                    Text('Apakah kamu yakin data yang dimasukan sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                                    const SizedBox(height: 16),
                                    Text('Pastikan semua data yang kamu masukan semua sudah benar', style: TextStyle(color: GlobalVar.grayText, fontSize: 12, fontWeight: GlobalVar.medium)),
                                    const SizedBox(height: 16),
                                    Center(child: SvgPicture.asset('images/people_ask_confirm_icon.svg')),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                        width: MediaQuery.of(Get.context!).size.width - 32,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Expanded(
                                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnLayerDailyReportRevisionYes"), label: "Yakin", onClick: () => AuthImpl().get().then((auth) {
                                                        if (auth != null) {
                                                            Navigator.pop(Get.context!);
                                                            isLoading.value = true;

                                                            DailyReportRevision bodyRequest = DailyReportRevision(
                                                                reason: _getReasonRevision(),
                                                                changes: revisionReasonList.value
                                                            );

                                                            Service.push(
                                                                apiKey: ApiMapping.productReportApi,
                                                                service: ListApi.requestDailyReportRevision,
                                                                context: context,
                                                                body: ['Bearer ${auth.token}', auth.id, 'v2/farming-cycles/${coop.farmingCycleId}/daily-reports/${report.date}/revision', Mapper.asJsonString(bodyRequest)],
                                                                listener: ResponseListener(
                                                                    onResponseDone: (code, message, body, id, packet) {
                                                                        isLoading.value = false;
                                                                        Get.back(result: true);
                                                                    },
                                                                    onResponseFail: (code, message, body, id, packet) {
                                                                        Get.snackbar(
                                                                            "Pesan",
                                                                            "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                                                                            snackPosition: SnackPosition.TOP,
                                                                            colorText: Colors.white,
                                                                            backgroundColor: Colors.red,
                                                                        );
                                                                        isLoading.value = false;
                                                                    },
                                                                    onResponseError: (exception, stacktrace, id, packet) {
                                                                        Get.snackbar(
                                                                            "Pesan",
                                                                            "Terjadi Kesalahan Internal",
                                                                            snackPosition: SnackPosition.TOP,
                                                                            colorText: Colors.white,
                                                                            backgroundColor: Colors.red,
                                                                        );
                                                                        isLoading.value = false;
                                                                    },
                                                                    onTokenInvalid: () => GlobalVar.invalidResponse()
                                                                )
                                                            );
                                                        } else {
                                                            GlobalVar.invalidResponse();
                                                        }
                                                    }))
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                    child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnLayerDailyReportRevisionNo"), label: "Tidak Yakin", onClick: () => Navigator.pop(Get.context!))
                                                )
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
        } else {
            GlobalVar.invalidResponse();
        }
    });
}

class LayerDailyReportRevisionBinding extends Bindings {
    BuildContext context;
    LayerDailyReportRevisionBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<LayerDailyReportRevisionController>(() => LayerDailyReportRevisionController(context: context));
}