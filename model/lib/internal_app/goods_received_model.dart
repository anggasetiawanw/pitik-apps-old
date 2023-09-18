import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';
import 'package:model/internal_app/purchase_model.dart';
/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 07/06/23
 */

@SetupModel
class GoodsReceived {

    String? id;
    String? code;
    String? status;

    Purchase? purchaseOrder;

    @IsChildren()
    List<Products?>? products;

    GoodsReceived({this.id, this.code, this.status, this.purchaseOrder, this.products});

    static GoodsReceived toResponseModel(Map<String, dynamic> map) {
        return GoodsReceived(
            id: map['id'],
            code: map['code'],
            status: map['status'],
            purchaseOrder: Mapper.child<Purchase>(map['purchaseOrder']),
            products: Mapper.children<Products>(map['products'])
        );
    }
}