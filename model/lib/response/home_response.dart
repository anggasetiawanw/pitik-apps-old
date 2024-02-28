// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import '../home_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class HomeRespone {
  int code;
  Home? data;

  HomeRespone({required this.code, required this.data});

  static HomeRespone toResponseModel(Map<String, dynamic> map) {
    return HomeRespone(code: map['code'], data: Mapper.child<Home>(map['data']));
  }
}
