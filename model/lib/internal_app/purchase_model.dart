import 'package:model/engine_library.dart';
import 'package:model/internal_app/goods_received_model.dart';
import 'package:model/internal_app/product_model.dart';

import 'operation_unit_model.dart';
import 'vendor_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 04/04/23

@SetupModel
class Purchase {
  String? id;
  String? createdDate;
  String? createdBy;
  String? modifiedDate;
  String? modifiedBy;
  String? code;
  int? totalQuantity;
  double? totalWeight;
  double? totalPrice;

  String? vendorId;
  String? operationUnitId;
  String? purchaseOrderId;
  String? internalTransferId;
  String? salesOrderId;
  String? status;
  String? jagalId;
  String? remarks;

  @IsChild()
  VendorModel? vendor;
  @IsChild()
  OperationUnitModel? operationUnit;
  @IsChild()
  OperationUnitModel? jagal;
  @IsChild()
  GoodsReceived? goodsReceived;
  @IsChildren()
  List<Products?>? products;

  Purchase({
    this.id,
    this.vendor,
    this.operationUnit,
    this.status,
    this.products,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.code,
    this.goodsReceived,
    this.jagal,
    this.totalQuantity,
    this.totalPrice,
    this.totalWeight,
    this.vendorId,
    this.operationUnitId,
    this.purchaseOrderId,
    this.internalTransferId,
    this.salesOrderId,
    this.jagalId,
    this.remarks,
  });

  static Purchase toResponseModel(Map<String, dynamic> map) {
    if (map['totalWeight'] is int) {
      map['totalWeight'] = map['totalWeight'].toDouble();
    }
    if (map['totalPrice'] is int) {
      map['totalPrice'] = map['totalPrice'].toDouble();
    }
    return Purchase(
      id: map['id'],
      vendor: Mapper.child<VendorModel>(map['vendor']),
      operationUnit: Mapper.child<OperationUnitModel>(map['operationUnit']),
      products: Mapper.children<Products>(map['products']),
      status: map['status'],
      createdBy: map['createdBy'],
      createdDate: map['createdDate'],
      modifiedDate: map['modifiedDate'],
      code: map['code'],
      modifiedBy: map['modifiedBy'],
      goodsReceived: Mapper.child<GoodsReceived>(map['goodsReceived']),
      jagal: Mapper.child<OperationUnitModel>(map['jagal']),
      totalQuantity: map['totalQuantity'],
      totalPrice: map['totalPrice'],
      totalWeight: map['totalWeight'],
      vendorId: map['vendorId'],
      operationUnitId: map['operationUnitId'],
      purchaseOrderId: map['purchaseOrderId'],
      internalTransferId: map['internalTransferId'],
      salesOrderId: map['salesOrderId'],
      jagalId: map['jagalId'],
      remarks: map['remarks'],
    );
  }
}
