import 'package:model/engine_library.dart';
import 'package:model/profile.dart';

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

@SetupModel
class ProfileResponse {
  int code;
  Profile? data;

  ProfileResponse({required this.code, required this.data});

  static ProfileResponse toResponseModel(Map<String, dynamic> map) {
    return ProfileResponse(code: map['code'], data: Mapper.child<Profile>(map['data']));
  }
}
