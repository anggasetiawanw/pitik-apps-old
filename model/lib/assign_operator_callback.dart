import 'package:model/data_operator_request.dart';
import 'package:model/engine_library.dart';

@SetupModel
class AssignOperatorCallback {
  String? id;

  @IsChild()
  DataOperatorRequest? data;

  AssignOperatorCallback({this.id, this.data});

  static AssignOperatorCallback toResponseModel(Map<String, dynamic> map) {
    return AssignOperatorCallback(id: map['id'], data: Mapper.child<DataOperatorRequest>(map['data']));
  }
}
