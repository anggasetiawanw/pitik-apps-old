import 'package:model/engine_library.dart';

@SetupModel
class CheckInModel {
  double? latitude;
  double? longitude;
  double? distance;

  CheckInModel({this.latitude, this.longitude, this.distance});

  static CheckInModel toResponseModel(Map<String, dynamic> map) => CheckInModel(
        latitude: map['latitude'],
        longitude: map['longitude'],
        distance: map['distance'],
      );
}
