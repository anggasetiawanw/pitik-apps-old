import 'package:engine/model/base_model.dart';
import 'package:engine/util/mapper/annotation/is_children.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:model/procurement_model.dart';
import 'package:model/product_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ProcurementRequest {
  String? id;
  String? coopId;
  String? notes;
  String? type;
  String? farmingCycleId;
  String? requestSchedule;
  bool? mergedLogistic;
  String? mergedCoopId;

  @IsChildren()
  List<Product?> details;

  @IsChildren()
  Procurement? internalOvkTransferRequest;

  ProcurementRequest({this.id, this.coopId, this.notes, this.type, this.farmingCycleId, this.requestSchedule, this.mergedLogistic, this.mergedCoopId, this.details = const [], this.internalOvkTransferRequest});

  static ProcurementRequest toResponseModel(Map<String, dynamic> map) {
    return ProcurementRequest(
        id: map['id'],
        coopId: map['coopId'],
        mergedLogistic: map['mergedLogistic'],
        mergedCoopId: map['mergedCoopId'],
        notes: map['notes'],
        type: map['type'],
        farmingCycleId: map['farmingCycleId'],
        requestSchedule: map['requestSchedule'],
        details: Mapper.children<Product>(map['details']),
        internalOvkTransferRequest: Mapper.child<Procurement>(map['internalOvkTransferRequest']));
  }
}
