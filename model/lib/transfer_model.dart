import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Transfer {
  double? delivered;
  double? notDeliveredYet;

  Transfer({this.delivered, this.notDeliveredYet});

  static Transfer toResponseModel(Map<String, dynamic> map) {
    return Transfer(delivered: map['delivered'] != null ? map['delivered'].toDouble() : map['delivered'], notDeliveredYet: map['notDeliveredYet'] != null ? map['notDeliveredYet'].toDouble() : map['notDeliveredYet']);
  }
}
