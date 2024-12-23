import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/annotation/request/put.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/list_smart_scale_response.dart';
import 'package:model/response/smart_scale_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 08/09/2023

@Rest
class SmartScaleApi {
  @GET(value: GET.PATH_PARAMETER, as: ListSmartScaleResponse, error: ErrorResponse)
  void getListHistoryScale(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path, @Query('\$page') int page, @Query('\$limit') int limit, @Query('date') String date) {}

  /// The function "getSmartScaleDetail" is a GET request that retrieves
  /// SmartScale details using the provided authorization, X-ID, and path
  /// parameters.
  ///
  /// Args:
  ///   authorization (String): The "authorization" parameter is a header
  /// parameter that is used to pass the authorization token or credentials for
  /// authentication purposes. It is typically used to verify the identity and
  /// permissions of the user making the request.
  ///   xId (String): The xId parameter is a header parameter that represents a
  /// unique identifier for the request. It is typically used for tracking or
  /// logging purposes.
  ///   path (String): The `path` parameter is used to specify the path for the
  /// API endpoint. It is typically used to provide additional information or
  /// context for the API request.
  @GET(value: GET.PATH_PARAMETER, as: SmartScaleResponse, error: ErrorResponse)
  void getSmartScaleDetail(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path) {}

  /// The function saves data from a smart scale to a B2B weighing endpoint.
  ///
  /// Args:
  ///   authorization (String): The "authorization" parameter is a header
  /// parameter that is used to pass the authorization token or credentials for
  /// authentication purposes. It is typically used to verify the identity of the
  /// user making the request.
  ///   xId (String): The `xId` parameter is a header parameter that represents
  /// the X-ID value. It is typically used for identification or authentication
  /// purposes in the API request.
  ///   params (String): The "params" parameter is a string that contains the data
  /// to be saved for the smart scale.
  @POST(value: POST.PATH_PARAMETER, error: ErrorResponse)
  @JSON(isPlaint: true)
  void saveSmartScale(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path, @Parameter('params') String params) {}

  /// The function `updateSmartScale` is used to send a PATCH request to update a
  /// smart scale with the given parameters.
  ///
  /// Args:
  ///   authorization (String): The "authorization" parameter is a header
  /// parameter that is used to pass the authorization token or credentials for
  /// authentication purposes. It is typically used to verify the identity and
  /// permissions of the user making the request.
  ///   xId (String): The `xId` parameter is a header parameter that represents
  /// the X-ID header in the HTTP request. It is used to provide additional
  /// identification or context information for the request.
  ///   params (String): The "params" parameter is a string that represents
  /// additional parameters or data that can be passed to the "updateSmartScale"
  /// method. It is not specified what kind of data or format these parameters
  /// should be in, so it would depend on the specific implementation and
  /// requirements of the method.
  ///   path (String): The `path` parameter is used to specify the path of the
  /// resource that needs to be updated. It is typically used in RESTful APIs to
  /// identify a specific resource or endpoint.
  @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  @JSON(isPlaint: true)
  void updateSmartScale(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path, @Parameter('params') String params) {}

  @POST(value: 'v2/harvest-realizations/with-deal', error: ErrorResponse)
  @JSON(isPlaint: true)
  void saveSmartScaleHarvest(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Parameter('data') String data) {}

  @PUT(value: PUT.PATH_PARAMETER, error: ErrorResponse)
  @JSON(isPlaint: true)
  void updateSmartScaleHarvest(@Header('Authorization') String authorization, @Header('X-ID') String xId, @Path() String path, @Parameter('data') String data) {}
}
