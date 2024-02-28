import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/left_over_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class LeftOverResponse {
  @IsChild()
  LeftOver? data;

  LeftOverResponse({this.data});

  static LeftOverResponse toResponseModel(Map<String, dynamic> map) {
    return LeftOverResponse(data: Mapper.child<LeftOver>(map['data']));
  }
}
