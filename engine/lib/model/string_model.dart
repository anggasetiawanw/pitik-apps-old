// ignore_for_file: slash_for_doc_comments

import 'base_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class StringModel {
  dynamic data;
  StringModel({this.data});

  static StringModel toResponseModel(Map<String, dynamic> map) {
    return StringModel(data: map['data']);
  }
}
