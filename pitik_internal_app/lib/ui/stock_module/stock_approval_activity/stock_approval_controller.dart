import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/product_model.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../utils/enum/stock_status.dart';

class StockApprovalController extends GetxController {
  BuildContext context;
  StockApprovalController({required this.context});
  late OpnameModel opnameModel;
  late DateTime createdDate;
  var isLoading = false.obs;
  var isSelectedBox = false.obs;

  EditField efName = EditField(controller: GetXCreator.putEditFieldController('efName'), label: 'Disetujui dan Diperiksa Oleh', hint: '', alertText: '', textUnit: '', maxInput: 50, onTyping: (value, editField) {});

  EditField efMail = EditField(controller: GetXCreator.putEditFieldController('efEmail'), label: 'Email', hint: '', alertText: '', textUnit: '', maxInput: 50, onTyping: (value, editField) {});

  late ButtonFill btConfirmed = ButtonFill(controller: GetXCreator.putButtonFillController('confirmedButton'), label: 'Konfirmasi', onClick: () => _showBottomDialog());

  late ButtonFill btYes = ButtonFill(controller: GetXCreator.putButtonFillController('btYesStockApp'), label: 'Ya', onClick: () => updateStock(EnumStock.finished));
  late ButtonOutline btNo = ButtonOutline(controller: GetXCreator.putButtonOutlineController('BtNoSTock'), label: 'Tidak', onClick: () => Get.back());

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    btConfirmed.controller.disable();
    efName.controller.disable();
    efMail.controller.disable();
    opnameModel = Get.arguments;
    opnameModel = Get.arguments;
    createdDate = Convert.getDatetime(opnameModel.createdDate!);
    isLoading.value = true;
    getDetailStock();
  }

  @override
  void onReady() {
    super.onReady();
    efName.setInput(Constant.profileUser!.fullName ?? '');
    efMail.setInput(Constant.profileUser!.email ?? '');
  }

  void getDetailStock() {
    Service.push(
        service: ListApi.detailOpnameById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailOpanameById(opnameModel.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              opnameModel = body.data;
              isLoading.value = false;
              timeEnd = DateTime.now();
              final Duration totalTime = timeEnd.difference(timeStart);
              Constant.trackRenderTime('Approval_Stock_Opname', totalTime);
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = true;
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = true;
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void updateStock(String status) {
    Constant.track('Click_Setujui_Stock_Opname');
    Get.back();
    isLoading.value = true;
    Service.push(
        service: ListApi.updateOpnameById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateOpnameById(opnameModel.id!), Mapper.asJsonString(generatePayload(status))],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.back();
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );

              isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi kesalahan internal',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  OpnameModel generatePayload(String status) {
    final List<Products?> products = [];

    for (var product in opnameModel.products!) {
      for (var item in product!.productItems!) {
        products.add(Products(productItemId: item!.id, quantity: item.quantity, weight: item.weight));
      }
    }

    return OpnameModel(
      operationUnitId: opnameModel.operationUnit!.id,
      status: status,
      products: products,
      reviewerId: Constant.profileUser!.id,
      totalWeight: opnameModel.totalWeight ?? 0,
      confirmedDate: Convert.getStringIso(DateTime.now()),
    );
  }

  Future<void> _showBottomDialog() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return Container(
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
                    color: AppColors.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text(
                    'Apakah kamu yakin ingin menyetujui data ini?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan semua data yang ada sudah bener, sebelum memberi persetujuan', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    'images/approve_image.svg',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: btYes),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: btNo),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Constant.bottomSheetMargin,
                )
              ],
            ),
          );
        });
  }
}

class StockApprovalBindings extends Bindings {
  BuildContext context;
  StockApprovalBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => StockApprovalController(context: context));
  }
}
