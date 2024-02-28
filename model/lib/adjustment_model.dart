import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Adjustment {
  double? plus;
  double? minus;

  Adjustment({this.plus, this.minus});

  static Adjustment toResponseModel(Map<String, dynamic> map) {
    return Adjustment(plus: map['plus'] != null ? map['plus'].toDouble() : map['plus'], minus: map['minus'] != null ? map['minus'].toDouble() : map['minus']);
  }
}
