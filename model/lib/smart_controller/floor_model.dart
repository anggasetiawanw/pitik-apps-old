import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Floor {

    String? id;
    String? coopId;
    String? deviceId;
    String? floorName;
    int? day;
    int? periode;
    String? chickinDate;
    double? temperature;
    double? humidity;

    Floor({this.id, this.coopId, this.deviceId, this.floorName, this.day, this.periode, this.chickinDate, this.temperature, this.humidity});

    static Floor toResponseModel(Map<String, dynamic> map) {
        return Floor(
            id: map['id'],
            coopId: map['coopId'],
            deviceId: map['deviceId'],
            floorName: map['floorName'],
            day: map['day'],
            periode: map['periode'],
            chickinDate: map['chickinDate'],
            temperature: map['temperature'],
            humidity: map['humidity']
        );
    }
}