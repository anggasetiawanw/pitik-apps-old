import '../coop_active_standard.dart';
import '../engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class MonitorResponse {
  @IsChildren()
  List<CoopActiveStandard?> data;

  MonitorResponse({this.data = const []});

  static MonitorResponse toResponseModel(Map<String, dynamic> map) {
    return MonitorResponse(data: Mapper.children<CoopActiveStandard>(map['data']));
  }
}
