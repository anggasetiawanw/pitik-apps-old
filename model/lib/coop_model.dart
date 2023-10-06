// ignore_for_file: slash_for_doc_comments

import 'package:model/approve_coop.dart';
import 'package:model/branch.dart';
import 'package:model/coop_active_standard.dart';
import 'package:model/room_model.dart';

import '../engine_library.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

@SetupModel
class Coop {

    String? id;
    String? name;
    dynamic status;
    String? coopId;
    String? coopName;
    String? coopType;
    String? coopStatus;
    String? farmId;
    String? chickInRequestId;
    String? farmingCycleId;
    String? farmName;
    String? coopDistrict;
    String? coopCity;
    int? period;
    bool? isNew;
    String? startDate;
    String? closedDate;
    bool? hasChickInRequest;
    int? day;
    String? statusText;
    bool? isActionNeeded;
    bool? isOwnFarm;

    @IsChild()
    CoopActiveStandard? bw;

    @IsChild()
    CoopActiveStandard? ip;

    @IsChild()
    ApproveCoop? chickInRequest;

    @IsChild()
    ApproveCoop? purchaseRequestOvk;

    @IsChild()
    Branch? branch;

    @IsChild()
    Room? room;

    @IsChildren()
    List<Room?>? rooms;

    Coop({this.id, this.name, this.coopName, this.coopType, this.farmId, this.status, this.coopStatus, this.room, this.rooms, this.coopId, this.chickInRequestId, this.farmName, this.coopDistrict, this.coopCity,
          this.farmingCycleId, this.period, this.isNew, this.startDate, this.closedDate, this.hasChickInRequest, this.day, this.statusText, this.isActionNeeded, this.isOwnFarm, this.bw, this.ip, this.chickInRequest,
          this.purchaseRequestOvk, this.branch});

    static Coop toResponseModel(Map<String, dynamic> map) {
        return Coop(
            id: map['id'],
            name: map['name'],
            status: map['status'],
            coopName: map['coopName'],
            coopType: map['coopType'],
            coopStatus: map['coopStatus'],
            farmId: map['farmId'],
            coopId: map['coopId'],
            room: Mapper.child<Room>(map['room']),
            rooms: Mapper.children<Room>(map['rooms']),
            chickInRequestId: map['chickInRequestId'],
            farmingCycleId: map['farmingCycleId'],
            farmName: map['farmName'],
            coopDistrict: map['coopDistrict'],
            coopCity: map['coopCity'],
            period: map['period'],
            isNew: map['isNew'],
            startDate: map['startDate'],
            closedDate: map['closedDate'],
            hasChickInRequest: map['hasChickInRequest'],
            day: map['day'],
            statusText: map['statusText'],
            isActionNeeded: map['isActionNeeded'],
            isOwnFarm: map['isOwnFarm'],
            bw: Mapper.child<CoopActiveStandard>(map['bw']),
            ip: Mapper.child<CoopActiveStandard>(map['ip']),
            chickInRequest: Mapper.child<ApproveCoop>(map['chickInRequest']),
            purchaseRequestOvk: Mapper.child<ApproveCoop>(map['purchaseRequestOvk']),
            branch: Mapper.child<Branch>(map['branch'])
        );
    }
}