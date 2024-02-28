import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/manufacture_model.dart';
import 'package:model/internal_app/product_model.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';

class ManufactureDetailController extends GetxController {
  BuildContext context;
  ManufactureDetailController({required this.context});

  var isLoading = false.obs;

  late ButtonFill yesCancelButton = ButtonFill(
      controller: GetXCreator.putButtonFillController('yesButton'),
      label: 'Ya',
      onClick: () {
        Constant.track('Click_Batal_Manufaktur');
        Get.back();
        if (manufactureModel.status == 'INPUT_BOOKED') {
          updateManufacture('INPUT_CONFIRMED');
        } else if (manufactureModel.status == 'OUTPUT_DRAFT') {
          updateManufacture('INPUT_BOOKED');
        } else if (manufactureModel.status == 'INPUT_CONFIRMED') {
          updateManufacture('INPUT_DRAFT');
        } else {
          updateManufacture('CANCELLED');
        }
      });
  ButtonOutline noCancelButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('No Button'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      });
  late ButtonFill yesSendButton = ButtonFill(
      controller: GetXCreator.putButtonFillController('yesSendButton'),
      label: 'Ya',
      onClick: () {
        Constant.track('Click_Book_Stock_Manufaktur');
        Get.back();
        updateManufacture('INPUT_BOOKED');
      });
  ButtonOutline noSendButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('NoSendButton'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      });

  late ManufactureModel manufactureModel;
  late DateTime createdDate;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();
  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    manufactureModel = Get.arguments;
    createdDate = Convert.getDatetime(manufactureModel.createdDate!);
  }

  @override
  void onReady() {
    super.onReady();
    getDetailManufacture();
  }

  void getDetailManufacture() {
    Service.push(
        service: ListApi.detailManufactureById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailManufactureById(manufactureModel.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              manufactureModel = body.data;
              isLoading.value = false;
              timeEnd = DateTime.now();
              final Duration totalTime = timeEnd.difference(timeStart);
              Constant.trackRenderTime('Detail_Manufaktur', totalTime);
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = true;
              Get.snackbar(
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                colorText: Colors.white,
                duration: const Duration(seconds: 5),
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

  void updateManufacture(String status) {
    isLoading.value = true;
    Service.push(
        service: ListApi.updateManufactureById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathUpdateManufactureById(manufactureModel.id!), Mapper.asJsonString(generatePayload(status))],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              isLoading.value = false;
              Get.back();
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

  ManufactureModel generatePayload(String status) {
    final List<Products?> output = [];
    return ManufactureModel(
        operationUnitId: manufactureModel.operationUnit!.id,
        status: status,
        input: Products(
          productItemId: manufactureModel.input!.productItems![0]!.id,
          quantity: manufactureModel.input!.productItems![0]!.quantity,
          weight: manufactureModel.input!.productItems![0]!.weight,
        ),
        output: output);
  }
}

class ManufactureDetailBindings extends Bindings {
  BuildContext context;
  ManufactureDetailBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => ManufactureDetailController(context: context));
  }
}
