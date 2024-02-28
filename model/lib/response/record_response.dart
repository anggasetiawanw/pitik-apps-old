import 'package:model/engine_library.dart';
import 'package:model/report.dart';

@SetupModel
class ReportResponse {
  int? code;
  Report? data;

  ReportResponse({this.code, required this.data});

  static ReportResponse toResponseModel(Map<String, dynamic> map) {
    return ReportResponse(code: map['code'], data: Mapper.child<Report>(map['data']));
  }
}
