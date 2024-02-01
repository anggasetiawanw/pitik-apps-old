part of 'sales_order_data_controller.dart';

extension OutboundOrderController on SalesOrderController {
  void getListOutboundGeneral() {
    resetAllBodyValue(bodyGeneralOutbound);
    setGeneralheader(pageOutbound.value, limit.value, EnumSO.outbound, bodyGeneralOutbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue) {
      shopkeeperBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralOutbound(bodyGeneralOutbound);
    }
    if (Constant.isScRelation.isTrue) {
      scRelationdBodyGeneralOutbound(bodyGeneralOutbound);
    }
    fetchOrder(bodyGeneralOutbound, responOutbound());
  }

  void shopkeeperBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status6.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
  }

  void salesBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.salesPersonId.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status6.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
  }

  void salesLeadBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.withSalesTeam.index] = "true";
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status6.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
  }

  void scRelationdBodyGeneralOutbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = null;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status9.index] = EnumSO.allocated;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.readyToDeliver;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.status7.index] = EnumSO.rejected;
    bodyGeneral[BodyQuerySales.status8.index] = EnumSO.onDelivery;
  }

  ResponseListener responOutbound() {
    return ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
          if ((body as SalesOrderListResponse).data.isNotEmpty) {
            for (var result in body.data) {
              orderListOutbound.add(result as Order);
            }
            if (isLoadMore.isTrue) {
              isLoadingOutbond.value = false;
              isLoadMore.value = false;
              isLoadData.value = false;
            } else {
              isLoadingOutbond.value = false;
              isLoadData.value = false;
            }
          } else {
            if (isLoadMore.isTrue) {
              page.value = (orderListOutbound.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
              isLoadingOutbond.value = false;
              isLoadData.value = false;
            } else {
              isLoadingOutbond.value = false;
              isLoadData.value = false;
            }
          }
          if(isInit){
            isInit = false;
            timeEnd = DateTime.now();
            Duration totalTime = timeEnd.difference(timeStart);
            Constant.trackRenderTime("Penjualan", totalTime);
          }
        },
        onResponseFail: (code, message, body, id, packet) {
          onResponseFail(body, isLoadingOutbond);
        },
        onResponseError: (exception, stacktrace, id, packet) {
          onResponseError(isLoadingOutbond);
        },
        onTokenInvalid: Constant.invalidResponse());
  }

  void searchOrderOutbound() {
    resetAllBodyValue(bodyGeneralOutbound);
    setGeneralheader(pageOutbound.value, limit.value, EnumSO.outbound, bodyGeneralOutbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue) {
      shopkeeperBodyGeneralOutbound(bodyGeneralOutbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralOutbound(bodyGeneralOutbound);
    }
    if (Constant.isScRelation.isTrue) {
      scRelationdBodyGeneralOutbound(bodyGeneralOutbound);
    }
    if (selectedValue.value == "Customer") {
      bodyGeneralOutbound[BodyQuerySales.customerName.index] = searchValue.value;
    } else {
      bodyGeneralOutbound[BodyQuerySales.code.index] = searchValue.value;
    }

    fetchOrder(bodyGeneralOutbound, responOutbound());
  }

  void getFilterOutbound() {
    Location? provinceSelect;

    if (spProvince.controller.textSelected.value.isNotEmpty) {
      provinceSelect = province.firstWhereOrNull(
        (element) => element!.provinceName == spProvince.controller.textSelected.value,
      );
    }

    Location? citySelect;
    if (spCity.controller.textSelected.value.isNotEmpty) {
      citySelect = city.firstWhereOrNull(
        (element) => element!.cityName == spCity.controller.textSelected.value,
      );
    }

    SalesPerson? salesSelect;
    if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
      salesSelect = listSalesperson.firstWhereOrNull(
        (element) => element!.email == spCreatedBy.controller.textSelected.value,
      );
    }

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

    OperationUnitModel? operationUnitSelect;
    if (spSource.controller.textSelected.value.isNotEmpty) {
      operationUnitSelect = listOperationUnits.firstWhere(
        (element) => element!.operationUnitName == spSource.controller.textSelected.value,
      );
    }
    Branch? branchSelect;
    if (spSalesBranch.controller.textSelected.value.isNotEmpty) {
      branchSelect = listBranch.firstWhere(
        (element) => element!.name == spSalesBranch.controller.textSelected.value,
      );
    }

    String? status;
    switch (spStatus.controller.textSelected.value) {
      case "Draft":
        status = "DRAFT";
        break;
      case "Terkonfirmasi":
        status = "CONFIRMED";
        break;
      case "Teralokasi":
        status = "ALLOCATED";
        break;
      case "Dipesan":
        status = "BOOKED";
        break;
      case "Siap Dikirim":
        status = "READY_TO_DELIVER";
        break;
      case "Perjalanan":
        status = "ON_DELIVERY";
        break;
      case "Terkirim":
        status = "DELIVERED";
        break;
      case "Ditolak":
        status = "REJECTED";
        break;
      case "Batal":
        status = "CANCELLED";
        break;
      default:
    }
    String? date = dtTanggalPenjualan.controller.textSelected.value.isEmpty ? null : DateFormat("yyyy-MM-dd").format(dtTanggalPenjualan.getLastTimeSelected());
    resetAllBodyValue(bodyGeneralOutbound);
    setGeneralheader(pageOutbound.value, limit.value, EnumSO.outbound, bodyGeneralOutbound);
    String? minDeliveryDate;
    String? maxDeliveryDate;
    if (dtDeliveryTimeMax.controller.textSelected.value.isNotEmpty && dtDeliveryTimeMin.controller.textSelected.value.isNotEmpty) {
      DateTime deliveryDate = dfTanggalPengiriman.getLastTimeSelected();
      DateTime deliveryTimeMin = dtDeliveryTimeMin.getLastTimeSelected();
      minDeliveryDate = Convert.getStringIso(DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day, deliveryTimeMin.hour, deliveryTimeMin.minute));
      DateTime deliveryTimeMax = dtDeliveryTimeMax.getLastTimeSelected();
      maxDeliveryDate = Convert.getStringIso(DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day, deliveryTimeMax.hour, deliveryTimeMax.minute));
    } else if (dtDeliveryTimeMax.controller.textSelected.value.isEmpty && dtDeliveryTimeMin.controller.textSelected.value.isEmpty && dfTanggalPengiriman.controller.textSelected.value.isNotEmpty) {
      DateTime deliveryDate = dfTanggalPengiriman.getLastTimeSelected();
      minDeliveryDate = Convert.getStringIso(DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day, 0, 0));
      maxDeliveryDate = Convert.getStringIso(DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day, 23, 59));
    }

    bodyGeneralOutbound[BodyQuerySales.status.index] = status; // status
    bodyGeneralOutbound[BodyQuerySales.customerCityId.index] = citySelect?.id; // customerCityId
    bodyGeneralOutbound[BodyQuerySales.customerProvinceId.index] = provinceSelect?.id; // customerProvinceId
    bodyGeneralOutbound[BodyQuerySales.date.index] = date; // date
    bodyGeneralOutbound[BodyQuerySales.operationUnitId.index] = operationUnitSelect?.id; // operationUnitId
    bodyGeneralOutbound[BodyQuerySales.productCategoryId.index] = categorySelect?.id; // categoryId
    bodyGeneralOutbound[BodyQuerySales.productItemId.index] = productSelect?.id; // productId
    bodyGeneralOutbound[BodyQuerySales.minQuantityRange.index] = efMin.getInputNumber() != null ? (efMin.getInputNumber() ?? 0).toInt() : null; // minQuantityRange
    bodyGeneralOutbound[BodyQuerySales.maxRangeQuantity.index] = efMax.getInputNumber() != null ? (efMax.getInputNumber() ?? 0).toInt() : null; // maxRangeQuantity
    bodyGeneralOutbound[BodyQuerySales.salesBranch.index] = branchSelect?.id; // branchId
    bodyGeneralOutbound[BodyQuerySales.minDeliveryTime.index] = minDeliveryDate; // deliveryDate
    bodyGeneralOutbound[BodyQuerySales.maxDeliveryTime.index] = maxDeliveryDate; // deliveryDate

    if (Constant.isSales.isTrue) {
      if (status == null) {
        salesBodyGeneralOutbound(bodyGeneralOutbound);
      } else {
        bodyGeneralOutbound[BodyQuerySales.salesPersonId.index] = Constant.profileUser?.id;
      }
    } else if ((Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue)) {
      if (status == null) {
        shopkeeperBodyGeneralOutbound(bodyGeneralOutbound);
      }
      bodyGeneralOutbound[BodyQuerySales.withinProductionTeam.index] = "true";
    } else if (Constant.isSalesLead.isTrue) {
      if (status == null) {
        salesLeadBodyGeneralOutbound(bodyGeneralOutbound);
      }
      bodyGeneralOutbound[BodyQuerySales.withSalesTeam.index] = "true";
    }
    if (Constant.isScRelation.isTrue) {
      if (status == null) {
        scRelationdBodyGeneralOutbound(bodyGeneralOutbound);
      } else {
        bodyGeneralOutbound[BodyQuerySales.withinProductionTeam.index] = null;
      }
    }
    bodyGeneralOutbound[BodyQuerySales.createdBy.index] = salesSelect?.id; // createdBy
    fetchOrder(bodyGeneralOutbound, responOutbound());
  }
}
