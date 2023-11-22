import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/dailly_report_response.dart';
import 'package:model/response/record_response.dart';

@Rest
class TaskApi {
    /// A GET request that returns a DailyReportResponse object.
    ///
    /// @param authorization The authorization token.
    /// @param xId The unique identifier for the request.
    /// @param path The path to the resource.
    @GET(value : GET.PATH_PARAMETER, as : DailyReportResponse, error : ErrorResponse)
    void getDailyReport(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path){}

     /// A function that gets the detail daily report.
     ///
     /// @param authorization The authorization token.
     /// @param xId The unique ID of the user.
     /// @param path The path of the request, which is the path of the request after the base URL.
    @GET(value : GET.PATH_PARAMETER, as : ReportResponse, error : ErrorResponse)
    void getDetailDailyReport(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path){}

    /// "This function will send a POST request to the server, and will return an AddReportResponse
    /// object if the request is successful, or an ErrorResponse object if the request fails."
    ///
    /// The @POST annotation is used to specify the URL of the request. The value parameter is the URL
    /// of the request, and the as parameter is the class of the object that will be returned if the
    /// request is successful. The error parameter is the class of the object that will be returned if
    /// the request fails
    ///
    /// @param authorization The authorization token
    /// @param xId The unique identifier for the farm.
    /// @param path The path to the report.
    /// @param averageWeight The average weight of the animals in the group.
    /// @param mortality number of dead animals
    /// @param culling The number of culled animals
    /// @param images JSONArray of JSONObjects, each JSONObject has a "name" and "data" field.
    @POST(value : POST.PATH_PARAMETER, as : ReportResponse, error : ErrorResponse)
    @JSON(isPlaint: true)
    void addReport(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path, @Parameter("data") String data){}
}