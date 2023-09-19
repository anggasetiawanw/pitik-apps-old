import 'package:model/engine_library.dart';
import 'package:model/internal_app/customer_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 09/05/23

@SetupModel
class OperationUnitListResponse {
  int? code;
  List<Customer?> data;

  OperationUnitListResponse({this.code, required this.data});

  static OperationUnitListResponse toResponseModel(Map<String, dynamic> map) => OperationUnitListResponse(
    code: map['code'],
    data: Mapper.children<Customer>(map['data']),
  );
}