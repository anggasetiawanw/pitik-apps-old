
import '../engine_library.dart';
import 'error_detail.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class ErrorResponse {
    int code;
    ErrorDetail? error;

    ErrorResponse({required this.code, required this.error});

    static ErrorResponse toResponseModel(Map<String, dynamic> map) {
        return ErrorResponse(
            code: map['code'],
            error: Mapper.child<ErrorDetail>(map['error'])
        );
    }
}