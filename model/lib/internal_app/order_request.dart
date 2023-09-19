import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';
///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 19/05/23
@SetupModel
class OrderRequest{

  String? customerId;
  String? operationUnitId;
  String? driverId;
  String? status;
  String? type;

  @IsChildren()
  List<Products?>? products;

  @IsChildren()
  List<Products?>? productNotes;


  OrderRequest({this.customerId, this.status, this.products,this.operationUnitId, this.driverId, this.type, this.productNotes});

  static OrderRequest toResponseModel(Map<String, dynamic> map) {
    return OrderRequest(
      customerId: map['customerId'],
      products: Mapper.children<Products>(map['products']),
      productNotes: Mapper.children<Products>(map['productNotes']),
      status: map['status'],
      operationUnitId: map['operationUnitId'],
      driverId: map['driverId'],
      type: map['type'],
    );
  }
}