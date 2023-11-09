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
    int? section;
    int? totalCount;
    double? totalWeight;

    SmartScaleRecord({this.id, this.count, this.weight, this.section, this.totalCount, this.totalWeight});

    static SmartScaleRecord toResponseModel(Map<String, dynamic> map) {
        return SmartScaleRecord(
            id: map['id'],
            count: map['count'],
            weight: map['weight'] != null ? map['weight'].toDouble() : map['weight'],
            section: map['section'],
            totalCount: map['totalCount'],
            totalWeight: map['totalWeight'] != null ? map['totalWeight'].toDouble() : map['totalWeight']
        );
    }
}