import 'package:model/engine_library.dart';
import 'package:model/issue.dart';

@SetupModel
class IssueListResponse {
    int? code;
    List<Issue?> data;

    IssueListResponse({this.code, required this.data});

    static IssueListResponse toResponseModel(Map<String, dynamic> map) {
        return IssueListResponse(
            code: map['code'],
            data: Mapper.children<Issue>(map['data'])
        );
    }
}