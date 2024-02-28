import 'package:model/engine_library.dart';

@SetupModel
class ApprovalRequestDocIn {
  String? id;
  bool? isAllowed;

  ApprovalRequestDocIn({this.id, this.isAllowed});

  static ApprovalRequestDocIn toResponseModel(Map<String, dynamic> map) {
    return ApprovalRequestDocIn(id: map['id'], isAllowed: map['isAllowed']);
  }
}
