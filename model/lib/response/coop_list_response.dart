// ignore_for_file: slash_for_doc_comments

import '../coop_model.dart';
import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class CoopListResponse {
  int code;

  @IsChildren()
  List<Coop?> data;

  CoopListResponse({required this.code, this.data = const []});

  static CoopListResponse toResponseModel(Map<String, dynamic> map) {
    return CoopListResponse(
      code: map['code'],
      data: Mapper.children<Coop>(map['data']),
    );
  }
}
