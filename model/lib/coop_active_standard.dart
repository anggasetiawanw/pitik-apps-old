import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class CoopActiveStandard {
  int? day;
  double? actual;
  double? standard;

  CoopActiveStandard({this.day, this.actual, this.standard});

  static CoopActiveStandard toResponseModel(Map<String, dynamic> map) {
    return CoopActiveStandard(day: map['day'], actual: map['actual'] != null ? map['actual'].toDouble() : map['actual'], standard: map['standard'] != null ? map['standard'].toDouble() : map['standard']);
  }
}
