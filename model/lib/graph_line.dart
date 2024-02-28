// ignore_for_file: slash_for_doc_comments

import '../engine_library.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

@SetupModel
class GraphLine {
  int order;
  double? current;
  String? label;
  double? benchmarkMin;
  double? benchmarkMax;

  GraphLine({this.order = 0, this.current, this.label, this.benchmarkMin, this.benchmarkMax});

  static GraphLine toResponseModel(Map<String, dynamic> map) {
    if (map['order'] == null) {
      map['order'] = 0;
    }
    if (map['current'] is int) {
      map['current'] = map['current'].toDouble();
    }
    if (map['benchmarkMin'] is int) {
      map['benchmarkMin'] = map['benchmarkMin'].toDouble();
    }
    if (map['benchmarkMax'] is int) {
      map['benchmarkMax'] = map['benchmarkMax'].toDouble();
    }

    return GraphLine(order: map['order'], current: map['current'], label: map['label'], benchmarkMin: map['benchmarkMin'], benchmarkMax: map['benchmarkMax']);
  }
}
