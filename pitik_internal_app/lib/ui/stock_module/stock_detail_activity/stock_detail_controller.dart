import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/convert.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pitik_internal_app/api_mapping/list_api.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class StockDetailController extends GetxController {
  BuildContext context;
  ScreenshotController screenshotController = ScreenshotController();
  StockDetailController({required this.context});
  late ButtonFill yesButton = ButtonFill(
      controller: GetXCreator.putButtonFillController("yesButton"),
      label: "Ya",
      onClick: () {
        Constant.track("Click_Batal_Stock");
        updateStock("CANCELLED");
        Get.back();
      });
  ButtonOutline noButton = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("No Button"),
      label: "Tidak",
      onClick: () {
        Get.back();
      });

  late OpnameModel opnameModel;
  late DateTime createdDate;
  var isLoading = false.obs;

  late ButtonFill btSetujui = ButtonFill(
      controller: GetXCreator.putButtonFillController("btSetujui"),
      label: "Setujui",
      onClick: () {
        Get.toNamed(RoutePage.stockApproval, arguments: opnameModel)!.then((value) {
          isLoading.value = true;
          Timer(const Duration(milliseconds: 500), () {
            getDetailStock();
          });
        });
      });
  late ButtonOutline btTolak = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController("btTolak"),
      label: "Tolak",
      onClick: () {
        Get.toNamed(RoutePage.stockRejected, arguments: opnameModel)!.then((value) {
          isLoading.value = true;
          Timer(const Duration(milliseconds: 500), () {
            getDetailStock();
          });
        });
      });

  late ButtonFill btShareOpname = ButtonFill(
      controller: GetXCreator.putButtonFillController("btShareOpname"),
      label: "Share PDF",
      onClick: () async {
        screenshotController.capture().then((Uint8List? image) async {
          if (image != null) {
            await shareWithPdf(image);
          }
        });
      });

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    opnameModel = Get.arguments;
    isLoading.value = true;
    getDetailStock();
    initializeDateFormatting();
    super.onInit();
  }

  void getDetailStock() {
    Service.push(
        service: ListApi.detailOpnameById,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, ListApi.pathGetDetailOpanameById(opnameModel.id!)],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              opnameModel = body.data;
              createdDate = Convert.getDatetime(opnameModel.createdDate!);
              isLoading.value = false;
              timeEnd = DateTime.now();
              Duration totalTime = timeEnd.difference(timeStart);
              Constant.trackRenderTime("Detail_Stock", totalTime);
            },
            onResponseFail: (code, message, body, id, packet) {
              isLoading.value = true;
              Get.snackbar(
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onResponseError: (exception, stacktrace, id, packet) {
              isLoading.value = true;
              Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void updateStock(String status) {
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
                "Pesan",
                "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );

              isLoading.value = false;
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar(
                "Pesan",
                "Terjadi kesalahan internal",
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoading.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  Future<void> shareWithPdf(Uint8List screenShot) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory('${appDocDirectory.path}/dir').create(recursive: true).then((Directory directory) async {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      final output = File('${directory.path}/share${opnameModel.code}.pdf');
      File pdfFile = await output.writeAsBytes(await pdf.save());
      final result = await Share.shareXFiles([XFile(pdfFile.path)], text: "Berita Acara Opname ${opnameModel.operationUnit!.operationUnitName} - ${Convert.getDatetime(opnameModel.confirmedDate!)}");

      if (result.status == ShareResultStatus.success) {}
    });
  }

  OpnameModel generatePayload(String status) {
    List<Products?> products = [];

    for (var product in opnameModel.products!) {
      for (var item in product!.productItems!) {
        products.add(Products(productItemId: item!.id, quantity: item.quantity, weight: item.weight));
      }
    }
    return OpnameModel(
      operationUnitId: opnameModel.operationUnit!.id,
      status: status,
      products: products,
      totalWeight: opnameModel.totalWeight,
    );
  }
}

class StockDetailBindings extends Bindings {
  BuildContext context;
  StockDetailBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => StockDetailController(context: context));
  }
}
