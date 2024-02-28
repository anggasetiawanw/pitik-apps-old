// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class ErrorDetail {
  String? message;
  String? name;
  String? stack;

  ErrorDetail({required this.message, required this.stack, this.name});

  static ErrorDetail toResponseModel(Map<String, dynamic> map) {
    return ErrorDetail(message: map['message'], stack: map['stack'], name: map['name']);
  }
}
