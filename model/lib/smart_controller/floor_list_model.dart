import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';

import 'floor_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class FloorList {

    String? coopName;

    @IsChildren()
    List<Floor?> floor;

    FloorList({this.coopName, this.floor = const []});

    static FloorList toResponseModel(Map<String, dynamic> map) {
        return FloorList(
            coopName: map['coopName'],
            floor: Mapper.children<Floor>(map['floor'])
        );
    }
}