
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Population {

    int? total;
    int? mortaled;
    int? mortality;
    int? harvested;
    int? remaining;
    int? feedConsumed;
    int? culled;

    Population({this.total, this.mortaled, this.mortality, this.harvested, this.remaining, this.feedConsumed, this.culled});

    static Population toResponseModel(Map<String, dynamic> map) {
        return Population(
            total: map['total'],
            mortaled: map['mortaled'],
            mortality: map['mortality'],
            harvested: map['harvested'],
            remaining: map['remaining'],
            feedConsumed: map['feedConsumed'],
            culled: map['culled'],
        );
    }
}