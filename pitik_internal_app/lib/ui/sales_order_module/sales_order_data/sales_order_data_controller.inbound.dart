part of 'sales_order_data_controller.dart';

extension InboundOrderController on SalesOrderController {
  void getListInboundGeneral() {
    resetAllBodyValue(bodyGeneralInbound);
    setGeneralheader(pageInbound.value, limit.value, EnumSO.inbound, bodyGeneralInbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralInbound(bodyGeneralInbound);
    }
    if (Constant.isScRelation.isTrue) {
      scRelationBodyGeneralInbound(bodyGeneralInbound);
    }
    if (Constant.isOpsLead.isTrue) {
      opsLeadBodyGeneralInbound(bodyGeneralInbound);
    }
    if (Constant.isShopKepper.isTrue) {
      shopkeeperBodyGeneralInbound(bodyGeneralInbound);
    }
    fetchOrder(bodyGeneralInbound, responInbound());
  }

  void salesBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
  }

  void shopkeeperBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
  }

  void scRelationBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.status1.index] = EnumSO.draft;
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
  }

  void opsLeadBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
    bodyGeneral[BodyQuerySales.withinProductionTeam.index] = "true";
  }

  void salesLeadBodyGeneralInbound(List<dynamic> bodyGeneral) {
    bodyGeneral[BodyQuerySales.createdBy.index] = Constant.profileUser?.id;
    bodyGeneral[BodyQuerySales.withSalesTeam.index] = "true";
    bodyGeneral[BodyQuerySales.status2.index] = EnumSO.confirmed;
    bodyGeneral[BodyQuerySales.status3.index] = EnumSO.booked;
    bodyGeneral[BodyQuerySales.status4.index] = EnumSO.cancelled;
    bodyGeneral[BodyQuerySales.status5.index] = EnumSO.delivered;
  }

  ResponseListener responInbound() {
    return ResponseListener(
        onResponseDone: (code, message, body, id, packet) {
          if ((body as SalesOrderListResponse).data.isNotEmpty) {
            for (var result in body.data) {
              orderListInbound.add(result as Order);
            }
            if (isLoadMore.isTrue) {
              isLoadingInbound.value = false;
              isLoadMore.value = false;
              isLoadData.value = false;
            } else {
              isLoadingInbound.value = false;
              isLoadData.value = false;
            }
          } else {
            if (isLoadMore.isTrue) {
              page.value = (orderListInbound.length ~/ 10).toInt() + 1;
              isLoadMore.value = false;
              isLoadingInbound.value = false;
              isLoadData.value = false;
            } else {
              isLoadingInbound.value = false;
              isLoadData.value = false;
            }
          }
        },
        onResponseFail: (code, message, body, id, packet) {
          onResponseFail(body, isLoadingInbound);
        },
        onResponseError: (exception, stacktrace, id, packet) {
          onResponseError(isLoadingInbound);
        },
        onTokenInvalid: Constant.invalidResponse());
  }

  void searchOrderInbound() {
    resetAllBodyValue(bodyGeneralInbound);
    setGeneralheader(pageInbound.value, limit.value, EnumSO.inbound, bodyGeneralInbound);
    if (Constant.isSales.isTrue) {
      salesBodyGeneralInbound(bodyGeneralInbound);
    } else if (Constant.isSalesLead.isTrue) {
      salesLeadBodyGeneralInbound(bodyGeneralInbound);
    }
    if (Constant.isScRelation.isTrue) {
      scRelationBodyGeneralInbound(bodyGeneralInbound);
    }
    if (Constant.isOpsLead.isTrue) {
      opsLeadBodyGeneralInbound(bodyGeneralInbound);
    }
    if (Constant.isShopKepper.isTrue) {
      shopkeeperBodyGeneralInbound(bodyGeneralInbound);
    }
    if (selectedValue.value == "Customer") {
      bodyGeneralInbound[BodyQuerySales.customerName.index] = searchValue.value;
    } else {
      bodyGeneralInbound[BodyQuerySales.code.index] = searchValue.value;
    }

    fetchOrder(bodyGeneralInbound, responInbound());
  }

  void getFilterInbound() {
    Location? provinceSelect;

    if (spProvince.controller.textSelected.value.isNotEmpty) {
        if(province.isNotEmpty) {
            provinceSelect = province.firstWhereOrNull(
                (element) => element!.provinceName == spProvince.controller.textSelected.value,
            );
        }
    }

    Location? citySelect;
    if (spCity.controller.textSelected.value.isNotEmpty) {
        if(city.isNotEmpty) {
            citySelect = city.firstWhereOrNull(
                (element) => element!.cityName == spCity.controller.textSelected.value,
            );
        }
    }

    SalesPerson? salesSelect;
    if (spCreatedBy.controller.textSelected.value.isNotEmpty) {
        if(listSalesperson.isNotEmpty) {
            salesSelect = listSalesperson.firstWhereOrNull(
                (element) => element!.email == spCreatedBy.controller.textSelected.value,
            );
        }
    }

    CategoryModel? categorySelect;
    if (spCategory.controller.textSelected.value.isNotEmpty) {
        if(listCategory.isNotEmpty) {
            categorySelect = listCategory.firstWhereOrNull(
                (element) => element!.name == spCategory.controller.textSelected.value,
            );
        }
    }

    Products? productSelect;
    if (spSku.controller.textSelected.value.isNotEmpty) {
        if(listProduct.isNotEmpty) {
            productSelect = listProduct.firstWhereOrNull(
                (element) => element!.name == spSku.controller.textSelected.value,
            );
        }
    }

    OperationUnitModel? operationUnitSelect;
    if (spSource.controller.textSelected.value.isNotEmpty) {
        if(listOperationUnits.isNotEmpty) {
            operationUnitSelect = listOperationUnits.firstWhereOrNull(
                (element) => element!.operationUnitName == spSource.controller.textSelected.value,
            );
        }
    }
    Branch? branchSelect;
    if (spSalesBranch.controller.textSelected.value.isNotEmpty) {
        if(listBranch.isNotEmpty) {
            branchSelect = listBranch.firstWhereOrNull(
                (element) => element!.name == spSalesBranch.controller.textSelected.value,
            );
        }
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
    resetAllBodyValue(bodyGeneralInbound);
    setGeneralheader(pageInbound.value, limit.value, EnumSO.inbound, bodyGeneralInbound);
    bodyGeneralInbound[BodyQuerySales.status.index] = status; // status
    bodyGeneralInbound[BodyQuerySales.customerCityId.index] = citySelect?.id; // customerCityId
    bodyGeneralInbound[BodyQuerySales.customerProvinceId.index] = provinceSelect?.id; // customerProvinceId
    bodyGeneralInbound[BodyQuerySales.date.index] = date; // date
    bodyGeneralInbound[BodyQuerySales.operationUnitId.index] = operationUnitSelect?.id; // operationUnitId
    bodyGeneralInbound[BodyQuerySales.productCategoryId.index] = categorySelect?.id; // categoryId
    bodyGeneralInbound[BodyQuerySales.productItemId.index] = productSelect?.id; // productId
    bodyGeneralInbound[BodyQuerySales.minQuantityRange.index] = efMin.getInputNumber() != null ? (efMin.getInputNumber() ?? 0).toInt() : null; // minQuantityRange
    bodyGeneralInbound[BodyQuerySales.maxRangeQuantity.index] = efMax.getInputNumber() != null ? (efMax.getInputNumber() ?? 0).toInt() : null; // maxRangeQuantity
    bodyGeneralInbound[BodyQuerySales.salesBranch.index] = branchSelect?.id; // branchId
    bodyGeneralInbound[BodyQuerySales.minDeliveryTime.index] = minDeliveryDate; // deliveryDate
    bodyGeneralInbound[BodyQuerySales.maxDeliveryTime.index] = maxDeliveryDate; // deliveryDate

    if (Constant.isSales.isTrue) {
      if (status == null) {
        salesBodyGeneralInbound(bodyGeneralInbound);
      } else {
        bodyGeneralInbound[BodyQuerySales.salesPersonId.index] = Constant.profileUser?.id;
      }
    } else if (Constant.isShopKepper.isTrue || Constant.isOpsLead.isTrue || Constant.isScRelation.isTrue) {
      if (status == null) {
        if (Constant.isScRelation.isTrue) {
          scRelationBodyGeneralInbound(bodyGeneralInbound);
        }
        if (Constant.isOpsLead.isTrue) {
          opsLeadBodyGeneralInbound(bodyGeneralInbound);
        }
        if (Constant.isShopKepper.isTrue) {
          shopkeeperBodyGeneralInbound(bodyGeneralInbound);
        }
      }
      bodyGeneralInbound[BodyQuerySales.withinProductionTeam.index] = "true";
    } else if (Constant.isSalesLead.isTrue) {
      if (status == null) {
        salesLeadBodyGeneralInbound(bodyGeneralInbound);
      } else {
        bodyGeneralInbound[BodyQuerySales.withSalesTeam.index] = "true";
      }
    }

    bodyGeneralInbound[BodyQuerySales.createdBy.index] = salesSelect?.id; //createdBy
    fetchOrder(bodyGeneralInbound, responInbound());
  }
}
