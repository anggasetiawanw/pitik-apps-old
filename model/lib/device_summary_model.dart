// ignore_for_file: slash_for_doc_comments

import 'package:model/sensor_data_model.dart';

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class DeviceSummary{

    @IsChild()
    SensorData? temperature;

    @IsChild()
    SensorData? relativeHumidity;

    @IsChild()
    SensorData? ammonia;

    @IsChild()
    SensorData? heatStressIndex;

    @IsChild()
    SensorData? wind;

    @IsChild()
    SensorData? lights;

    String? id;
    String? coopCodeId;
    String? deviceId;

    DeviceSummary({this.temperature, this.relativeHumidity, this.ammonia, this.heatStressIndex, this.wind, this.lights, this.id, this.coopCodeId, this.deviceId});

    static DeviceSummary toResponseModel(Map<String, dynamic> map) {
        return DeviceSummary(
            temperature: Mapper.child<SensorData>(map['temperature']),
            relativeHumidity: Mapper.child<SensorData>(map['relativeHumidity']),
            ammonia: Mapper.child<SensorData>(map['ammonia']),
            heatStressIndex: Mapper.child<SensorData>(map['heatStressIndex']),
            wind: Mapper.child<SensorData>(map['wind']),
            lights: Mapper.child<SensorData>(map['lights']),
            id: map['id'],
            coopCodeId: map['coopCodeId'],
            deviceId: map['deviceId'],
        );
    }

    bool isNullObject(){
        if(temperature == null && relativeHumidity == null && ammonia == null
            && heatStressIndex == null && wind == null && lights == null){
            return true;
        }
        return false;
    }
}