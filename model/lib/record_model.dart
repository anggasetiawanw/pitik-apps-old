import '../engine_library.dart';
import 'sensor_model.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class RecordCamera{

    int? seqNo;
    int? recordCount;
    String? jobId;
    double? temperature;
    double? humidity;
    String? createdAt;
    String? link;
    String? isCrowded;
    String? remarks;
    String? date;

    @IsChild()
    Sensor? sensor;

    RecordCamera({this.seqNo, this.jobId,this.temperature, this.humidity, this.createdAt, this.link,
        this.isCrowded, this.remarks, this.sensor, this.recordCount, this.date});

    static RecordCamera toResponseModel(Map<String, dynamic> map) {

        if(map['temperature'] is int) {
            map['temperature'] = map['temperature'].toDouble();
        }
        if(map['humidity'] is int) {
            map['humidity'] = map['humidity'].toDouble();
        }
        return RecordCamera(
            seqNo: map['seqNo'],
            jobId: map['jobId'],
            temperature: map['temperature'],
            humidity: map['humidity'],
            createdAt: map['createdAt'],
            link: map['link'],
            isCrowded: map['isCrowded'],
            remarks: map['remarks'],
            recordCount: map['recordCount'],
            date: map['date'],
            sensor: Mapper.child<Sensor>(map['sensor']),
        );
    }
}