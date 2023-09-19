import 'package:model/engine_library.dart';
import 'package:model/internal_app/manufacture_model.dart';

@SetupModel
class ManufactureResponse {
    int code;
    ManufactureModel? data;

    ManufactureResponse({required this.code, required this.data});

    static ManufactureResponse toResponseModel(Map<String, dynamic> map) {
        return ManufactureResponse(
            code: map['code'],
            data: Mapper.child<ManufactureModel>(map['data'])
        );
    }
}