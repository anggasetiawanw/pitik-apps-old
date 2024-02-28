// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import '../engine_library.dart';
export 'package:engine/model/base_model.dart';
import 'error_detail.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class ErrorResponse {
  int code;
  ErrorDetail? error;

  ErrorResponse({required this.code, required this.error});

  static ErrorResponse toResponseModel(Map<String, dynamic> map) {
    return ErrorResponse(code: map['code'], error: Mapper.child<ErrorDetail>(map['error']));
  }
}
