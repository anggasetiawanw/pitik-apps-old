// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class SmartScaleRecord {

    String? id;
    int? count;
    double? weight;

    SmartScaleRecord({this.id, this.count, this.weight});

    static SmartScaleRecord toResponseModel(Map<String, dynamic> map) {
        return SmartScaleRecord(
            id: map['id'],
            count: map['count'],
            weight: map['weight'].toDouble()
        );
    }
}