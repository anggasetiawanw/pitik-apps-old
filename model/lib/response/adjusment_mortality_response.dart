import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/adjustment_closing.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class AdjustmentMortalityResponse {

    @IsChild()
    AdjustmentClosing? data;

    AdjustmentMortalityResponse({this.data});

    static AdjustmentMortalityResponse toResponseModel(Map<String, dynamic> map) {
        return AdjustmentMortalityResponse(
            data: Mapper.child<AdjustmentClosing>(map['data'])
        );
    }
}