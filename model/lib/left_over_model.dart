import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_child.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/adjustment_model.dart';
import 'package:model/transfer_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class LeftOver {

    double? received;
    double? consumed;
    double? adjusted;
    double? leftoverTotal;
    double? leftoverInCoop;
    int? remainingPopulation;
    int? margin;

    @IsChild()
    Transfer? transfer;

    @IsChild()
    Adjustment? adjustment;

    LeftOver({this.received, this.consumed, this.adjusted, this.leftoverTotal, this.leftoverInCoop, this.remainingPopulation, this.margin, this.transfer, this.adjustment});

    static LeftOver toResponseModel(Map<String, dynamic> map) {
        return LeftOver(
            received: map['received'] != null ? map['received'].toDouble() : map['received'],
            consumed: map['consumed'] != null ? map['consumed'].toDouble() : map['consumed'],
            adjusted: map['adjusted'] != null ? map['adjusted'].toDouble() : map['adjusted'],
            leftoverTotal: map['leftoverTotal'] != null ? map['leftoverTotal'].toDouble() : map['leftoverTotal'],
            leftoverInCoop: map['leftoverInCoop'] != null ? map['leftoverInCoop'].toDouble() : map['leftoverInCoop'],
            remainingPopulation: map['remainingPopulation'],
            margin: map['margin'],
            transfer: Mapper.child<Transfer>(map['transfer']),
            adjustment: Mapper.child<Adjustment>(map['adjustment']),
        );
    }
}