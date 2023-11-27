import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/error/error.dart';
import 'package:model/internal_app/opname_model.dart';
import 'package:model/internal_app/terminate_model.dart';
import 'package:model/response/internal_app/list_opnames_response.dart';
import 'package:model/response/internal_app/list_terminate_response.dart';
import 'package:pitik_internal_app/api_mapping/api_mapping.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/enum/stock_status.dart';
import 'package:pitik_internal_app/utils/enum/terminate_status.dart';

import '../../../api_mapping/list_api.dart';

class JobController extends GetxController with GetSingleTickerProviderStateMixin {
  BuildContext context;
  JobController({required this.context});
  late TabController tabController;
  var pageStock = 1.obs;
  var pageTerminate = 1.obs;
  var limit = 10.obs;
  var isLoadingStock = false.obs;
  var isLoadingTerminate = false.obs;
  var isLoadMore = false.obs;

  Rx<List<OpnameModel?>> listStock = Rx<List<OpnameModel>>([]);
  Rx<List<TerminateModel?>> listTerminate = Rx<List<TerminateModel>>([]);

  ScrollController scrollStockOpname = ScrollController();
  ScrollController scrollTerminate = ScrollController();

  scrollStockOpnameListener() async {
    scrollStockOpname.addListener(() {
      if (scrollStockOpname.position.maxScrollExtent == scrollStockOpname.position.pixels) {
        isLoadMore.value = true;
        pageStock++;
        getListStock();
      }
    });
  }

  scrollTerminateListener() async {
    scrollTerminate.addListener(() {
      if (scrollTerminate.position.maxScrollExtent == scrollTerminate.position.pixels) {
        isLoadMore.value = true;
        pageTerminate++;
        getListTerminate();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
    scrollStockOpnameListener();
    scrollTerminateListener();
    tabController.addListener(() {
      if (tabController.index == 0) {
        isLoadingStock.value = true;        
        listStock.value.clear();
        pageStock.value = 1;
        getListStock();
      } else {
        isLoadingTerminate.value = true;
        listTerminate.value.clear();
        pageTerminate.value = 1;
        getListTerminate();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    isLoadingStock.value = true;
    isLoadingTerminate.value = true;
    getListStock();
    getListTerminate();
  }
  // @override
  // void onClose() {
  //     super.onClose();
  // }

  void pullRefreshStock() {
    isLoadingStock.value = true;
    listStock.value.clear();
    pageStock.value = 1;
    getListStock();
  }
  void pullrefreshTerminate(){
    isLoadingTerminate.value = true;
    listTerminate.value.clear();
    pageTerminate.value = 1;
    getListTerminate();
  }

  void getListStock() {
    Service.push(
        service: ListApi.getListOpnameJob,
        apiKey: ApiMapping.api,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, pageStock.value, limit.value, EnumStock.confirmed],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListOpnameResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listStock.value.add(result as OpnameModel);
                }
                isLoadingStock.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  pageStock.value = (listStock.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoadingStock.value = false;
                }
              }
              refresh();
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
              isLoadingStock.value = false;
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
              isLoadingStock.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getListTerminate() {
    Service.push(
        service: ListApi.getListTerminateJob,
        apiKey: ApiMapping.api,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, pageTerminate.value, limit.value, EnumTerminateStatus.booked],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListTerminateResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listTerminate.value.add(result as TerminateModel);
                }
                isLoadingTerminate.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  pageTerminate.value = (listTerminate.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoadingTerminate.value = false;
                }
              }
              refresh();
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
              isLoadingTerminate.value = false;
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
              isLoadingTerminate.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}

class JobBindings extends Bindings {
  BuildContext context;
  JobBindings({required this.context});
  @override
  void dependencies() {
    Get.lazyPut(() => JobController(context: context));
  }
}
