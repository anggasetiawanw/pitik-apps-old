import 'package:model/engine_library.dart';
import 'package:model/internal_app/order_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 11/05/23

@SetupModel
class SalesOrderListResponse {
  int? code;
  List<Order?> data;

  SalesOrderListResponse({this.code, required this.data});

  static SalesOrderListResponse toResponseModel(Map<String, dynamic> map) => SalesOrderListResponse(
    code: map['code'],
    data: Mapper.children<Order>(map['data']),
  );
}