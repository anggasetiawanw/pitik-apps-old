import 'package:model/data_farmcycle_id.dart';
import 'package:model/engine_library.dart';

@SetupModel
class AssignOperator {
    String? id;

    @IsChildren()
    List<DataFarmCycleId?>? operatorIds;

    AssignOperator({this.id, this.operatorIds});

    static AssignOperator toResponseModel(Map<String, dynamic> map) {
        return AssignOperator(
            id: map['id'],
            operatorIds: Mapper.children<DataFarmCycleId>(map['operatorIds']),
        );
    }
}