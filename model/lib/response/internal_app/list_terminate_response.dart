import 'package:model/engine_library.dart';
import 'package:model/internal_app/terminate_model.dart';

@SetupModel
class ListTerminateResponse {
  int? code;
  List<TerminateModel?> data;

  ListTerminateResponse({this.code, required this.data});

  static ListTerminateResponse toResponseModel(Map<String, dynamic> map) {
    return ListTerminateResponse(code: map['code'], data: Mapper.children<TerminateModel>(map['data']));
  }
}
