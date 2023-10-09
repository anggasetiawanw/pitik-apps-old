
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class AdditionalRequestRealization {

    String? coopId;
    String? coopName;
    int? quantity;
    String? farmingCycleId;

    AdditionalRequestRealization({this.coopId, this.coopName, this.quantity, this.farmingCycleId});

    static AdditionalRequestRealization toResponseModel(Map<String, dynamic> map) {
        return AdditionalRequestRealization(
            coopId: map['coopId'],
            coopName: map['coopName'],
            quantity: map['quantity'],
            farmingCycleId: map['farmingCycleId']
        );
    }
}