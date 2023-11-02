

import 'package:engine/request/api_mapping_list.dart';
import 'package:pitik_ppl_app/api_mapping/apis/coop_api.dart';
import 'package:pitik_ppl_app/api_mapping/apis/farm_monitoring_api.dart';
import 'package:pitik_ppl_app/api_mapping/apis/product_report_api.dart';
import 'package:pitik_ppl_app/api_mapping/apis/smart_controller_api.dart';
import 'package:pitik_ppl_app/api_mapping/apis/smart_monitoring_api.dart';

import '../../flavors.dart';
import 'apis/api.dart';
import 'apis/user_api.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

class ApiMapping extends ApiMappingList {
    static const api = "api";
    static const userApi = "userApi";
    static const smartMonitoringApi = "smartMonitoringApi";
    static const smartControllerApi = "smartControllerApi";
    static const productReportApi = "productReportApi";
    static const farmMonitoringApi = "farmMonitoringApi";
    static const coopApi = "coopApi";

    Map<String, Type> apiMapping = {
        "api": API,
        "userApi": UserApi,
        "smartMonitoringApi": SmartMonitoringApi,
        "smartControllerApi": SmartControllerApi,
        "productReportApi": ProductReportApi,
        "farmMonitoringApi": FarmMonitoringApi,
        "coopApi": CoopApi,
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