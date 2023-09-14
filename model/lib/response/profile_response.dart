import '../engine_library.dart';
import '../profile.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class ProfileResponse {

    int code;
    Profile? data;

    ProfileResponse({required this.code, required this.data});

    static ProfileResponse toResponseModel(Map<String, dynamic> map) {
        return ProfileResponse(
            code: map['code'],
            data: Mapper.child<Profile>(map['data'])
        );
    }
}