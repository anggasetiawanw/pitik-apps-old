import '../auth_model.dart';
import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class AuthResponse {

    int code;
    Auth? data;

    AuthResponse({required this.code, required this.data});

    static AuthResponse toResponseModel(Map<String, dynamic> map) {
        return AuthResponse(
            code: map['code'],
            data: Mapper.child<Auth>(map['data'])
        );
    }
}