import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class DailyReportRevision {

    String? reason;
    List<String?> changes;

    DailyReportRevision({this.reason, this.changes = const []});

    static DailyReportRevision toResponseModel(Map<String, dynamic> map) {
        return DailyReportRevision(
            reason: map['reason'],
            changes: map['changes']
        );
    }
}