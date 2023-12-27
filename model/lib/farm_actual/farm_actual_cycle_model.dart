import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FarmActualCycle {

    double? fcr;
    double? mortality;
    double? ipProjection;

    FarmActualCycle({this.fcr, this.mortality, this.ipProjection});

    static FarmActualCycle toResponseModel(Map<String, dynamic> map) {
        return FarmActualCycle(
            fcr: map['fcr'] != null ? map['fcr'].toDouble() : map['fcr'],
            mortality: map['mortality'] != null ? map['mortality'].toDouble() : map['mortality'],
            ipProjection: map['ipProjection'] != null ? map['ipProjection'].toDouble() : map['ipProjection'],
        );
    }
}