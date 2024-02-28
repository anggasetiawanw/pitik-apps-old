// ignore_for_file: no_logic_in_create_state;, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors, slash_for_doc_comments, depend_on_referenced_packages, constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../global_var.dart';
import 'datetime_field_controller.dart';

/// @author Robertus Mahardhi Kuncoro
/// @email <robert.kuncoro@pitik.id>
/// @create date 09/08/23

class DateTimeField extends StatelessWidget {
  static const int DATE_FLAG = 1;
  static const int TIME_FLAG = 2;
  static const int ALL_FLAG = 3;

  DateTimeFieldController controller;
  String label;
  String hint;
  String alertText;
  bool hideLabel = false;
  int flag;
  Function(DateTime, DateTimeField) onDateTimeSelected;

  DateTimeField({super.key, required this.controller, required this.label, required this.hint, required this.alertText, this.flag = ALL_FLAG, required this.onDateTimeSelected});

  DateTimeFieldController getController() {
    return Get.find(tag: controller.tag);
  }

  DateTime _lastDateTime = DateTime.now();

  DateTime getLastTimeSelected() {
    return _lastDateTime;
  }

  String getLastTimeSelectedText() {
    return getController().textSelected.value;
  }

  @override
  Widget build(BuildContext context) {
    final labelField = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        controller.label.value.isEmpty ? label : controller.label.value,
        textAlign: TextAlign.left,
        style: const TextStyle(color: GlobalVar.black, fontSize: 14),
      ),
    );

    return Obx(() => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: <Widget>[
              controller.hideLabel.isFalse ? labelField : Container(),
              Padding(
                  key: controller.formKey,
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _showPicker(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              color: controller.activeField.isTrue ? GlobalVar.primaryLight : GlobalVar.gray,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: controller.activeField.isTrue && controller.showTooltip.isFalse
                                      ? Colors.transparent
                                      : controller.activeField.isTrue && controller.showTooltip.isTrue
                                          ? GlobalVar.red
                                          : Colors.transparent,
                                  width: 2)),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(controller.textSelected.value == "" ? hint : controller.textSelected.value,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: controller.activeField.isTrue && controller.textSelected.value != ""
                                                ? GlobalVar.black
                                                : controller.activeField.isTrue && controller.textSelected.value == ""
                                                    ? GlobalVar.grayLightText
                                                    : GlobalVar.black,
                                            fontSize: 14)),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: controller.activeField.isTrue
                                      ? flag == DATE_FLAG || flag == ALL_FLAG
                                          ? SvgPicture.asset("images/calendar-line.svg")
                                          : SvgPicture.asset("images/time_on_icon.svg")
                                      : flag == DATE_FLAG || flag == ALL_FLAG
                                          ? SvgPicture.asset("images/calendar-line-off.svg")
                                          : SvgPicture.asset("images/time_on_icon_disable.svg")),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: controller.showTooltip.isTrue
                            ? Container(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Padding(padding: const EdgeInsets.only(right: 8), child: SvgPicture.asset("images/error_icon.svg")),
                                    Expanded(
                                      child: Text(
                                        alertText,
                                        style: const TextStyle(color: GlobalVar.red, fontSize: 12),
                                        overflow: TextOverflow.clip,
                                      ),
                                    )
                                  ],
                                ))
                            : Container(),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  Future<void> _showPicker(BuildContext context) async {
    if (controller.activeField.isTrue) {
      if (flag == DATE_FLAG) {
        DateTime? pickedDate = await showDatePicker(context: context, initialDate: _lastDateTime, firstDate: DateTime(1900), lastDate: DateTime(2200));

        if (pickedDate != null) {
          _lastDateTime = pickedDate;
          controller.hideAlert();
          onDateTimeSelected(_lastDateTime, this);
        }
      } else if (flag == TIME_FLAG) {
        TimeOfDay initTime = TimeOfDay.fromDateTime(_lastDateTime);
        TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initTime.replacing(hour: initTime.hourOfPeriod));

        if (pickedTime != null) {
          _lastDateTime = DateTime(_lastDateTime.year, _lastDateTime.month, _lastDateTime.day, pickedTime.hour, pickedTime.minute);
          controller.hideAlert();
          onDateTimeSelected(_lastDateTime, this);
        }
      } else {
        DateTime? pickedDate = await showDatePicker(context: context, initialDate: _lastDateTime, firstDate: DateTime(1900), lastDate: DateTime(2200));

        if (pickedDate != null) {
          _lastDateTime = pickedDate;
          TimeOfDay initTime = TimeOfDay.fromDateTime(pickedDate);
          TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initTime.replacing(hour: initTime.hourOfPeriod));

          if (pickedTime != null) {
            _lastDateTime = DateTime(_lastDateTime.year, _lastDateTime.month, _lastDateTime.day, pickedTime.hour, pickedTime.minute);
            controller.hideAlert();
            onDateTimeSelected(_lastDateTime, this);
          }
        }
      }
    }
  }
}
