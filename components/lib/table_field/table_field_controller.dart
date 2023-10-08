
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class TableFieldController extends GetxController {
    String tag;
    TableFieldController({required this.tag});

    var formKey = GlobalKey<FormState>();
    Rx<Widget> layout = (const Row()).obs;

    void generateData({required List<List<String>> data, bool useSticky = false, double widthData = 100, double heightData = 32}) {
        List<Container> columnOne = [];
        for (int columnIndex = 0; columnIndex < data.length; columnIndex ++) {
            Container columnData;
            if (useSticky) {
                columnData = Container(
                    width: widthData,
                    height: heightData,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    color: GlobalVar.primaryLight,
                    child: Text(data[columnIndex][0], style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: columnIndex == 0 ? GlobalVar.bold : GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.center),
                );
            } else {
                columnData = Container(
                    width: widthData,
                    height: heightData,
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    color: GlobalVar.grayBackground,
                    child: Text(data[columnIndex][0], style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: columnIndex == 0 ? GlobalVar.bold : GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.center),
                );
            }

            columnOne.add(columnData);
        }

        List<Row> container = [];
        for (int i = 0; i < data.length; i++) {
            List<Container> column = [];

            for (int j = 1; j < data[i].length; j++) {
                column.add(
                    Container(
                        width: widthData,
                        height: heightData,
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                        color: GlobalVar.grayBackground,
                        child: Text(data[i][j], style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: i == 0 ? GlobalVar.bold : GlobalVar.medium, color: GlobalVar.black), textAlign: TextAlign.center),
                    )
                );
            }

            container.add(
                Row(
                    children: column,
                )
            );
        }

        if (useSticky) {
            layout.value = Row(
                children: [
                    Column(children: columnOne),
                    Flexible(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(children: container),
                        )
                    )
                ],
            );
        } else {
            layout.value = Row(
                children: [
                    Flexible(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                                children: [
                                    Column(children: columnOne),
                                    Column(children: container)
                                ],
                            ),
                        )
                    )
                ],
            );
        }
    }
}

class TableFieldBinding extends Bindings {
    String tag;
    TableFieldBinding({required this.tag});

    @override
    void dependencies() {
        Get.lazyPut<TableFieldController>(() => TableFieldController(tag: tag));
    }
}