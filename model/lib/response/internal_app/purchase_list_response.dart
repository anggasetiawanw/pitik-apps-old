import 'package:model/engine_library.dart';
import 'package:model/internal_app/purchase_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 05/04/23

@SetupModel
class ListPurchaseResponse {
  int? code;
  List<Purchase?> data;

  ListPurchaseResponse({this.code, required this.data});

  static ListPurchaseResponse toResponseModel(Map<String, dynamic> map) => ListPurchaseResponse(
      code: map['code'],
      data: Mapper.children<Purchase>(map['data']),
  );
}