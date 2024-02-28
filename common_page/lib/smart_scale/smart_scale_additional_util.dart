// ignore_for_file: slash_for_doc_comments

import 'package:engine/util/convert.dart';
import 'package:model/smart_scale/smart_scale_model.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.idd>
/// @create date 11/09/2023

class SmartScaleAdditionalUtil {
  static int getTotalChicken(SmartScale data) {
    int count = 0;
    if (data.records.isNotEmpty) {
      for (var element in data.records) {
        count += element!.count!;
      }
    } else if (data.details.isNotEmpty) {
      for (var element in data.details) {
        count += element!.totalCount!;
      }
    }

    return count;
  }

  static double getTonase(SmartScale data) {
    double count = 0.0;
    if (data.records.isNotEmpty) {
      for (var element in data.records) {
        count += element!.weight!;
      }
    } else if (data.details.isNotEmpty) {
      for (var element in data.details) {
        count += element!.totalWeight!;
      }
    }

    return count;
  }

  static double getAverageWeight(SmartScale data) {
    int i;
    double sumWeight = 0;
    int sumChicken = 0;

    if (data.records.isNotEmpty) {
      for (i = 0; i < data.records.length; i++) {
        sumWeight = sumWeight + data.records[i]!.weight!;
        sumChicken = sumChicken + data.records[i]!.count!;
      }
    } else if (data.details.isNotEmpty) {
      for (i = 0; i < data.details.length; i++) {
        sumWeight = sumWeight + data.details[i]!.totalWeight!;
        sumChicken = sumChicken + data.details[i]!.totalCount!;
      }
    }

    return sumWeight / sumChicken;
  }

  static String getDateWeighing(SmartScale data) => Convert.getDate(data.date);
  static String getStartWeighing(SmartScale data) => Convert.getDate(data.startDate);
  static String getEndWeighing(SmartScale data) => Convert.getDate(data.executionDate);
}
