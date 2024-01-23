import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class AdjustmentClosing {

    double? value;
    String? remarks;

    AdjustmentClosing({this.value, this.remarks});

    static AdjustmentClosing toResponseModel(Map<String, dynamic> map) {
        return AdjustmentClosing(
            value: map['value'] != null ? map['value'].toDouble() : map['value'],
            remarks: map['remarks']
        );
    }
}