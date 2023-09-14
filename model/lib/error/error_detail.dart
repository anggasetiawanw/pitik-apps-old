import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

@SetupModel
class ErrorDetail {
    String? message;
    String? stack;

    ErrorDetail({required this.message, required this.stack});

    static ErrorDetail toResponseModel(Map<String, dynamic> map) {
        return ErrorDetail(
            message: map['message'],
            stack: map['stack']);
    }
}