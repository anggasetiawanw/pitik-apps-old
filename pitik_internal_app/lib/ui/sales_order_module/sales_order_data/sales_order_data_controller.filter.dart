part of 'sales_order_data_controller.dart';

extension FilterOrderController on SalesOrderController {
  void openFilter() {
    if (spCity.controller.textSelected.isEmpty) {
      spCity.controller.disable();
    }
    if (spSku.controller.textSelected.isEmpty) {
      spSku.controller.disable();
    }
    if (spCategory.controller.textSelected.isNotEmpty) {
      spSku.controller.enable();
    }
    if (dtDeliveryTimeMin.controller.textSelected.isEmpty) {
      dtDeliveryTimeMin.controller.disable();
    }
    if (dtDeliveryTimeMax.controller.textSelected.isEmpty) {
      dtDeliveryTimeMax.controller.disable();
    }
    if (dfTanggalPengiriman.controller.textSelected.isNotEmpty) {
      dtDeliveryTimeMin.controller.enable();
      dtDeliveryTimeMax.controller.enable();
    }
    getSalesList();
    getProvince();
    getCategorySku();
    getListSource();
    getBranch();
    showFilter();
  }

  void saveFilter() {
    if (validationFilter()) {
      searchController.clear();
      listFilter.value.clear();
      if (dtTanggalPenjualan.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Penjualan"] = dtTanggalPenjualan.controller.textSelected.value;
      }
      if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Dibuat Oleh"] = spCreatedBy.controller.textSelected.value;
      }
      if (spProvince.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Province"] = spProvince.controller.textSelected.value;
      }
      if (spCity.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Kota"] = spCity.controller.textSelected.value;
      }
      if (efMin.getInput().isNotEmpty) {
        listFilter.value["Rentang Min"] = efMin.getInput();
      }
      if (efMax.getInput().isNotEmpty) {
        listFilter.value["Rentang Max"] = efMax.getInput();
      }
      if (spStatus.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Status"] = spStatus.controller.textSelected.value;
      }
      if (spCategory.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Kategori"] = spCategory.controller.textSelected.value;
      }
      if (spSku.controller.textSelected.value.isNotEmpty) {
        listFilter.value["SKU"] = spSku.controller.textSelected.value;
      }
      if (spSource.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Sumber"] = spSource.controller.textSelected.value;
      }

      if (spSalesBranch.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Sales Branch"] = spSalesBranch.controller.textSelected.value;
      }
      if (dfTanggalPengiriman.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Pengiriman"] = dfTanggalPengiriman.controller.textSelected.value;
      }

      if (dtDeliveryTimeMax.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Pengiriman Min"] = DateFormat("HH:mm").format(dtDeliveryTimeMin.getLastTimeSelected());
      }
      if (dtDeliveryTimeMin.controller.textSelected.value.isNotEmpty) {
        listFilter.value["Tanggal Pengiriman Max"] = DateFormat("HH:mm").format(dtDeliveryTimeMax.getLastTimeSelected());
      }

      listFilter.refresh();
      Get.back();
      isFilter.value = true;
      isSearch.value = false;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getFilterInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getFilterOutbound();
      }
    }
  }

  bool validationFilter() {
    if (efMax.getInput().isNotEmpty && efMin.getInput().isNotEmpty) {
      print("masuk sini");
      if (efMin.getInputNumber()! > efMax.getInputNumber()!) {
        Get.snackbar(
          "Oops",
          "Rentang Min Harus Lebih Kecil Dari Rentang Max",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return false;
      }
    } else if (efMax.getInput().isNotEmpty) {
      if (efMin.getInput().isEmpty) {
        efMin.controller.showAlert();
        efMax.controller.showAlert();
        return false;
      }
    } else if (efMin.getInput().isNotEmpty) {
      if (efMax.getInput().isEmpty) {
        efMax.controller.showAlert();
        efMin.controller.showAlert();
        return false;
      }
    }

    if (dtDeliveryTimeMax.controller.textSelected.value.isNotEmpty && dtDeliveryTimeMin.controller.textSelected.value.isNotEmpty) {
      if ((dtDeliveryTimeMax.getLastTimeSelected().hour * 60 + dtDeliveryTimeMax.getLastTimeSelected().minute) < (dtDeliveryTimeMin.getLastTimeSelected().hour * 60 + dtDeliveryTimeMin.getLastTimeSelected().minute)) {
        Get.snackbar(
          "Oops",
          "Waktu Pengiriman Min Harus Lebih Kecil Dari Waktu Pengiriman Max",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return false;
      }
    }
    if (dtDeliveryTimeMin.controller.textSelected.value.isNotEmpty) {
      if (dtDeliveryTimeMax.controller.textSelected.value.isEmpty) {
        dtDeliveryTimeMin.controller.showAlert();
        dtDeliveryTimeMax.controller.showAlert();
        return false;
      }
    } else if (dtDeliveryTimeMax.controller.textSelected.value.isNotEmpty) {
      if (dtDeliveryTimeMin.controller.textSelected.value.isEmpty) {
        dtDeliveryTimeMin.controller.showAlert();
        dtDeliveryTimeMax.controller.showAlert();
        return false;
      }
    }
    return true;
  }

  void clearFilter() {
    listFilter.value.clear();
    listFilter.refresh();
    dtTanggalPenjualan.controller.setTextSelected("");
    spCreatedBy.controller.setTextSelected("");
    spProvince.controller.setTextSelected("");
    spCity.controller.setTextSelected("");
    spCity.controller.disable();
    efMin.setInput("");
    efMax.setInput("");
    efMax.controller.hideAlert();
    efMin.controller.hideAlert();
    spStatus.controller.setTextSelected("");
    spCategory.controller.setTextSelected("");
    spSku.controller.setTextSelected("");
    spSku.controller.disable();
    spSource.controller.setTextSelected("");
    spSalesBranch.controller.setTextSelected("");
    dfTanggalPengiriman.controller.setTextSelected("");
    dtDeliveryTimeMin.controller.setTextSelected("");
    dtDeliveryTimeMin.controller.disable();
    dtDeliveryTimeMin.controller.hideAlert();
    dtDeliveryTimeMax.controller.setTextSelected("");
    dtDeliveryTimeMax.controller.disable();
    dtDeliveryTimeMax.controller.hideAlert();
    Get.back();
    if (isOutbondTab.isFalse) {
      orderListInbound.clear();
      pageInbound.value = 1;
      isLoadData.value = true;
      getListInboundGeneral();
    } else {
      orderListOutbound.clear();
      pageOutbound.value = 1;
      isLoadData.value = true;
      getListOutboundGeneral();
    }
  }

  void removeOneFilter(String key) {
    switch (key) {
      case "Tanggal Penjualan":
        dtTanggalPenjualan.controller.setTextSelected("");
        break;
      case "Dibuat Oleh":
        spCreatedBy.controller.setTextSelected("");
        break;
      case "Province":
        spProvince.controller.setTextSelected("");
        break;
      case "Kota":
        spCity.controller.setTextSelected("");
        break;
      case "Rentang Min":
        listFilter.value.remove("Rentang Max");
        efMin.setInput("");
        efMax.setInput("");
        break;
      case "Rentang Max":
        listFilter.value.remove("Rentang Min");
        efMin.setInput("");
        efMax.setInput("");
        break;
      case "Status":
        spStatus.controller.setTextSelected("");
        break;
      case "Kategori":
        spCategory.controller.setTextSelected("");
        spSku.controller.setTextSelected("");
        listFilter.value.remove("SKU");
        break;
      case "SKU":
        spSku.controller.setTextSelected("");
        break;
      case "Sumber":
        spSource.controller.setTextSelected("");
        break;
      case "Sales Branch":
        spSalesBranch.controller.setTextSelected("");
        break;
      case "Tanggal Pengiriman":
        dfTanggalPengiriman.controller.setTextSelected("");
        break;
      case "Tanggal Pengiriman Min":
        dtDeliveryTimeMin.controller.setTextSelected("");
        dtDeliveryTimeMax.controller.setTextSelected("");
        break;
      case "Tanggal Pengiriman Max":
        dtDeliveryTimeMax.controller.setTextSelected("");
        dtDeliveryTimeMin.controller.setTextSelected("");
        break;

      default:
    }

    listFilter.value.remove(key);
    listFilter.refresh();
    if (listFilter.value.isEmpty) {
      orderListOutbound.clear();
      page.value = 1;
      isFilter.value = false;
      isSearch.value = false;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getListInboundGeneral();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getListOutboundGeneral();
      }
    } else {
      page.value = 1;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getFilterInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getFilterOutbound();
      }
    }
  }

  void pullRefresh() {
    orderListOutbound.clear();
    if (isSearch.isTrue) {
      page.value = 1;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        searchOrderInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        searchOrderOutbound();
      }
    } else if (isFilter.isTrue) {
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getFilterInbound();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getFilterOutbound();
      }
    } else if (isSearch.isFalse && isFilter.isFalse) {
      page.value = 1;
      isLoadData.value = true;
      if (isOutbondTab.isFalse) {
        orderListInbound.clear();
        pageInbound.value = 1;
        isLoadData.value = true;
        getListInboundGeneral();
      } else {
        orderListOutbound.clear();
        pageOutbound.value = 1;
        isLoadData.value = true;
        getListOutboundGeneral();
      }
    }
  }

  showFilter() {
    if (isOutbondTab.isTrue) {
      spStatus.controller.generateItems(mapStatusOutbond);
    } else {
      spStatus.controller.generateItems(mapStatusInbound);
    }
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.90,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
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
                      Expanded(
                        child: RawScrollbar(
                          //   controller: controller.scrollControllerInbound,
                          // thumbVisibility: true,
                          // trackVisibility: true,
                          thumbColor: AppColors.primaryOrange,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                dtTanggalPenjualan,
                                dfTanggalPengiriman,
                                Row(
                                  children: [
                                    Expanded(child: dtDeliveryTimeMin),
                                    const SizedBox(width: 8),
                                    Expanded(child: dtDeliveryTimeMax),
                                  ],
                                ),
                                spCreatedBy,
                                spSalesBranch,
                                spCategory,
                                spSku,
                                spSource,
                                spProvince,
                                spCity,
                                Row(
                                  children: [
                                    Expanded(child: efMin),
                                    const SizedBox(width: 8),
                                    Expanded(child: efMax),
                                  ],
                                ),
                                spStatus,
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: btKormasiFilter),
                        const SizedBox(width: 8),
                        Expanded(child: btBersihkanFilter),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void getProvince() {
    spProvince.controller
      ..disable()
      ..showLoading();
    Service.pushWithIdAndPacket(service: ListApi.getProvince, context: context, id: 1, packet: [province, spProvince], body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!], listener: locationListerner());
  }

  void getCity(Location province) {
    spCity.controller
      ..disable()
      ..showLoading();
    Service.pushWithIdAndPacket(service: ListApi.getCity, context: context, id: 2, packet: [city, spCity], body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, province.id], listener: locationListerner());
  }

  ResponseListener locationListerner() {
    return ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
          Map<String, bool> mapList = {};
          for (var location in (body as LocationListResponse).data) {
            if (id == 1) {
              mapList[location!.provinceName!] = false;
            } else {
              mapList[location!.cityName!] = false;
            }
          }
          for (var result in body.data) {
            (packet[0] as RxList<Location?>).add(result);
          }
          (packet[1] as SpinnerSearch).controller
            ..generateItems(mapList)
            ..enable()
            ..hideLoading();
        },
        onResponseFail: (code, message, body, id, packet) {
          (packet[1] as SpinnerSearch).controller
            ..enable()
            ..hideLoading();
          Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        },
        onResponseError: (exception, stacktrace, id, packet) {
          (packet[1] as SpinnerSearch).controller
            ..enable()
            ..hideLoading();
          Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
        },
        onTokenInvalid: Constant.invalidResponse());
  }

  void getSalesList() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              spCreatedBy.controller
                ..showLoading()
                ..disable(),
              Service.push(
                  apiKey: "api",
                  service: ListApi.getSalesList,
                  context: context,
                  body: ['Bearer ${auth.token}', auth.id, Constant.xAppId!, "sales,sales lead", 1, 0],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        for (var result in (body as SalespersonListResponse).data) {
                          listSalesperson.add(result);
                        }
                        Map<String, bool> mapList = {};
                        for (var product in body.data) {
                          mapList[product!.email!] = false;
                        }
                        spCreatedBy.controller.generateItems(mapList);
                        spCreatedBy.controller.enable();
                        spCreatedBy.controller.hideLoading();
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        spCreatedBy.controller.hideLoading();
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan Internal",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        spCreatedBy.controller.hideLoading();
                      },
                      onTokenInvalid: () => Constant.invalidResponse()))
            }
          else
            {Constant.invalidResponse()}
        });
  }

  void getCategorySku() {
    spCategory.controller.disable();
    spCategory.controller.showLoading();
    spCategory.controller.setTextSelected("Loading...");
    Service.push(
      service: ListApi.getCategories,
      context: context,
      body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!],
      listener: ResponseListener(
          onResponseDone: (code, message, body, id, packet) {
            for (var result in (body as CategoryListResponse).data) {
              listCategory.add(result);
            }
            Map<String, bool> mapList = {};
            for (var product in body.data) {
              mapList[product!.name!] = false;
            }
            spCategory.controller.enable();
            if (listFilter.value["Kategori"] != null) {
              spCategory.controller.setTextSelected(listFilter.value["Kategori"]!);
            } else {
              spCategory.controller.setTextSelected("");
            }
            spCategory.controller.hideLoading();
            spCategory.controller.generateItems(mapList);
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
            spCategory.controller.disable();
            spCategory.controller.setTextSelected("");
            spCategory.controller.hideLoading();
          },
          onResponseError: (exception, stacktrace, id, packet) {
            Get.snackbar(
              "Pesan",
              "Terjadi KesalahanInternal",
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
            spCategory.controller.disable();
            spCategory.controller.setTextSelected("");
            spCategory.controller.hideLoading();
          },
          onTokenInvalid: Constant.invalidResponse()),
    );
  }

  void getListSource() {
    spSource.controller
      ..disable()
      ..setTextSelected("Loading...")
      ..showLoading();
    Service.push(
        service: ListApi.getListOperationUnits,
        context: context,
        body: [Constant.auth!.token!, Constant.auth!.id, Constant.xAppId, AppStrings.TRUE_LOWERCASE, AppStrings.INTERNAL, null, 0],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              Map<String, bool> mapList = {};
              for (var units in (body as ListOperationUnitsResponse).data) {
                mapList[units!.operationUnitName!] = false;
              }
              for (var result in body.data) {
                listOperationUnits.add(result);
              }

              spSource.controller
                ..enable()
                ..setTextSelected("")
                ..hideLoading();

              spSource.controller.generateItems(mapList);
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
              spSource.controller
                ..setTextSelected("")
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
              spSource.controller
                ..setTextSelected("")
                ..hideLoading();
            },
            onTokenInvalid: Constant.invalidResponse()));
  }

  void getSku(String categoriId) {
    Service.push(
        service: ListApi.getProductById,
        context: context,
        body: [Constant.auth!.token, Constant.auth!.id, Constant.xAppId!, categoriId],
        listener: ResponseListener(
            onResponseDone: (code, message, body, id, packet) {
              if ((body as ProductListResponse).data[0]!.uom.runtimeType != Null) {
                Map<String, bool> mapList = {};
                for (var product in body.data) {
                  mapList[product!.name!] = false;
                }
                for (var result in (body).data) {
                  listProduct.add(result);
                }
                spSku.controller.generateItems(mapList);
                spSku.controller.enable();
              } else {
                spSku.controller.disable();
              }
            },
            onResponseFail: (code, message, body, id, packet) {
              Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
            },
            onResponseError: (exception, stacktrace, id, packet) {
              Get.snackbar("Alert", "Terjadi kesalahan internal", snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
            },
            onTokenInvalid: () {}));
  }

  void getBranch() {
    AuthImpl().get().then((auth) => {
          if (auth != null)
            {
              spSalesBranch.controller
                ..showLoading()
                ..disable(),
              Service.push(
                  apiKey: ApiMapping.api,
                  service: ListApi.getBranch,
                  context: context,
                  body: [
                    'Bearer ${auth.token}',
                    auth.id,
                    Constant.xAppId,
                  ],
                  listener: ResponseListener(
                      onResponseDone: (code, message, body, id, packet) {
                        for (var result in (body as ListBranchResponse).data) {
                          listBranch.add(result);
                        }

                        Map<String, bool> mapList = {};
                        for (var branch in body.data) {
                          mapList[branch!.name!] = false;
                        }
                        spSalesBranch.controller.hideLoading();
                        spSalesBranch.controller.enable();
                        spSalesBranch.controller.generateItems(mapList);
                      },
                      onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        spSalesBranch.controller.hideLoading();
                      },
                      onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar(
                          "Pesan",
                          "Terjadi Kesalahan Internal",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                        spSalesBranch.controller.hideLoading();
                      },
                      onTokenInvalid: () => Constant.invalidResponse()))
            }
          else
            {Constant.invalidResponse()}
        });
  }
}
