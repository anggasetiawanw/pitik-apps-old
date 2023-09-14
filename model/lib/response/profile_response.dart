// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import '../profile.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
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