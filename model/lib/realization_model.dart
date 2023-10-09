
import 'additional_request_realization_model.dart';
import 'engine_library.dart';
import 'realization_record_model.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class Realization {

    String? id;
    String? farmingCycleId;
    String? harvestDealId;
    String? harvestRequestId;
    String? weighingNumber;
    String? deliveryOrder;
    String? bakulName;
    String? harvestDate;
    String? harvestRequestDate;
    double? minWeight;
    double? maxWeight;
    double? tonnage;
    int? quantity;
    String? weighingTime;
    String? truckDepartingTime;
    String? driver;
    String? truckLicensePlate;
    int? status;
    String? statusText;
    String? addressName;
    String? reason;
    String? witnessName;
    String? receiverName;
    String? coopName;
    String? weigherName;
    String? smartScaleWeighingId;
    double? averageChickenWeighed;
    int? seqNo;

    @IsChildren()
    List<RealizationRecord?> records;

    @IsChildren()
    List<AdditionalRequestRealization?> additionalRequests;

    Realization({this.id, this.farmingCycleId, this.harvestDealId, this.harvestRequestId, this.weighingNumber, this.deliveryOrder, this.bakulName, this.harvestDate, this.harvestRequestDate, this.minWeight,
                 this.maxWeight, this.tonnage, this.quantity, this.weighingTime, this.truckDepartingTime, this.driver, this.truckLicensePlate, this.status, this.statusText, this.addressName, this.reason,
                 this.witnessName, this.receiverName, this.coopName, this.weigherName, this.smartScaleWeighingId, this.averageChickenWeighed, this.seqNo, this.records = const [], this.additionalRequests = const []});

    static Realization toResponseModel(Map<String, dynamic> map) {
        return Realization(
            id: map['id'],
            farmingCycleId: map['farmingCycleId'],
            harvestDealId: map['harvestDealId'],
            harvestRequestId: map['harvestRequestId'],
            weighingNumber: map['weighingNumber'],
            deliveryOrder: map['deliveryOrder'],
            bakulName: map['bakulName'],
            harvestDate: map['harvestDate'],
            harvestRequestDate: map['harvestRequestDate'],
            minWeight: map['minWeight'] != null ? map['minWeight'].toDouble() : map['minWeight'],
            maxWeight: map['maxWeight'] != null ? map['maxWeight'].toDouble() : map['maxWeight'],
            tonnage: map['tonnage'] != null ? map['tonnage'].toDouble() : map['tonnage'],
            quantity: map['quantity'],
            weighingTime:  map['weighingTime'],
            truckDepartingTime: map['truckDepartingTime'],
            driver: map['driver'],
            truckLicensePlate: map['truckLicensePlate'],
            status: map['status'],
            statusText: map['statusText'],
            addressName: map['addressName'],
            reason: map['reason'],
            witnessName: map['witnessName'],
            receiverName: map['receiverName'],
            coopName: map['coopName'],
            weigherName: map['weigherName'],
            smartScaleWeighingId: map['smartScaleWeighingId'],
            averageChickenWeighed: map['averageChickenWeighed'] != null ? map['averageChickenWeighed'].toDouble() : map['averageChickenWeighed'],
            seqNo: map['seqNo'],
            records: Mapper.children<RealizationRecord>(map['records']),
            additionalRequests: Mapper.children<AdditionalRequestRealization>(map['additionalRequests'])
        );
    }
}