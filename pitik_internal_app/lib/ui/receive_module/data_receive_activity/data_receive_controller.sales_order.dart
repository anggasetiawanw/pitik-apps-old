part of 'data_receive_controller.dart';

extension ReturnReceiveController on ReceiveController {
  void resetAllBodyReturnValue() {
    pageOrder.value = 1;
    listReturn.value.clear();
    for (int i = 0; i < bodyGeneralReturn.length; i++) {
      bodyGeneralReturn[i] = null;
    }
    bodyGeneralReturn[BodyQueryReturn.token.index] = Constant.auth!.token;
    bodyGeneralReturn[BodyQueryReturn.auth.index] = Constant.auth!.id;
    bodyGeneralReturn[BodyQueryReturn.xAppId.index] = Constant.xAppId;
    bodyGeneralReturn[BodyQueryReturn.page.index] = pageOrder.value;
    bodyGeneralReturn[BodyQueryReturn.limit.index] = limit.value;
    bodyGeneralReturn[BodyQueryReturn.statusReceived.index] = "RECEIVED";
    bodyGeneralReturn[BodyQueryReturn.statusDelivered.index] = "REJECTED";
    bodyGeneralReturn[BodyQueryReturn.category.index] = "OUTBOUND";
    bodyGeneralReturn[BodyQueryReturn.withinProductionTeam.index] = AppStrings.TRUE_LOWERCASE;
  }

  void openFilterOrder() {
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    if (spCategory.controller.textSelected.isNotEmpty) {
      spSku.controller.enable();
    }
    spJenisSumber.controller.invisibleSpinner();
    spTujuan.controller.invisibleSpinner();
    getCategorySku();
    getListOperationUnit();
    showFilter();
  }

  void filterOrder() {
    resetAllBodyReturnValue();
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

    OperationUnitModel? sourceSelect;
    if (spSumber.controller.textSelected.value.isNotEmpty) {
      sourceSelect = listSourceOperationUnits.value.firstWhere(
        (element) => element!.operationUnitName == spSumber.controller.textSelected.value,
      );
    }
    String? status;
    String? returnStatus;

    if (spStatus.controller.textSelected.value.isNotEmpty) {
      bodyGeneralReturn[BodyQueryReturn.statusReceived.index] = null;
      bodyGeneralReturn[BodyQueryReturn.statusDelivered.index] = null;
    }
    switch (spStatus.controller.textSelected.value) {
      case "Ditolak":
        status = "REJECTED";
        returnStatus = "FULL";
        bodyGeneralReturn[BodyQueryReturn.statusDelivered.index] = "REJECTED";
        break;
      case "Terkirim Sebagian":
        status = "REJECTED";
        returnStatus = "PARTIAL";
        bodyGeneralReturn[BodyQueryReturn.statusDelivered.index] = "REJECTED";
        break;
      case "Diterima":
        bodyGeneralReturn[BodyQueryReturn.statusReceived.index] = "RECEIVED";
        break;
      default:
    }
    String? date = dtTanggalFilterReceive.controller.textSelected.value.isEmpty ? null : DateFormat("yyyy-MM-dd").format(dtTanggalFilterReceive.getLastTimeSelected());

    bodyGeneralReturn[BodyQueryReturn.productCategoryId.index] = categorySelect?.id;
    bodyGeneralReturn[BodyQueryReturn.productItemId.index] = productSelect?.id;
    bodyGeneralReturn[BodyQueryReturn.operationUnitId.index] = sourceSelect?.id;
    bodyGeneralReturn[BodyQueryReturn.status.index] = status;
    bodyGeneralReturn[BodyQueryReturn.returnStatus.index] = returnStatus;
    bodyGeneralReturn[BodyQueryReturn.createdDate.index] = date;
    isLoadingOrder.value = true;
    listReturn.value.clear();
    getListReturn();
  }

  scrollOrderListener() async {
    scrollOrderController.addListener(() {
      if (scrollOrderController.position.maxScrollExtent == scrollOrderController.position.pixels) {
        isLoadMore.value = true;
        pageOrder++;
        getListReturn();
      }
    });
  }

  void getListReturn() {
    Service.push(
        service: ListApi.getGoodReceiptsOrderList,
        context: context,
        body: bodyGeneralReturn,
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as SalesOrderListResponse).data.isNotEmpty) {
                for (var result in body.data) {
                  listReturn.value.add(result);
                }
                isLoadingOrder.value = false;
                if (isLoadMore.isTrue) {
                  isLoadMore.value = false;
                }
              } else {
                if (isLoadMore.isTrue) {
                  pageOrder.value = (listReturn.value.length ~/ 10).toInt() + 1;
                  isLoadMore.value = false;
                } else {
                  isLoadingOrder.value = false;
                }
              }
              countingApi();
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
              countingApi();
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
              countingApi();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }
}
