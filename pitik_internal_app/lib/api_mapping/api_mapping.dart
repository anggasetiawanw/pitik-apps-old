

import 'package:engine/request/api_mapping_list.dart';
import 'package:pitik_internal_app/api_mapping/apis/api.dart';
import 'package:pitik_internal_app/api_mapping/apis/delivery_api.dart';
import 'package:pitik_internal_app/api_mapping/apis/user_api.dart';
import 'package:pitik_internal_app/flavors.dart';


class ApiMapping extends ApiMappingList {

    static const String api = "api";
    static const String userApi = "userApi";
    static const String deliveryApi = "deliveryApi";

    Map<String, Type> apiMapping = {
        "api": API,
        "userApi": UserApi,
        "deliveryApi":DeliveryApi
    };

    @override
    Type getApiMapping(String apiKey) {
        return apiMapping[apiKey]!;
    }

    @override
    String getBaseUrl() {
        return F.uri;
    }
}