import 'package:components/switch_linear/switch_linar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/colors.dart';

class SwitchLinear extends StatelessWidget {
  final Function(bool) onSwitch;
  final SwitchLinearController controller;
  const SwitchLinear({
    super.key,
    required this.onSwitch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Switch(
        value: controller.isSwitchOn.value,
        activeColor: Colors.white,
        activeTrackColor: AppColors.primaryOrange,
        inactiveThumbColor: AppColors.primaryOrange,
        inactiveTrackColor: Colors.white,
        trackOutlineColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.orange.withOpacity(.48);
          }
          return AppColors.primaryOrange; // Use the default color.
        }),
        onChanged: (isSwitch) {
          if (controller.isCanTap.isTrue) {
            controller.isSwitchOn.value = isSwitch;
          }
          onSwitch(isSwitch);
        }));
  }
}
