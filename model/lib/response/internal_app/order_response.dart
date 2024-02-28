import 'package:model/engine_library.dart';
import 'package:model/internal_app/order_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 19/05/23

@SetupModel
class OrderResponse {
  int code;
  Order? data;

  OrderResponse({required this.code, required this.data});

  static OrderResponse toResponseModel(Map<String, dynamic> map) {
    return OrderResponse(code: map['code'], data: Mapper.child<Order>(map['data']));
  }
}
