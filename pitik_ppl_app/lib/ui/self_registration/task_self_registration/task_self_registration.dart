import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/self_registration/task_self_registration/tasl_self_registration_controller.dart';
import 'package:pitik_ppl_app/utils/widgets/custom_appbar.dart';

class TaskSelfRegistration extends StatelessWidget {
  const TaskSelfRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    TaskSelfRegistrationController controller = Get.put(TaskSelfRegistrationController(context: context));
    return Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(40), child: CustomAppbar(title: "Penugasan", onBack: ()=> Get.back())),
        body: const Center(
            child: Text(
                "Dashboard Self Registration",
                style: TextStyle(fontSize: 20),
            ),
        )
    );
  }
}