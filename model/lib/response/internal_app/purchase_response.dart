import 'package:model/engine_library.dart';
import 'package:model/internal_app/purchase_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/04/23

@SetupModel
class PurchaseResponse {
  int code;
  Purchase? data;

  PurchaseResponse({required this.code, required this.data});

  static PurchaseResponse toResponseModel(Map<String, dynamic> map) {
    return PurchaseResponse(code: map['code'], data: Mapper.child<Purchase>(map['data']));
  }
}
