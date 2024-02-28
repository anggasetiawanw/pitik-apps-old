import 'package:model/engine_library.dart';

@SetupModel
class DataFarmCycleId {
  String? id;
  String? data;

  DataFarmCycleId({this.id, this.data});

  static DataFarmCycleId toResponseModel(Map<String, dynamic> map) {
    return DataFarmCycleId(id: map['id'], data: map['data']);
  }
}
