import 'package:model/data_farmcycle_id.dart';
import 'package:model/engine_library.dart';

@SetupModel
class DataOperatorRequest {
  String? id;

  @IsChildren()
  List<DataFarmCycleId?>? dataFarmCycleIds;

  DataOperatorRequest({this.id, this.dataFarmCycleIds});

  static DataOperatorRequest toResponseModel(Map<String, dynamic> map) {
    return DataOperatorRequest(id: map['id'], dataFarmCycleIds: Mapper.children<DataFarmCycleId>(map['dataFarmCycleIds']));
  }
}
