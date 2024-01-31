part of 'data_receive_controller.dart';

extension TransferReceiveController on ReceiveController {
  void resetAllBodyTransferValue() {
    pageTransfer.value = 1;
    listTransfer.value.clear();
    for (int i = 0; i < bodyGeneralTransfer.length; i++) {
      bodyGeneralTransfer[i] = null;
    }
    bodyGeneralTransfer[BodyQueryTransfer.token.index] = Constant.auth!.token;
    bodyGeneralTransfer[BodyQueryTransfer.auth.index] = Constant.auth!.id;
    bodyGeneralTransfer[BodyQueryTransfer.xAppId.index] = Constant.xAppId;
    bodyGeneralTransfer[BodyQueryTransfer.page.index] = pagePurchase.value;
    bodyGeneralTransfer[BodyQueryTransfer.limit.index] = limit.value;
  }

  void openFilterTransfer() {
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    if (spCategory.controller.textSelected.isNotEmpty) {
      spSku.controller.enable();
    }
    spJenisSumber.controller.invisibleSpinner();
    getCategorySku();
    getListOperationUnit();
    getListDestinationOperationUnit();
    showFilter();
  }

  scrollTransferListener() async {
    scrollTransferController.addListener(() {
      if (scrollTransferController.position.maxScrollExtent == scrollTransferController.position.pixels) {
        isLoadMore.value = true;
        pageTransfer++;
        getListTransfer();
      }
    });
  }

  void getListOperationUnit() {
    spSumber.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, AppStrings.TRUE_LOWERCASE, 0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList3 = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList3[units!.operationUnitName!] = false;
              }

              for (var result in body.data) {
                listSourceOperationUnits.value.add(result);
              }
              Timer(const Duration(milliseconds: 100), () {
                spSumber.controller
                  ..enable()
                  ..hideLoading()
                  ..generateItems(mapList3);
              });
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
              spSumber.controller.showLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getListDestinationOperationUnit() {
    spTujuan.controller
      ..disable()
      ..showLoading();
    Service.push(
        service: ListApi.getListDestionTransfer,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              for (var result in body.data) {
                listDestinationOperationUnits.value.add(result);
              }
              Timer(const Duration(milliseconds: 100), () {
                spTujuan.controller
                  ..enable()
                  ..hideLoading()
                  ..generateItems(mapList);
              });
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
              spTujuan.controller
                ..enable()
                ..hideLoading();
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
              spTujuan.controller
                ..enable()
                ..hideLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getListTransfer() {
    Service.push(
        service: ListApi.getGoodReceiptTransferList,
        context: context,
        body: bodyGeneralTransfer,
        // body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId!, pageTransfer.value, limit.value, "RECEIVED", "DELIVERED", AppStrings.TRUE_LOWERCASE],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ListTransferResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listTransfer.value.add(result as TransferModel);
                }
                isLoadingTransfer.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  pageTransfer.value = (listTransfer.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoadingTransfer.value = false;
                }
              }
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
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}
