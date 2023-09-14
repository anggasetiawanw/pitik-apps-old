import '../engine_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
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