import 'package:engine/request/api_mapping_list.dart';

import '../../flavors.dart';
import 'apis/api.dart';
import 'apis/smart_scale_api.dart';
import 'apis/user_api.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

class ApiMapping extends ApiMappingList {
  Map<String, Type> apiMapping = {"api": API, "userApi": UserApi, "smartScaleApi": SmartScaleApi};

  @override
  Type getApiMapping(String apiKey) {
    return apiMapping[apiKey]!;
  }

  @override
  String getBaseUrl() {
    return F.uri;
  }
}
