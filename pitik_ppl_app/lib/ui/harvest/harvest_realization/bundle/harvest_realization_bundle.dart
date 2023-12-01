
import 'package:model/coop_model.dart';
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 23/11/2023

class HarvestRealizationBundle {
    Coop getCoop;
    Harvest? getHarvest;
    Realization? getRealization;

    HarvestRealizationBundle({required this.getCoop, this.getHarvest, this.getRealization});
}