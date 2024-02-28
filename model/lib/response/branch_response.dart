import 'package:model/engine_library.dart';

import '../branch.dart';

@SetupModel
class ListBranchResponse {
  int? code;
  List<Branch?> data;

  ListBranchResponse({this.code, required this.data});

  static ListBranchResponse toResponseModel(Map<String, dynamic> map) {
    return ListBranchResponse(code: map['code'], data: Mapper.children<Branch>(map['data']));
  }
}
