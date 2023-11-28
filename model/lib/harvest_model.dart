import 'package:engine/model/base_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Harvest {

    String? id;
    String? harvestRequestId;
    String? farmingCycleId;
    String? erpCode;
    String? datePlanned;
    String? requestDate;
    String? reason;
    bool? isApproved;
    double? minWeight;
    double? maxWeight;
    String? rentangBw;
    int? quantity;
    int? quantityLeftOver;
    String? totalEstimate;
    String? dateHarvest;
    String? approvedDate;
    String? bakulName;
    String? status;
    String? statusText;
    String? approvalRemarks;
    String? deliveryOrder;
    String? addressName;
    String? coopName;
    String? branchName;
    String? branchCode;
    int? seqNo;
    String? truckLicensePlate;

    Harvest({this.id, this.harvestRequestId, this.farmingCycleId, this.erpCode, this.datePlanned, this.requestDate, this.reason, this.isApproved, this.minWeight, this.maxWeight, this.rentangBw, this.quantity,
             this.quantityLeftOver, this.totalEstimate, this.dateHarvest, this.approvedDate, this.bakulName, this.status, this.statusText, this.approvalRemarks, this.deliveryOrder, this.addressName,
             this.coopName, this.branchName, this.branchCode, this.seqNo, this.truckLicensePlate});

    static Harvest toResponseModel(Map<String, dynamic> map) {
        return Harvest(
            id: map['id'],
            harvestRequestId: map['harvestRequestId'],
            farmingCycleId: map['farmingCycleId'],
            erpCode: map['erpCode'],
            datePlanned: map['datePlanned'],
            requestDate: map['requestDate'],
            reason: map['reason'],
            isApproved: map['isApproved'],
            minWeight: map['minWeight'] != null ? map['minWeight'].toDouble() : map['minWeight'],
            maxWeight: map['maxWeight'] != null ? map['maxWeight'].toDouble() : map['maxWeight'],
            rentangBw: map['rentangBw'],
            quantity: map['quantity'],
            quantityLeftOver: map['quantityLeftOver'],
            totalEstimate: map['totalEstimate'],
            dateHarvest: map['dateHarvest'],
            approvedDate: map['approvedDate'],
            bakulName: map['bakulName'],
            status: map['status'] != null ? map['status'].toString() : map['status'],
            statusText: map['statusText'],
            approvalRemarks: map['approvalRemarks'],
            deliveryOrder: map['deliveryOrder'],
            addressName: map['addressName'],
            coopName: map['coopName'],
            branchName: map['branchName'],
            branchCode: map['branchCode'],
            seqNo: map['seqNo'],
            truckLicensePlate: map['truckLicensePlate']
        );
    }
}