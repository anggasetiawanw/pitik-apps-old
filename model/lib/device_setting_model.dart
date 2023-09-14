import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class DeviceSetting{

    String? id;
    String? deviceId;
    String? name;
    String? fanName;
    double? temperatureTarget;
    double? coolingPadTemperature;
    bool? periodic;
    bool? intermitten;
    bool? isOnline;
    bool? status;
    bool? error;
    String? errors;
    String? coopId;
    String? timeOnFan;
    String? timeOffFan;
    String? onlineDuration;
    String? offlineDuration;
    String? timeOnCoolingPad;
    String? timeOffCoolingPad;
    String? onlineTime;
    String? offlineTime;
    String? timeOnLight;
    String? timeOffLight;
    double? coldAlarm;
    double? hotAlarm;

    DeviceSetting({this.id,this.deviceId, this.fanName, this.temperatureTarget,
        this.periodic, this.intermitten, this.status, this.errors, this.coopId, this.timeOffFan, this.timeOnFan,
        this.onlineDuration, this.offlineDuration, this.coolingPadTemperature,
        this.timeOnCoolingPad, this.timeOffCoolingPad,
        this.error, this.isOnline, this.offlineTime, this.onlineTime, this.name,
        this.timeOnLight, this.timeOffLight, this.coldAlarm, this.hotAlarm});

    static DeviceSetting toResponseModel(Map<String, dynamic> map) {
        if(map['temperatureTarget'] is int) {
            map['temperatureTarget'] = map['temperatureTarget'].toDouble();
        }
        if(map['coolingPadTemperature'] is int) {
            map['coolingPadTemperature'] = map['coolingPadTemperature'].toDouble();
        }

        return DeviceSetting(
            id: map['id'],
            deviceId: map['deviceId'],
            fanName: map['fanName'],
            temperatureTarget: map['temperatureTarget'],
            periodic: map['periodic'],
            intermitten: map['intermitten'],
            status: map['status'],
            errors: map['errors'],
            coopId: map['coopId'],
            timeOnFan: map['timeOnFan'],
            timeOffFan: map['timeOffFan'],
            onlineDuration: map['onlineDuration'],
            offlineDuration: map['offlineDuration'],
            coolingPadTemperature: map['coolingPadTemperature'],
            timeOnCoolingPad: map['timeOnCoolingPad'],
            timeOffCoolingPad: map['timeOffCoolingPad'],
            name: map['name'],
            error: map['error'],
            isOnline: map['isOnline'],
            offlineTime: map['offlineTime'],
            onlineTime: map['onlineTime'],
            timeOnLight: map['timeOnLight'],
            timeOffLight: map['timeOffLight'],
            coldAlarm: map['coldAlarm'],
            hotAlarm: map['hotAlarm'],
        );
    }
}