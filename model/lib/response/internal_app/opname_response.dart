import 'package:model/engine_library.dart';
import 'package:model/internal_app/opname_model.dart';

@SetupModel
class OpnameResponse {
  int? code;
  OpnameModel? data;

  OpnameResponse({this.code, required this.data});

  static OpnameResponse toResponseModel(Map<String, dynamic> map) {
    return OpnameResponse(code: map['code'], data: Mapper.child<OpnameModel>(map['data']));
  }
}
