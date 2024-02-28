// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';
import '../graph_line.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class HistoricalDataResponse {
  int code;

  @IsChildren()
  List<GraphLine?>? data;

  HistoricalDataResponse({required this.code, required this.data});

  static HistoricalDataResponse toResponseModel(Map<String, dynamic> map) {
    return HistoricalDataResponse(
      code: map['code'],
      data: Mapper.children<GraphLine>(map['data']),
    );
  }
}
