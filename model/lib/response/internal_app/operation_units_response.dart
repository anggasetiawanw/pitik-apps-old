import 'package:model/engine_library.dart';
import 'package:model/internal_app/operation_unit_model.dart';

@SetupModel
class ListOperationUnitsResponse {
    int? code;
    List<OperationUnitModel?> data;

    ListOperationUnitsResponse({this.code, required this.data});

    static ListOperationUnitsResponse toResponseModel(Map<String, dynamic> map) {
        return ListOperationUnitsResponse(
            code: map['code'],
            data: Mapper.children<OperationUnitModel>(map['data'])
        );
    }
}