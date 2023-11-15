import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/dailly_report_response.dart';

@Rest
class TaskApi {
    /**
     * A GET request that returns a DailyReportResponse object.
     *
     * @param authorization The authorization token.
     * @param xId The unique identifier for the request.
     * @param path The path to the resource.
     */
    @GET(value : GET.PATH_PARAMETER, as : DailyReportResponse, error : ErrorResponse)
    void getDailyReport(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path){}
}