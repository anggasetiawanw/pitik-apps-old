import 'package:model/engine_library.dart';
@SetupModel
class Location {
    int? id;
    int? provinceId;
    int? cityId;
    String? districtName;
    String? cityName;
    String? name;
    String? provinceName;

    Location({this.id, this.name, this.cityId, this.cityName, this.districtName, this.provinceId, this.provinceName});

    static Location toResponseModel(Map<String, dynamic> map) => Location(
        id: map["id"],
        name: map["name"],
        provinceName: map["provinceName"],
        districtName: map["districtName"],
        cityId: map["cityId"],
        cityName: map["cityName"],
        provinceId: map["provinceId"],
    );
}