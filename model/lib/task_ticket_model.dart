import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class TaskTicket {

    String? id;
    String? timestamp;
    String? title;
    String? instruction;
    String? source;
    String? date;
    String? verificationStatus;
    double? earnedPoints;
    double? potentialPoints;
    bool? status;
    bool? isDailyReport;

    TaskTicket({this.id, this.timestamp, this.title, this.instruction, this.source, this.date, this.verificationStatus, this.earnedPoints, this.potentialPoints, this.status, this.isDailyReport});

    static TaskTicket toResponseModel(Map<String, dynamic> map) {
        return TaskTicket(
            id: map['id'],
            timestamp: map['timestamp'],
            title: map['title'],
            instruction: map['instruction'],
            source: map['source'],
            date: map['date'],
            verificationStatus: map['verificationStatus'],
            earnedPoints: map['earnedPoints'] != null ? map['earnedPoints'].toDouble() : map['earnedPoints'],
            potentialPoints: map['potentialPoints'] != null ? map['potentialPoints'].toDouble() : map['potentialPoints'],
            status: map['status'],
            isDailyReport: map['isDailyReport']
        );
    }
}