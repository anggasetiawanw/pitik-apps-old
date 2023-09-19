import 'package:model/engine_library.dart';
import 'package:model/internal_app/manufacture_output_model.dart';
@SetupModel
class ListManufactureOutputResponse {
    int? code;
    List<ManufactureOutputModel?> data;

    ListManufactureOutputResponse({this.code, required this.data});

    static ListManufactureOutputResponse toResponseModel(Map<String, dynamic> map) {
        return ListManufactureOutputResponse(
            code: map['code'],
            data: Mapper.children<ManufactureOutputModel>(map['data']),
        );
    }
}