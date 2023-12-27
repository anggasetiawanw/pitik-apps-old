import 'package:model/engine_library.dart';
import 'package:model/issue.dart';

@SetupModel
class IssueResponse {
    int? code;
    Issue? data;

    IssueResponse({this.code, required this.data});

    static IssueResponse toResponseModel(Map<String, dynamic> map) {
        return IssueResponse(
            code: map['code'],
            data: Mapper.child<Issue>(map['data'])
        );
    }
}