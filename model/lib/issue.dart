import 'package:model/engine_library.dart';
import 'package:model/internal_app/media_upload_model.dart';

@SetupModel
class Issue {
  String? id;
  String? farmingCycleId;
  String? date;
  String? description;
  String? issueTypeId;
  String? issueTypeName;
  String? status;
  String? remark;
  String? text;
  int? dayNum;

  @IsChildren()
  List<MediaUploadModel?>? photoValue;

  Issue({this.id, this.farmingCycleId, this.date, this.description, this.issueTypeId, this.issueTypeName, this.status, this.remark, this.dayNum, this.photoValue, this.text});

  static Issue toResponseModel(Map<String, dynamic> map) {
    return Issue(
      id: map['id'],
      farmingCycleId: map['farmingCycleId'],
      date: map['date'],
      description: map['description'],
      issueTypeId: map['issueTypeId'],
      issueTypeName: map['issueTypeName'],
      status: map['status'],
      remark: map['remark'],
      dayNum: map['dayNum'],
      photoValue: Mapper.children<MediaUploadModel>(map['photoValue']),
      text: map['text'],
    );
  }
}
