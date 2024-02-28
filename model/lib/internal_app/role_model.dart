import 'package:model/engine_library.dart';

@SetupModel
class RoleModel {
  String? id;
  String? name;

  RoleModel({this.id, this.name});

  static RoleModel toResponseModel(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
