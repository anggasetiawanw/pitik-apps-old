/**
 *@author DICKY
 *@email <dicky.maulana@pitik.id>
 *@create date 31/07/23
 */

class ResponseListener {
    Function(int code, String message, dynamic body, int id, dynamic packet) onResponseDone;
    Function(int code, String message, dynamic body, int id, dynamic packet) onResponseFail;
    Function(String exception, StackTrace stacktrace, int id, dynamic packet) onResponseError;
    Function() onTokenInvalid;

    ResponseListener({required this.onResponseDone, required this.onResponseFail, required this.onResponseError, required this.onTokenInvalid});
}
