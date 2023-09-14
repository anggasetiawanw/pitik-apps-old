// ignore_for_file: slash_for_doc_comments

import '../device_summary_model.dart';
import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class LatestConditionResponse {

    int code;
    DeviceSummary? data;

    LatestConditionResponse({required this.code, required this.data});

    static LatestConditionResponse toResponseModel(Map<String, dynamic> map) {
        return LatestConditionResponse(
            code: map['code'],
            data: Mapper.child<DeviceSummary>(map['data'])
        );
    }
}