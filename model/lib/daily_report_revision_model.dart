import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class DailyReportRevision {
  String? reason;

  @IsChildren()
  List<String?> changes;

  DailyReportRevision({this.reason, this.changes = const []});

  static DailyReportRevision toResponseModel(Map<String, dynamic> map) {
    return DailyReportRevision(reason: map['reason'], changes: map['changes']);
  }
}
