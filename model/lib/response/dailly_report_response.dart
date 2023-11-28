import 'package:model/engine_library.dart';
import 'package:model/report.dart';

@SetupModel
class DailyReportResponse {
    int? code;
    List<Report?> data;

    DailyReportResponse({this.code, required this.data});

    static DailyReportResponse toResponseModel(Map<String, dynamic> map) {
        return DailyReportResponse(
            code: map['code'],
            data: Mapper.children<Report>(map['data'])
        );
    }
}