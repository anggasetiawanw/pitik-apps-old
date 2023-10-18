// ignore_for_file: must_be_immutable, slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/graph_line.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph_view_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class GraphView extends StatelessWidget {

    GraphViewController controller;
    GraphView({super.key, required this.controller});

    GraphViewController getController() {
        return Get.find(tag: controller.tag);
    }

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SfCartesianChart(
                    onTrackballPositionChanging: (TrackballArgs args) {
                        if (args.chartPointInfo.seriesIndex == 0) {
                            controller.selectedMax.value = '${args.chartPointInfo.series!.dataSource[args.chartPointInfo.dataPointIndex!].benchmarkMax}';
                            controller.selectedMin.value = '${args.chartPointInfo.series!.dataSource[args.chartPointInfo.dataPointIndex!].benchmarkMin}';
                            controller.selectedCurrent.value = '${args.chartPointInfo.series!.dataSource[args.chartPointInfo.dataPointIndex!].current}';
                            controller.selectedDate.value = '${args.chartPointInfo.series!.dataSource[args.chartPointInfo.dataPointIndex!].label}';
                        }
                    },
                    trackballBehavior: TrackballBehavior(
                        enable: true,
                        lineColor: controller.textColorCurrentTooltip.value,
                        shouldAlwaysShow: true,
                        markerSettings: const TrackballMarkerSettings(
                            width: 4,
                            height: 4,
                            borderWidth: 8,
                            borderColor: Colors.white,
                            color: Colors.white,
                            markerVisibility: TrackballVisibilityMode.visible,
                        ),
                        activationMode: ActivationMode.singleTap,
                        builder: (context, trackballDetails) {
                            if (trackballDetails.groupingModeInfo!.points.isNotEmpty) {
                                trackballDetails.groupingModeInfo!.points[0].pointColorMapper = controller.lineMaxColor.value;
                            }
                            if (trackballDetails.groupingModeInfo!.points.length > 1) {
                                trackballDetails.groupingModeInfo!.points[1].pointColorMapper = controller.lineMinColor.value;
                            }
                            if (trackballDetails.groupingModeInfo!.points.length > 2) {
                                trackballDetails.groupingModeInfo!.points[2].pointColorMapper = controller.lineCurrentColor.value;
                            }

                            return Wrap(
                                children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: controller.backgroundCurrentTooltip.value,
                                            borderRadius: const BorderRadius.all(Radius.circular(8))
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            children: [
                                                Text(
                                                    'Current',
                                                    style: TextStyle(
                                                        color: controller.textColorCurrentTooltip.value,
                                                        fontSize: 10
                                                    ),
                                                ),
                                                Text(
                                                    '${controller.selectedCurrent.value} ${controller.uom}',
                                                    style: TextStyle(
                                                        color: controller.textColorCurrentTooltip.value,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                ),
                                                Text(
                                                    'Max',
                                                    style: TextStyle(
                                                        color: controller.textColorMaxTooltip.value,
                                                        fontSize: 10
                                                    ),
                                                ),
                                                Text(
                                                    '${controller.selectedMax.value}  ${controller.uom}',
                                                    style: TextStyle(
                                                        color: controller.textColorMaxTooltip.value,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                ),
                                                Text(
                                                    'Min',
                                                    style: TextStyle(
                                                        color: controller.textColorMinTooltip.value,
                                                        fontSize: 10
                                                    ),
                                                ),
                                                Text(
                                                    '${controller.selectedMin.value}  ${controller.uom}',
                                                    style: TextStyle(
                                                        color: controller.textColorMinTooltip.value,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                ),
                                                Text(
                                                    controller.selectedDate.value,
                                                    style: TextStyle(color: controller.textColorCurrentTooltip.value, fontSize: 10),
                                                ),
                                            ],
                                        ),
                                    )
                                ],
                            );
                        },
                        tooltipAlignment: ChartAlignment.center,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints
                    ),
                    primaryXAxis: NumericAxis(
                        labelRotation: -90,
                        axisLabelFormatter: (AxisLabelRenderDetails args) {
                            TextStyle textStyle = const TextStyle(
                                fontFamily: 'Montserrat',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 12
                            );

                            try {
                                double round = double.parse(args.text).roundToDouble();
                                return ChartAxisLabel(controller.data[round.toInt()].label!, textStyle);
                            } catch (exception) {
                                return ChartAxisLabel('', textStyle);
                            }
                        },
                        majorGridLines: const MajorGridLines(width: 0),
                        majorTickLines: const MajorTickLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 2),
                        majorTickLines: const MajorTickLines(width: 0),
                        axisLine: const AxisLine(
                            color: Colors.white,
                            width: 2,
                        )
                    ),
                    enableAxisAnimation: true,
                    series: <ChartSeries<GraphLine, double?>>[
                        //benchmark max
                        SplineRangeAreaSeries<GraphLine, double?>(
                            dataSource: controller.showLineMax.isTrue ? controller.data : [],
                            color: controller.backgroundMax.value,
                            borderColor: controller.lineMaxColor.value,
                            borderWidth: 3,
                            xValueMapper: (GraphLine point, _) => point.order.toDouble(),
                            lowValueMapper: (GraphLine point, _) =>
                                            controller.backgroundMax.value != Colors.transparent && controller.showLineMin.isFalse ? 0 :
                                            point.benchmarkMin == null || controller.showLineMin.isFalse ? point.benchmarkMax :
                                            point.benchmarkMin,
                            highValueMapper: (GraphLine point, _) => point.benchmarkMax
                        ),
                        // benchmark min
                        SplineRangeAreaSeries<GraphLine, double?>(
                            dataSource: controller.showLineMin.isTrue ? controller.data : [],
                            color: controller.backgroundMin.value,
                            borderColor: controller.lineMinColor.value,
                            borderWidth: 3,
                            xValueMapper: (GraphLine point, _) => point.order.toDouble(),
                            lowValueMapper: (GraphLine point, _) => controller.backgroundMin.value != Colors.transparent ? 0 : point.benchmarkMin,
                            highValueMapper: (GraphLine point, _) => point.benchmarkMin
                        ),
                        // current data
                        SplineSeries<GraphLine, double?>(
                            dataSource: controller.data,
                            color: controller.lineCurrentColor.value,
                            width: 3,
                            xValueMapper: (GraphLine point, _) => point.order.toDouble(),
                            yValueMapper: (GraphLine point, _) => point.current,
                        )
                    ]
                )
            )
        );
    }
}