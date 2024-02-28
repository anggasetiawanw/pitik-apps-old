import '../coop_performance.dart';
import '../engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class MonitoringDetailResponse {
  @IsChild()
  CoopPerformance? data;

  MonitoringDetailResponse({this.data});

  static MonitoringDetailResponse toResponseModel(Map<String, dynamic> map) {
    return MonitoringDetailResponse(data: Mapper.child<CoopPerformance>(map['data']));
  }
}
