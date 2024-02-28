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
    bodyGeneralTransfer[BodyQueryTransfer.statusReceived.index] = 'RECEIVED';
    bodyGeneralTransfer[BodyQueryTransfer.statusDelivered.index] = 'DELIVERED';
    bodyGeneralTransfer[BodyQueryTransfer.withinProductionTeam.index] = AppStrings.TRUE_LOWERCASE;
  }

  void openFilterTransfer() {
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    if (spCategory.controller.textSelected.isNotEmpty) {
      spSku.controller.enable();
    }
    spJenisSumber.controller.invisibleSpinner();
    spTujuan.controller.visibleSpinner();
    getCategorySku();
    getListOperationUnit();
    getListDestinationOperationUnit();
    showFilter();
  }

  void filterTransfer() {
    resetAllBodyTransferValue();
    CategoryModel? categorySelect;
    if (spCategory.controller.textSelected.value.isNotEmpty) {
      categorySelect = listCategory.firstWhereOrNull(
        (element) => element!.name == spCategory.controller.textSelected.value,
      );
    }

    Products? productSelect;
    if (spSku.controller.textSelected.value.isNotEmpty) {
      productSelect = listProduct.firstWhereOrNull(
        (element) => element!.name == spSku.controller.textSelected.value,
      );
    }

    OperationUnitModel? destinationSelect;
    if (spTujuan.controller.textSelected.value.isNotEmpty) {
      destinationSelect = listDestinationOperationUnits.value.firstWhere(
        (element) => element!.operationUnitName == spTujuan.controller.textSelected.value,
      );
    }

    OperationUnitModel? sourceSelect;
    if (spSumber.controller.textSelected.value.isNotEmpty) {
      sourceSelect = listSourceOperationUnits.value.firstWhere(
        (element) => element!.operationUnitName == spSumber.controller.textSelected.value,
      );
    }
    if (sourceSelect != null) {
      bodyGeneralTransfer[BodyQueryTransfer.source.index] = sourceSelect.type;
    }
    String? status;
    switch (spStatus.controller.textSelected.value) {
      case 'Terkirim':
        status = 'DELIVERED';
        break;
      case 'Diterima':
        status = 'RECEIVED';
        break;
      default:
    }
    if (status != null) {
      bodyGeneralTransfer[BodyQueryTransfer.statusReceived.index] = null;
      bodyGeneralTransfer[BodyQueryTransfer.statusDelivered.index] = null;
    }
    final String? date = dtTanggalFilterReceive.controller.textSelected.value.isEmpty ? null : DateFormat('yyyy-MM-dd').format(dtTanggalFilterReceive.getLastTimeSelected());

    bodyGeneralTransfer[BodyQueryTransfer.productCategoryId.index] = categorySelect?.id;
    bodyGeneralTransfer[BodyQueryTransfer.productItemId.index] = productSelect?.id;
    bodyGeneralTransfer[BodyQueryTransfer.targetOperationUnitId.index] = destinationSelect?.id;
    bodyGeneralTransfer[BodyQueryTransfer.sourceOperationUnitId.index] = sourceSelect?.id;
    bodyGeneralTransfer[BodyQueryTransfer.status.index] = status;
    bodyGeneralTransfer[BodyQueryTransfer.createdDate.index] = date;
    isLoadingTransfer.value = true;
    listTransfer.value.clear();
    getListTransfer();
  }

  void scrollTransferListener() {
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
              final Map<String, bool> mapList3 = {};
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
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
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
              final Map<String, bool> mapList = {};
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
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
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
                'Pesan',
                'Terjadi kesalahan internal',
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
                'Pesan',
                'Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.red,
              );
              isLoadingTransfer.value = false;
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
              isLoadingTransfer.value = false;
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}
