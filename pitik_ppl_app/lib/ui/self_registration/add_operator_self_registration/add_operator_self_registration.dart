import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/self_registration/add_operator_self_registration/add_operator_self_registration_controller.dart';
import 'package:pitik_ppl_app/utils/widgets/custom_appbar.dart';

class AddOperatorSelfRegistration extends StatelessWidget {
  const AddOperatorSelfRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    AddOperatorSelfRegistrationController controller = Get.put(AddOperatorSelfRegistrationController(context: context));
    return Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(40), child: CustomAppbar(title: "Tambah Operator Kandang", onBack: ()=> Get.back())),
        body: const Center(
            child: Text(
                "Dashboard Self Registration",
                style: TextStyle(fontSize: 20),
            ),
        )
    );
  }
}