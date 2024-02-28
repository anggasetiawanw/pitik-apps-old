import 'package:model/engine_library.dart';
import 'package:model/request_chickin.dart';

@SetupModel
class RequestChickinResponse {
  int? code;
  RequestChickin? data;

  RequestChickinResponse({this.code, required this.data});

  static RequestChickinResponse toResponseModel(Map<String, dynamic> map) {
    return RequestChickinResponse(code: map['code'], data: Mapper.child<RequestChickin>(map['data']));
  }
}
