import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/task_ticket_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class TaskTicketResponse {

    int? count;

    @IsChildren()
    List<TaskTicket?> data;

    TaskTicketResponse({this.count, this.data = const []});

    static TaskTicketResponse toResponseModel(Map<String, dynamic> map) {
        return TaskTicketResponse(
            count: map['count'],
            data: Mapper.children<TaskTicket>(map['data'])
        );
    }
}