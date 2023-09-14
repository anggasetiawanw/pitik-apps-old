// ignore_for_file: slash_for_doc_comments

import 'package:model/temperature_reduction_model.dart';

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class GrowthDay{

    double? temperature;
    double? requestTemperature;
    int? growthDay;
    String? deviceId;

    @IsChildren()
    List<TemperatureReduction?>? temperatureReduction;

    GrowthDay({this.temperature, this.requestTemperature, this.growthDay, this.temperatureReduction, this.deviceId});

    static GrowthDay toResponseModel(Map<String, dynamic> map) {
        if(map['temperature'] is int) {
            map['temperature'] = map['temperature'].toDouble();
        }
        if(map['requestTemperature'] is int) {
            map['requestTemperature'] = map['requestTemperature'].toDouble();
        }

        return GrowthDay(
            temperature: map['temperature'],
            requestTemperature: map['requestTemperature'],
            growthDay: map['growthDay'],
            temperatureReduction: Mapper.children<TemperatureReduction>(map['temperatureReduction']),
            deviceId: map['deviceId'],
        );
    }
}