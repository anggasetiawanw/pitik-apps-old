import 'package:model/engine_library.dart';
import 'package:model/profile.dart';

@SetupModel
class ListDriverResponse {
    int? code;
    List<Profile?> data;

    ListDriverResponse({this.code, required this.data});

    static ListDriverResponse toResponseModel(Map<String, dynamic> map) {
        return ListDriverResponse(
            code: map['code'],
            data: Mapper.children<Profile>(map['data'])
        );
    }
}