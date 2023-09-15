// ignore_for_file: slash_for_doc_comments

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ResponseListener {
    Function(int code, String? message, dynamic body, int id, dynamic packet) onResponseDone;
    Function(int code, String? message, dynamic body, int id, dynamic packet) onResponseFail;
    Function(String exception, StackTrace stacktrace, int id, dynamic packet) onResponseError;
    Function() onTokenInvalid;

    ResponseListener({required this.onResponseDone, required this.onResponseFail, required this.onResponseError, required this.onTokenInvalid});
}
