import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/visit_customer_model.dart';
import 'package:model/response/internal_app/visit_customer_response.dart';
import '../../../api_mapping/list_api.dart';
import '../../../utils/constant.dart';

class DetailVisitController extends GetxController {
  BuildContext context;
  DetailVisitController({required this.context});

  var isLoading = false.obs;
  String? dataIdCust;
  String? dataIdVisit;
  String? salerPerson;
  Rxn<VisitCustomer> customer = Rxn<VisitCustomer>();
  Rxn<DateTime> dateCustomer = Rxn<DateTime>();

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    dataIdCust = Get.arguments[0];
    dataIdVisit = Get.arguments[1];
    salerPerson = Get.arguments[2];
    dateCustomer.value = Get.arguments[3];
    isLoading.value = true;
  }

  @override
  void onReady() {
    super.onReady();
    Service.push(
      service: ListApi.getListVisitById,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId, ListApi.pathGetVisitById(dataIdCust!, dataIdVisit!)],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            customer.value = (body as VisitCustomerResponse).data;
            isLoading.value = false;
            timeEnd = DateTime.now();
            final Duration totalTime = timeEnd.difference(timeStart);
            Constant.trackRenderTime('Detail_Visit_Customer', totalTime);
          },
          onResponseFail: (code, message, body, id, packet) {
            Get.snackbar(
              'Pesan',
              'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
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
            //  isLoading.value = false;
          },
          onTokenInvalid: Constant.invalidResponse()),
    );
  }
}

class DetailVisitBindings extends Bindings {
  BuildContext context;
  DetailVisitBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => DetailVisitController(context: context));
  }
}
