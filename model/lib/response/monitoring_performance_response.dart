import 'package:model/monitoring.dart';

import '../engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class MonitoringPerformanceResponse {
  @IsChild()
  Monitoring? data;

  MonitoringPerformanceResponse({this.data});

  static MonitoringPerformanceResponse toResponseModel(Map<String, dynamic> map) {
    return MonitoringPerformanceResponse(data: Mapper.child<Monitoring>(map['data']));
  }
}
