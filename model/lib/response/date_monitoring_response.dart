import '../coop_performance.dart';
import '../engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class DateMonitoringResponse {
  @IsChildren()
  List<CoopPerformance?> data;

  DateMonitoringResponse({this.data = const []});

  static DateMonitoringResponse toResponseModel(Map<String, dynamic> map) {
    return DateMonitoringResponse(data: Mapper.children<CoopPerformance>(map['data']));
  }
}
