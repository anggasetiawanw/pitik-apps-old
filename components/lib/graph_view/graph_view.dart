// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../library/model_library.dart';
import 'graph_view_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
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
                child: Container(
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
                            markerSettings: TrackballMarkerSettings(
                                width: 4,
                                height: 4,
                                borderWidth: 8,
                                borderColor: Colors.white,
                                color: Colors.white,
                                markerVisibility: TrackballVisibilityMode.visible,
                            ),
                            activationMode: ActivationMode.singleTap,
                            builder: (context, trackballDetails) {
                                trackballDetails.groupingModeInfo!.points[0].pointColorMapper = controller.lineMaxColor.value;
                                trackballDetails.groupingModeInfo!.points[1].pointColorMapper = controller.lineMinColor.value;
                                trackballDetails.groupingModeInfo!.points[2].pointColorMapper = controller.lineCurrentColor.value;

                                return Wrap(
                                    children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: controller.backgroundCurrentTooltip.value,
                                                borderRadius: BorderRadius.all(Radius.circular(8))
                                            ),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                children: [
                                                    Text(
                                                        'Current',
                                                        style: TextStyle(
                                                            color: controller.textColorCurrentTooltip.value,
                                                            fontSize: 10),
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
                                                        '${controller.selectedDate.value}',
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
                        // tooltipBehavior: TooltipBehavior(
                        //     color: Colors.white,
                        //     canShowMarker: true,
                        //     enable: true,
                        //     duration: 60000,
                        //     builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                        //         String headerLabel = '${(data as GraphLine).current} C';
                        //
                        //         if (seriesIndex == 0) {
                        //             headerLabel = '${(data).benchmarkMax} C';
                        //         } else if (seriesIndex == 1) {
                        //             headerLabel = '${(data).benchmarkMin} C';
                        //         }
                        //
                        //         return Container(
                        //             decoration: BoxDecoration(
                        //                 color: seriesIndex == 0 ? controller.backgroundMaxTooltip.value : seriesIndex == 1 ? controller.backgroundMinTooltip.value : controller.backgroundCurrentTooltip.value,
                        //                 borderRadius: BorderRadius.all(Radius.circular(8))
                        //             ),
                        //             padding: EdgeInsets.all(10),
                        //             height: 50,
                        //             child: Column(
                        //                 children: [
                        //                     Text(
                        //                         headerLabel,
                        //                         style: TextStyle(
                        //                             color: seriesIndex == 0 ? controller.textColorMaxTooltip.value : seriesIndex == 1 ? controller.textColorMinTooltip.value : controller.textColorCurrentTooltip.value,
                        //                             fontSize: 14),
                        //                     ),
                        //                     Text(
                        //                         '${data.label}',
                        //                         style: TextStyle(color: seriesIndex == 0 ? controller.textColorMaxTooltip.value : seriesIndex == 1 ? controller.textColorMinTooltip.value : controller.textColorCurrentTooltip.value, fontSize: 10),
                        //                     ),
                        //                 ],
                        //             ),
                        //         );
                        //     },
                        // ),
                        primaryXAxis: NumericAxis(
                            labelRotation: -90,
                            axisLabelFormatter: (AxisLabelRenderDetails args) {
                                TextStyle textStyle = const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12);

                                double round = double.parse(args.text).roundToDouble();
                                return ChartAxisLabel(controller.data[round.toInt()].label!, textStyle);
                            },
                            majorGridLines: MajorGridLines(width: 0),
                            majorTickLines: MajorTickLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                            majorGridLines: MajorGridLines(width: 2),
                            majorTickLines: MajorTickLines(width: 0),
                            axisLine: AxisLine(
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
            )
        );
    }
}