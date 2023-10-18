import '../engine_library.dart';
import '../sensor_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class SensorPositionResponse {

    @IsChildren()
    List<Sensor?> data;

    SensorPositionResponse({this.data = const []});

    static SensorPositionResponse toResponseModel(Map<String, dynamic> map) {
        return SensorPositionResponse(
            data: Mapper.children<Sensor>(map['data'])
        );
    }
}