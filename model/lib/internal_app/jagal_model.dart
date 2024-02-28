import 'package:model/engine_library.dart';
import 'package:model/internal_app/product_model.dart';

@SetupModel
class JagalModel {
  String? id;
  String? priceBasis;
  Products? liveBird;
  int? innardsPrice;
  int? headPrice;
  int? feetPrice;
  int? operationalDays;
  int? operationalExpenses;

  JagalModel({this.id});

  static JagalModel toResponseModel(Map<String, dynamic> map) {
    return JagalModel(id: map['id']);
  }
}
