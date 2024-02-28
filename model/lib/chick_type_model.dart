import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ChickType {
  String? id;
  String? chickTypeName;
  String? category;

  ChickType({this.id, this.chickTypeName, this.category});

  static ChickType toResponseModel(Map<String, dynamic> map) {
    return ChickType(id: map['id'], chickTypeName: map['chickTypeName'], category: map['category']);
  }
}
