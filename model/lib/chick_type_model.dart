import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ChickType {

    String? id;
    String? name;
    String? category;

    ChickType({this.id, this.name, this.category});

    static ChickType toResponseModel(Map<String, dynamic> map) {
        return ChickType(
            id: map['id'],
            name: map['name'],
            category: map['category']
        );
    }
}