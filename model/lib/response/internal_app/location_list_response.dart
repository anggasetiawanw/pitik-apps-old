import 'package:model/engine_library.dart';
import 'package:model/internal_app/place_model.dart';

@SetupModel
class LocationListResponse {
    int? code;
    List<Location?> data;

    LocationListResponse({this.code, required this.data});

    static LocationListResponse toResponseModel(Map<String, dynamic> map) => LocationListResponse(
        code: map['code'],
        data: Mapper.children<Location>(map['data']),
    );
}
