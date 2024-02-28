import 'package:model/engine_library.dart';
import 'package:model/internal_app/opname_model.dart';

@SetupModel
class ListOpnameResponse {
  int? code;
  List<OpnameModel?> data;

  ListOpnameResponse({this.code, required this.data});

  static ListOpnameResponse toResponseModel(Map<String, dynamic> map) {
    return ListOpnameResponse(code: map['code'], data: Mapper.children<OpnameModel>(map['data']));
  }
}
