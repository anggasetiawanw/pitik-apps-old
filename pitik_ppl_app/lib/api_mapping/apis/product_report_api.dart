
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
import 'package:model/response/sapronak_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class ProductReportApi {

    @GET(value: GET.PATH_PARAMETER, as: SapronakResponse, error: ErrorResponse)
    void getSapronak(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Path() String path) {}

}