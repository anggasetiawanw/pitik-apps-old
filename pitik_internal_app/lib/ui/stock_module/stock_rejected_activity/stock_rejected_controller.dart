import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/product_model.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';

class StockRejectedController extends GetxController {
  BuildContext context;
  StockRejectedController({required this.context});
  late OpnameModel opnameModel;
  late DateTime createdDate;
  var isLoading = false.obs;
  var isSelectedBox = false.obs;
  late ButtonFill btConfirmed = ButtonFill(controller: GetXCreator.putButtonFillController('confirmedButton'), label: 'Konfirmasi', onClick: () => _showBottomDialog());

  late ButtonFill btYes = ButtonFill(controller: GetXCreator.putButtonFillController('btYesRejected'), label: 'Ya', onClick: () => updateStock('REJECTED'));
  late ButtonOutline btNo = ButtonOutline(controller: GetXCreator.putButtonOutlineController('BtNoRejected'), label: 'Tidak', onClick: () => Get.back());

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    opnameModel = Get.arguments;
    createdDate = Convert.getDatetime(opnameModel.createdDate!);
    isLoading.value = true;
    getDetailStock();
  }

  // @override
  // void onClose() {
  //     super.onClose();
  // }

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
              Constant.trackRenderTime('Tolak_Stock_Opname', totalTime);
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
    Constant.track('Click_Tolak_Stock_Opname');
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Apakah kamu yakin ingin melakukan penolakan?',
                    style: AppTextStyle.primaryTextStyle.copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text('Pastikan data aman sebelum melakukanponalakan', style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: SvgPicture.asset(
                      'images/cancel_icon.svg',
                    ),
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

class StockRejectedBindings extends Bindings {
  BuildContext context;
  StockRejectedBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => StockRejectedController(context: context));
  }
}
