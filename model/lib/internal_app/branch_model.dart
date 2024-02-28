import 'package:model/engine_library.dart';

@SetupModel
class BranchModel {
  String? id;
  String? name;

  BranchModel({this.id, this.name});

  static BranchModel toResponseModel(Map<String, dynamic> map) {
    return BranchModel(id: map['id'], name: map['name']);
  }
}
