// ignore_for_file: slash_for_doc_comments

import '../smart_scale/smart_scale_model.dart';
import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class ListSmartScaleResponse {

    @IsChildren()
    List<SmartScale?> data;

    ListSmartScaleResponse({this.data = const []});

    static ListSmartScaleResponse toResponseModel(Map<String, dynamic> map) {
        return ListSmartScaleResponse(
            data: Mapper.children<SmartScale>(map['data'])
        );
    }
}