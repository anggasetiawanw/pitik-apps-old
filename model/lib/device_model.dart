import 'package:model/sensor_model.dart';

import '../engine_library.dart';
import 'device_summary_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class Device{

    String? id;
    String? deviceName;
    String? deviceType;
    String? deviceId;
    String? coopId;
    String? roomId;
    String? mac;
    String? status;
    int? sensorCount;

    @IsChildren()
    List<Sensor?> sensors;

    @IsChild()
    DeviceSummary? deviceSummary;

    Device({this.id, this.deviceName,this.deviceType, this.sensors = const [], this.coopId, this.roomId,
        this.status, this.mac, this.deviceId, this.deviceSummary, this.sensorCount});

    static Device toResponseModel(Map<String, dynamic> map) {
        if(map['status'] is bool) {
            map['status'] = map['status'].toString();
        }
        return Device(
            id: map['id'],
            deviceName: map['deviceName'],
            deviceType: map['deviceType'],
            coopId: map['coopId'],
            roomId: map['roomId'],
            status: map['status'],
            mac: map['mac'],
            deviceId: map['deviceId'],
            sensorCount: map['sensorCount'],
            sensors: Mapper.children<Sensor>(map['sensors']),
            deviceSummary: Mapper.child<DeviceSummary>(map['deviceSummary']),
        );
    }
}