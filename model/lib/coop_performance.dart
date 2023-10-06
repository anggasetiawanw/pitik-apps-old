
import 'package:model/coop_active_standard.dart';
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class CoopPerformance {

    @IsChild()
    CoopActiveStandard? bw;

    @IsChild()
    CoopActiveStandard? ip;

    @IsChild()
    CoopActiveStandard? fcr;

    @IsChild()
    CoopActiveStandard? mortality;

    CoopPerformance({this.bw, this.ip, this.fcr, this.mortality});

    static CoopPerformance toResponseModel(Map<String, dynamic> map) {
        return CoopPerformance(
            bw: Mapper.child<CoopActiveStandard>(map['bw']),
            ip: Mapper.child<CoopActiveStandard>(map['ip']),
            fcr: Mapper.child<CoopActiveStandard>(map['fcr']),
            mortality: Mapper.child<CoopActiveStandard>(map['mortality']),
        );
    }
}