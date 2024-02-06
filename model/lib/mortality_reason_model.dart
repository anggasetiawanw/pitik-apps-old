import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class MortalityReason {

    int? quantity;
    String? cause;

    MortalityReason({this.quantity, this.cause});

    static MortalityReason toResponseModel(Map<String, dynamic> map) {
        return MortalityReason(
            quantity: map['quantity'],
            cause: map['cause']
        );
    }
}