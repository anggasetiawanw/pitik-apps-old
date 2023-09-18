import 'package:model/engine_library.dart';
import 'package:model/internal_app/manufacture_model.dart';
@SetupModel
class ListManufactureResponse {
    int? code;
    List<ManufactureModel?> data;

    ListManufactureResponse({this.code, required this.data});

    static ListManufactureResponse toResponseModel(Map<String, dynamic> map) {
        return ListManufactureResponse(
            code: map['code'],
            data: Mapper.children<ManufactureModel>(map['data']),
        );
    }
}