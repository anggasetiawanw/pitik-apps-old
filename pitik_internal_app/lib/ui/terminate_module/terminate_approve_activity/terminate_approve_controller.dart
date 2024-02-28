import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
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
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/terminate_model.dart';

import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';
import '../../../utils/enum/terminate_status.dart';

class TerminateApproveController extends GetxController {
  BuildContext context;
  TerminateApproveController({required this.context});
  var isLoading = false.obs;
  var isSelectedBox = false.obs;
  late TerminateModel terminateModel;
  late DateTime createdDate;
  EditField efName = EditField(controller: GetXCreator.putEditFieldController('efName'), label: 'Disetujui dan Diperiksa Oleh', hint: '', alertText: '', textUnit: '', maxInput: 50, onTyping: (value, editField) {});

  EditField efMail = EditField(controller: GetXCreator.putEditFieldController('efEmail'), label: 'Email', hint: '', alertText: '', textUnit: '', maxInput: 50, onTyping: (value, editField) {});

  late ButtonFill btConfirmed = ButtonFill(controller: GetXCreator.putButtonFillController('confirmedButton'), label: 'Konfirmasi', onClick: () => _showBottomDialog());

  late ButtonFill btYes = ButtonFill(controller: GetXCreator.putButtonFillController('btYesApprovedPemusnahan'), label: 'Ya', onClick: () => updateTerminate(EnumTerminateStatus.finished));
  late ButtonOutline btNo = ButtonOutline(controller: GetXCreator.putButtonOutlineController('btYesApprovedPemusnahan'), label: 'Tidak', onClick: () => Get.back());

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    terminateModel = Get.arguments;
    createdDate = Convert.getDatetime(terminateModel.createdDate!);
    btConfirmed.controller.disable();
    efName.controller.disable();
    efMail.controller.disable();
    getDetailTerminate();
  }

  @override
  void onReady() {
    super.onReady();
    efName.setInput(Constant.profileUser!.fullName ?? '');
    efMail.setInput(Constant.profileUser!.email ?? '');
  }

  void getDetailTerminate() {
    isLoading.value = true;
    Service.push(
        service: ListApi.detailTerminateById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailTerminateById(terminateModel.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              terminateModel = body.data;
              isLoading.value = false;
              timeEnd = DateTime.now();
              final Duration totalTime = timeEnd.difference(timeStart);
              Constant.trackRenderTime('Approve_Pemusnahan', totalTime);
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

  void updateTerminate(String status) {
    Constant.track('Click_Setujui_Pemusnahan');
    Get.back();
    isLoading.value = true;
    Service.push(
        service: ListApi.updateTerminateById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateTerminateById(terminateModel.id!), Mapper.asJsonString(generatePayload(status))],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Get.back();
              isLoading.value = false;
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${body.error!.message}',
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

  TerminateModel generatePayload(String status) {
    return TerminateModel(
        operationUnitId: terminateModel.operationUnit!.id,
        status: status,
        imageLink: terminateModel.imageLink,
        reviewerId: Constant.profileUser!.id,
        product: Products(
          productItemId: terminateModel.product!.productItem!.id,
          quantity: terminateModel.product!.productItem!.quantity,
          weight: terminateModel.product!.productItem!.weight,
        ));
  }

  // @override
  // void onClose() {
  //     super.onClose();
  // }
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

class TerminateApproveBindings extends Bindings {
  BuildContext context;
  TerminateApproveBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => TerminateApproveController(context: context));
  }
}
