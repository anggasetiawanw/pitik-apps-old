import 'package:model/approval_request.dart';
import 'package:model/engine_library.dart';

@SetupModel
class AprovalDocInResponse {
    int? code;
    ApprovalRequestDocIn? data;

    AprovalDocInResponse({this.code, required this.data});

    static AprovalDocInResponse toResponseModel(Map<String, dynamic> map) {
        return AprovalDocInResponse(
            code: map['code'],
            data: Mapper.child<ApprovalRequestDocIn>(map['data'])
        );
    }
}