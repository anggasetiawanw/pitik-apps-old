import '../building_model.dart';
import '../engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class BuildingResponse {

    @IsChildren()
    List<Building?> data;

    BuildingResponse({this.data = const []});

    static BuildingResponse toResponseModel(Map<String, dynamic> map) {
        return BuildingResponse(
            data: Mapper.children<Building>(map['data'])
        );
    }
}