
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ScaleValue {

    int? section;
    int? totalCount;
    double? totalWeight;

    ScaleValue({this.section, this.totalCount, this.totalWeight});

    static ScaleValue toResponseModel(Map<String, dynamic> map) {
        return ScaleValue(
            section: map['section'],
            totalCount: map['totalCount'],
            totalWeight: map['totalWeight'] != null ? map['totalWeight'].toDouble() : map['totalWeight']
        );
    }
}