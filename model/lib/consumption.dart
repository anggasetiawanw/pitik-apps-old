
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Consumption {

    double? remaining;
    String? estimation;
    String? stockoutDate;
    double? consumption;

    Consumption({this.remaining, this.estimation, this.stockoutDate, this.consumption});

    static Consumption toResponseModel(Map<String, dynamic> map) {
        return Consumption(
            remaining: map['consumption'] != null ? map['remaining'].toDouble() : map['consumption'],
            estimation: map['estimation'],
            stockoutDate: map['stockoutDate'],
            consumption: map['consumption'] != null ? map['consumption'].toDouble() : map['consumption'],
        );
    }
}