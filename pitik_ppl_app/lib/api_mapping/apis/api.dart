

import 'dart:io';

import 'package:engine/request/annotation/mediatype/json.dart';
import 'package:engine/request/annotation/mediatype/multipart.dart';
import 'package:engine/request/annotation/property/header.dart';
import 'package:engine/request/annotation/property/parameter.dart';
import 'package:engine/request/annotation/property/path.dart';
import 'package:engine/request/annotation/property/query.dart';
import 'package:engine/request/annotation/request/get.dart';
import 'package:engine/request/annotation/request/patch.dart';
import 'package:engine/request/annotation/request/post.dart';
import 'package:engine/request/base_api.dart';
import 'package:model/error/error.dart';
// ignore: unused_import
import 'package:model/password_model.dart';
import 'package:model/response/approval_doc_response.dart';
// ignore: unused_import
import 'package:model/response/coop_list_response.dart';
import 'package:model/response/internal_app/media_upload_response.dart';
import 'package:model/response/profile_response.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

@Rest
class API {

    /// The function "changePassword" is used to send a PATCH request to update the
    /// password with the provided headers and parameters.
    ///
    /// Args:
    ///   authorization (String): The "authorization" parameter is a header
    /// parameter that is used to pass the authorization token for the request. It
    /// is typically used for authentication purposes and is used to verify the
    /// identity of the user making the request.
    ///   xid (String): The `xid` parameter is a header parameter that represents
    /// the X-ID value. It is typically used for identification purposes in the API
    /// request.
    ///   xAppId (String): The `xAppId` parameter is a header parameter that
    /// represents the X-APP-ID value. It is used to identify the application making
    /// the request.
    ///   path (String): The `path` parameter is a string that represents the path
    /// of the resource you want to update. It is typically used in PATCH requests
    /// to specify the specific resource that needs to be modified.
    ///   params (String): The "params" parameter is a string that contains the new
    /// password to be changed.
    @JSON(isPlaint: true)
    @PATCH(value: PATCH.PATH_PARAMETER, as: ProfileResponse, error: ErrorResponse)
    void changePassword(@Header("Authorization") String authorization, @Header("X-ID") String xid, @Header("X-APP-ID") String xAppId, @Path() String path, @Parameter("params") String params) {}


    @POST(value :"v2/upload", as: MediaUploadResponse, error: ErrorResponse)
    @Multipart()
    void uploadImage(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("folder") String folder, @Parameter("file") File file) {}

    /// It gets the approval document.
    ///
    /// @param authorization The authorization token.
    /// @param xId The unique ID of the user.
    /// @param name The name of the role to be validated.
    @GET(value : "v2/roles/acl/validate", as : AprovalDocInResponse, error : ErrorResponse)
    void getApproval(@Header("Authorization") String authorization, @Header("X-ID") String xId, @Query("name") String name){}
}
