import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 09/05/23


@SetupModel
class PurchaseRequest{

  String? vendorId;
  String? operationUnitId;
  String? purchaseOrderId;
  String? internalTransferId;
  String? salesOrderId;
  String? status;
  String? jagalId;

  @IsChildren()
  List<Products?>? products;


  PurchaseRequest({this.vendorId, this.operationUnitId, this.status, this.products, this.purchaseOrderId, this.internalTransferId, this.salesOrderId, this.jagalId});

  static PurchaseRequest toResponseModel(Map<String, dynamic> map) {
    return PurchaseRequest(
      vendorId: map['vendorId'],
      operationUnitId: map['operationUnitId'],
      products: Mapper.children<Products>(map['products']),
      status: map['status'],
      purchaseOrderId: map['purchaseOrderId'],
      internalTransferId: map['internalTransferId'],
      salesOrderId: map['salesOrderId'],
      jagalId: map['jagalId'],
    );
  }
}