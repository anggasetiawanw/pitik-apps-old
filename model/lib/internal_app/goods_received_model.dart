import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 07/06/23

@SetupModel
class GoodsReceived {
  String? id;
  String? code;
  String? status;
  String? remarks;
  double? totalWeight;

  Purchase? purchaseOrder;

  @IsChildren()
  List<Products?>? products;

  GoodsReceived({
    this.id,
    this.code,
    this.status,
    this.purchaseOrder,
    this.products,
    this.remarks,
    this.totalWeight,
  });

  static GoodsReceived toResponseModel(Map<String, dynamic> map) {
    if (map['totalWeight'] is int) {
      map['totalWeight'] = map['totalWeight'].toDouble();
    }
    return GoodsReceived(
      id: map['id'],
      code: map['code'],
      status: map['status'],
      purchaseOrder: Mapper.child<Purchase>(map['purchaseOrder']),
      products: Mapper.children<Products>(map['products']),
      remarks: map['remarks'],
      totalWeight: map['totalWeight'],
    );
  }
}
