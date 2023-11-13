import 'package:engine/model/base_model.dart';


/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class SmartCameraDay {

    int? day;
    String? date;
    int? recordCount;

    SmartCameraDay({this.day, this.date, this.recordCount});

    static SmartCameraDay toResponseModel(Map<String, dynamic> map) {
        return SmartCameraDay(
            day: map['day'],
            date: map['date'],
            recordCount: map['recordCount']
        );
    }
}