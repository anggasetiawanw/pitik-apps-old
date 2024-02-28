// ignore_for_file: slash_for_doc_comments

import 'base_api.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@Rest
class ApiMappingList {
  Type getApiMapping(String apiKey) {
    throw Exception('ApiMappingList not set, please set call (setApiMapping(Type persistance) before...!');
  }

  String getBaseUrl() {
    throw Exception('ApiMappingList not set, please extends ApiMappingList in your Api Mapping class..!');
  }
}
