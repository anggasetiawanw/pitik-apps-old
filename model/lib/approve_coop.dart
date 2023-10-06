
import 'engine_library.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

@SetupModel
class ApproveCoop {

    String? id;
    String? farmingCycleId;
    bool? isApproved;

    ApproveCoop({this.id, this.farmingCycleId, this.isApproved});

    static ApproveCoop toResponseModel(Map<String, dynamic> map) {
        return ApproveCoop(
            id: map['id'],
            farmingCycleId: map['farmingCycleId'],
            isApproved: map['isApproved']
        );
    }
}