// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/graph_line.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class GraphViewController extends GetxController {
  String tag;
  GraphViewController({required this.tag});

  var showLineMin = true.obs;
  var showLineMax = true.obs;
  var data = <GraphLine>[].obs;
  var uom = '\u2109'.obs;

  var selectedCurrent = '-'.obs;
  var selectedMin = '-'.obs;
  var selectedMax = '-'.obs;
  var selectedDate = '-'.obs;

  Rx<Color?> lineMinColor = Colors.transparent.obs;
  Rx<Color?> lineMaxColor = Colors.transparent.obs;
  Rx<Color?> lineCurrentColor = Colors.transparent.obs;
  Rx<Color?> backgroundMin = Colors.transparent.obs;
  Rx<Color?> backgroundMax = Colors.transparent.obs;

  Rx<Color?> backgroundMinTooltip = Colors.transparent.obs;
  Rx<Color?> textColorMinTooltip = Colors.transparent.obs;
  Rx<Color?> backgroundMaxTooltip = Colors.transparent.obs;
  Rx<Color?> textColorMaxTooltip = Colors.transparent.obs;
  Rx<Color?> backgroundCurrentTooltip = Colors.transparent.obs;
  Rx<Color?> textColorCurrentTooltip = Colors.transparent.obs;

  GraphViewController setUom(String uom) {
    this.uom.value = uom;
    return this;
  }

  GraphViewController visibleLineMin(bool active) {
    showLineMin.value = active;
    return this;
  }

  GraphViewController visibleLineMax(bool active) {
    showLineMax.value = active;
    return this;
  }

  GraphViewController setBackgroundMinTooltip(Color color) {
    backgroundMinTooltip.value = color;
    return this;
  }

  GraphViewController setTextColorMinTooltip(Color color) {
    textColorMinTooltip.value = color;
    return this;
  }

  GraphViewController setBackgroundMaxTooltip(Color color) {
    backgroundMaxTooltip.value = color;
    return this;
  }

  GraphViewController setTextColorMaxTooltip(Color color) {
    textColorMaxTooltip.value = color;
    return this;
  }

  GraphViewController setBackgroundCurrentTooltip(Color color) {
    backgroundCurrentTooltip.value = color;
    return this;
  }

  GraphViewController setTextColorCurrentTooltip(Color color) {
    textColorCurrentTooltip.value = color;
    return this;
  }

  GraphViewController setLineMinColor(Color? color) {
    lineMinColor.value = color;
    return this;
  }

  GraphViewController setLineMaxColor(Color? color) {
    lineMaxColor.value = color;
    return this;
  }

  GraphViewController setLineCurrentColor(Color? color) {
    lineCurrentColor.value = color;
    return this;
  }

  GraphViewController setBackgroundMin(Color? color) {
    backgroundMin.value = color;
    return this;
  }

  GraphViewController setBackgroundMax(Color? color) {
    backgroundMax.value = color;
    return this;
  }

  void clearData() {
    data.clear();
    data.refresh();
  }

  void setupData(List<GraphLine> graphData) {
    if (graphData.length == 1) {
      data.add(graphData.first);
    }

    // add all data and add 1 data for initialize
    for (var element in graphData) {
      data.add(element);
    }

    // add order for all data
    for (int i = 0; i < data.length; i++) {
      data[i].order = i;
    }

    data.refresh();
  }
}

class GraphViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GraphViewController>(() => GraphViewController(tag: "tag"));
  }
}
