import 'package:model/engine_library.dart';

@SetupModel
class Report {
    String? taskTicketId;
    String? title;
    String? deskripsi;
    String? status;
    String? date;

    Report({this.taskTicketId, this.title, this.deskripsi, this.status, this.date});

    static Report toResponseModel(Map<String, dynamic> map) {
        return Report(
            taskTicketId: map['taskTicketId'],
            title: map['title'],
            deskripsi: map['deskripsi'],
            status: map['status'],
            date: map['date'],
            
        );
    }
}