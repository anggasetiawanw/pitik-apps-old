import 'package:model/engine_library.dart';
import 'package:model/profile.dart';

@SetupModel
class ProfileListResponse {
    int? code;
    List<Profile?> data;

    ProfileListResponse({this.code, required this.data});

    static ProfileListResponse toResponseModel(Map<String, dynamic> map) {
        return ProfileListResponse(
            code: map['code'],
            data: Mapper.children<Profile>(map['data'])
        );
    }
}