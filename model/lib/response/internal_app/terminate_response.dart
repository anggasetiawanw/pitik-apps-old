import 'package:model/engine_library.dart';
import 'package:model/internal_app/terminate_model.dart';

@SetupModel
class TerminateResponse {
  int? code;
  TerminateModel? data;

  TerminateResponse({this.code, required this.data});

  static TerminateResponse toResponseModel(Map<String, dynamic> map) {
    return TerminateResponse(code: map['code'], data: Mapper.child<TerminateModel>(map['data']));
  }
}
