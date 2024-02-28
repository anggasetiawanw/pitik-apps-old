import 'package:common_page/library/component_library.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_area_field/edit_area_field.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/adjustment_closing.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 8/12/2023

class AdjustmentOvkController extends GetxController {
  BuildContext context;
  AdjustmentOvkController({required this.context});

  late Coop coop;
  late double ovkLeftOver;
  late EditAreaField eaNotes;
  late EditField ovkQuantityField;

  var isLoading = false.obs;
  var ovkStockSummary = '-'.obs;

  @override
  void onInit() {
    super.onInit();
    coop = Get.arguments[0];
    ovkLeftOver = Get.arguments[1];

    eaNotes = EditAreaField(controller: GetXCreator.putEditAreaFieldController('adjustmentOvkNotes'), label: 'Catatan', hint: 'Tulis Catatan', alertText: 'Harus diisi..!', maxInput: 300, onTyping: (text, field) {});
    ovkQuantityField = EditField(
        controller: GetXCreator.putEditFieldController('adjustmentOvkQuantity'), label: 'Total', hint: 'Ketik di sini', alertText: 'Total belum diisi..!', textUnit: '', maxInput: 20, inputType: TextInputType.number, onTyping: (text, field) {});
  }

  void saveAdjustment() => AuthImpl().get().then((auth) {
        if (auth != null) {
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
                            const SizedBox(height: 16),
                            Text('Apakah yakin data yang kamu isi sudah benar?', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 21, fontWeight: GlobalVar.bold)),
                            const SizedBox(height: 16),
                            Text('Pastikan data yang kamu isi sudah benar untuk melanjutkan ke proses berikutnya', style: TextStyle(color: GlobalVar.black, fontSize: 12, fontWeight: GlobalVar.bold)),
                            const SizedBox(height: 50),
                            SizedBox(
                                width: MediaQuery.of(Get.context!).size.width - 32,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(
                                      child: ButtonFill(
                                          controller: GetXCreator.putButtonFillController('btnAgreeAdjustmentOvk'),
                                          label: 'Yakin',
                                          onClick: () {
                                            Navigator.pop(Get.context!);
                                            if (ovkQuantityField.getInputNumber() != ovkLeftOver) {
                                              Get.snackbar(
                                                'Pesan',
                                                'Jumlah tidak valid, sisa OVK adalah $ovkLeftOver Botol',
                                                snackPosition: SnackPosition.TOP,
                                                colorText: Colors.white,
                                                backgroundColor: Colors.red,
                                              );
                                            } else {
                                              isLoading.value = true;

                                              final AdjustmentClosing body = AdjustmentClosing(remarks: eaNotes.getInput(), value: ovkQuantityField.getInputNumber());

                                              Service.push(
                                                  apiKey: 'productReportApi',
                                                  service: ListApi.saveStocks,
                                                  context: context,
                                                  body: ['Bearer ${auth.token}', auth.id, 'v2/ovkstocks/${coop.farmingCycleId}/closing-adjustment', Mapper.asJsonString(body)],
                                                  listener: ResponseListener(
                                                      onResponseDone: (code, message, body, id, packet) {
                                                        Get.back();
                                                        Get.snackbar(
                                                          'Pesan',
                                                          'Pencatatan OVK berhasil....',
                                                          snackPosition: SnackPosition.TOP,
                                                          colorText: Colors.black,
                                                          backgroundColor: Colors.white,
                                                        );
                                                        isLoading.value = false;
                                                      },
                                                      onResponseFail: (code, message, body, id, packet) {
                                                        isLoading.value = false;
                                                        Get.snackbar(
                                                          'Pesan',
                                                          'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                                                          snackPosition: SnackPosition.TOP,
                                                          colorText: Colors.white,
                                                          backgroundColor: Colors.red,
                                                        );
                                                      },
                                                      onResponseError: (exception, stacktrace, id, packet) {
                                                        isLoading.value = false;
                                                        Get.snackbar(
                                                          'Pesan',
                                                          'Terjadi Kesalahan, $exception',
                                                          snackPosition: SnackPosition.TOP,
                                                          colorText: Colors.white,
                                                          backgroundColor: Colors.red,
                                                        );
                                                      },
                                                      onTokenInvalid: () => GlobalVar.invalidResponse()));
                                            }
                                          })),
                                  const SizedBox(width: 16),
                                  Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController('btnNotAdjustmentOvk'), label: 'Tidak Yakin', onClick: () => Navigator.pop(Get.context!)))
                                ])),
                            const SizedBox(height: 32)
                          ])))));
        } else {
          GlobalVar.invalidResponse();
        }
      });
}

class AdjustmentOvkBinding extends Bindings {
  BuildContext context;
  AdjustmentOvkBinding({required this.context});

  @override
  void dependencies() => Get.lazyPut<AdjustmentOvkController>(() => AdjustmentOvkController(context: context));
}
