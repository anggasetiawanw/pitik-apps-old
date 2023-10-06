
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Consumption {

    int? remaining;
    String? estimation;
    String? stockoutDate;
    int? consumption;

    Consumption({this.remaining, this.estimation, this.stockoutDate, this.consumption});

    static Consumption toResponseModel(Map<String, dynamic> map) {
        return Consumption(
            remaining: map['remaining'],
            estimation: map['estimation'],
            stockoutDate: map['stockoutDate'],
            consumption: map['consumption'],
        );
    }
}