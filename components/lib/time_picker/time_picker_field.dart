// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'time_picker_controller.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class TimePickerField extends StatelessWidget {

    static const int TIME_ALL = 1;
    static const int TIME_HOURS_AND_MINUTES = 2;
    static const int TIME_MINUTES_AND_SECONDS = 3;

    TimePickerController controller;
    String label;
    String hint;
    String alertText;
    bool hideLabel = false;
    int flag;
    Function(String) onTimeSelected;

    TimePickerField({super.key, required this.controller, required this.label, required this.hint, required this.alertText, this.flag = TIME_MINUTES_AND_SECONDS, required this.onTimeSelected});

    TimePickerController getController() {
        return Get.find(tag: controller.tag);
    }

    String timePicked = "00:00";
    final DateTime _lastDateTime = DateTime.now();

    DateTime getLastTimeSelected() {
        return _lastDateTime;
    }

    String getLastTimeSelectedText() {
        return getController().textSeleted.value;
    }

    @override
    Widget build(BuildContext context) {
        final labelField = SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(color: GlobalVar.black, fontSize: 14),
            ),
        );

        return Obx(() =>
            Padding(
                key: controller.formKey,
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                    children: <Widget>[
                        controller.hideLabel.isFalse ? labelField : Container(),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Column(
                                children: <Widget>[
                                    GestureDetector(
                                        onTap: () => controller.activeField.isTrue ? _showPicker(context) : null,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                                                borderRadius: BorderRadius.circular(10.0),
                                                border: Border.all(color: controller.activeField.isTrue && controller.showTooltip.isFalse ? Colors.white : controller.activeField.isTrue && controller.showTooltip.isTrue ? GlobalVar.red : Colors.white, width: 2)
                                            ),
                                            child: Row(
                                                children: [
                                                    Expanded(
                                                        flex: 8,
                                                        child: Padding(
                                                            padding: const EdgeInsets.only(left: 8),
                                                            child: Text(
                                                                controller.textSeleted.value == "" ? hint : controller.textSeleted.value,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(color: controller.activeField.isTrue ? controller.textSeleted.value == "" ? const Color(0xFF9E9D9D) : GlobalVar.black : GlobalVar.black, fontSize: 14)
                                                            )
                                                        )
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: SvgPicture.asset(controller.activeField.isTrue ? "images/hour_glass_icon.svg" : "images/hour_glass_disable_icon.svg")
                                                    )
                                                ]
                                            )
                                        )
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: controller.showTooltip.isTrue
                                            ? Container(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Row(
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.only(right: 8),
                                                        child: SvgPicture.asset("images/error_icon.svg")
                                                    ),
                                                    Text(
                                                        alertText,
                                                        style: TextStyle(color: GlobalVar.red, fontSize: 12),
                                                    )
                                                ]
                                            )
                                        ) : Container(),
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }

    Future<void> _showPicker(BuildContext context) async {
        if (flag == TIME_ALL) {
            Picker(
                adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                    const NumberPickerColumn(begin: 0, end: 24, suffix: Text('')),
                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text('')),
                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text('')),
                ]),
                hideHeader: true,
                height: 70,
                confirmText: 'Ok',
                confirmTextStyle: TextStyle(inherit: false, color: GlobalVar.primaryOrange, fontSize: 16),
                title: Text('Tentukan Durasi', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 18)),
                selectedTextStyle: TextStyle(color: GlobalVar.primaryOrange),
                cancelTextStyle: TextStyle(color: GlobalVar.primaryOrange),
                onConfirm: (Picker picker, List<int> value) {
                    // You get your duration here
                    String hours = "${picker.getSelectedValues()[0]}";
                    String minutes = "${picker.getSelectedValues()[1]}";
                    String seconds = "${picker.getSelectedValues()[2]}";
                    hours = hours.length < 2 ?"0${picker.getSelectedValues()[0]}": hours;
                    minutes = minutes.length < 2 ?"0${picker.getSelectedValues()[1]}": minutes;
                    seconds = seconds.length < 2 ?"0${picker.getSelectedValues()[2]}": seconds;
                    timePicked = "$hours : $minutes : $seconds";
                    onTimeSelected(timePicked);
                },
            ).showDialog(context);
        } else if (flag == TIME_HOURS_AND_MINUTES) {
            Picker(
                adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                    const NumberPickerColumn(begin: 0, end: 24, suffix: Text(' Jam')),
                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' Menit')),
                ]),
                hideHeader: true,
                height: 90,
                confirmText: 'Ok',
                confirmTextStyle: TextStyle(inherit: false, color: GlobalVar.primaryOrange, fontSize: 16),
                title: Text('Tentukan Durasi', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 18)),
                selectedTextStyle: TextStyle(color: GlobalVar.primaryOrange),
                cancelTextStyle: TextStyle(color: GlobalVar.primaryOrange),
                onConfirm: (Picker picker, List<int> value) {
                    String hours = "${picker.getSelectedValues()[0]}";
                    String minutes = "${picker.getSelectedValues()[1]}";
                    hours = hours.length < 2 ?"0${picker.getSelectedValues()[0]}": hours;
                    minutes = minutes.length < 2 ?"0${picker.getSelectedValues()[1]}": minutes;
                    timePicked = "$hours:$minutes";
                    onTimeSelected(timePicked);
                },
            ).showDialog(context);
        } else {
            Picker(
                adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' Menit')),
                    const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' Detik')),
                ]),
                hideHeader: true,
                height: 90,
                confirmText: 'Ok',
                confirmTextStyle: TextStyle(inherit: false, color: GlobalVar.primaryOrange, fontSize: 16),
                title: Text('Tentukan Durasi', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 18)),
                selectedTextStyle: TextStyle(color: GlobalVar.primaryOrange),
                cancelTextStyle: TextStyle(color: GlobalVar.primaryOrange),
                onConfirm: (Picker picker, List<int> value) {

                    String minutes = "${picker.getSelectedValues()[0]}";
                    String seconds = "${picker.getSelectedValues()[1]}";
                    minutes = minutes.length < 2 ?"0${picker.getSelectedValues()[0]}": minutes;
                    seconds = seconds.length < 2 ?"0${picker.getSelectedValues()[1]}": seconds;
                    timePicked = "$minutes:$seconds";
                    onTimeSelected(timePicked);
                },
            ).showDialog(context);
        }
    }
}