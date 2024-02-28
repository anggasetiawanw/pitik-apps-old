import 'package:engine/request/api_mapping_list.dart';

import '../../flavors.dart';
import 'apis/api.dart';
import 'apis/coop_api.dart';
import 'apis/farm_monitoring_api.dart';
import 'apis/harvest_api.dart';
import 'apis/product_report_api.dart';
import 'apis/smart_camera_api.dart';
import 'apis/smart_controller_api.dart';
import 'apis/smart_monitoring_api.dart';
import 'apis/smart_scale_api.dart';
import 'apis/task_api.dart';
import 'apis/user_api.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 11/09/2023

class ApiMapping extends ApiMappingList {
  static const api = 'api';
  static const userApi = 'userApi';
  static const smartMonitoringApi = 'smartMonitoringApi';
  static const smartControllerApi = 'smartControllerApi';
  static const smartScaleApi = 'smartScaleApi';
  static const smartCameraApi = 'smartCameraApi';
  static const productReportApi = 'productReportApi';
  static const farmMonitoringApi = 'farmMonitoringApi';
  static const coopApi = 'coopApi';
  static const taskApi = 'taskApi';
  static const harvestApi = 'harvestApi';

  Map<String, Type> apiMapping = {
    'api': API,
    'userApi': UserApi,
    'smartMonitoringApi': SmartMonitoringApi,
    'smartControllerApi': SmartControllerApi,
    'smartScaleApi': SmartScaleApi,
    'smartCameraApi': SmartCameraApi,
    'productReportApi': ProductReportApi,
    'farmMonitoringApi': FarmMonitoringApi,
    'coopApi': CoopApi,
    'taskApi': TaskApi,
    'harvestApi': HarvestApi
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
