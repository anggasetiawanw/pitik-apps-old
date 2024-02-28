import 'package:model/engine_library.dart';

/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-03-20 13:33:25
/// @modify date 2023-03-20 13:33:25
/// @desc [description]

@SetupModel
class CategoryModel {
  String? id;
  String? name;
  double? minValue;
  double? maxValue;

  CategoryModel({this.id, this.name, this.maxValue, this.minValue});

  static CategoryModel toResponseModel(Map<String, dynamic> map) {
    if (map['maxValue'] is int) {
      map['maxValue'] = map['maxValue'].toDouble();
    }
    if (map['minValue'] is int) {
      map['minValue'] = map['minValue'].toDouble();
    }
    return CategoryModel(id: map['id'], name: map['name'], minValue: map['minValue'], maxValue: map['maxValue']);
  }
}
