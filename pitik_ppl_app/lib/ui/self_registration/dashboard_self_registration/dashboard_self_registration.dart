import 'package:components/app_bar_form_for_coop.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_self_registration_controller.dart';

class DashboardSelfRegistration extends StatelessWidget {
  const DashboardSelfRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardSelfRegistrationController controller = Get.put(DashboardSelfRegistrationController(context: context));
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(120), child: AppBarFormForCoop(title: 'Operator Kandang', coop: controller.coop)),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        padding: const EdgeInsets.only(left: 16, bottom: 24, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [controller.btAddOperator, controller.btAddTask],
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(
              color: GlobalVar.primaryOrange,
            ))
          : ListView(
              children: [
                Obx(() => controller.listOperators.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.listOperators.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: GlobalVar.outlineColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.person, color: GlobalVar.primaryOrange),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.listOperators[index].fullName!,
                                      style: GlobalVar.blackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${controller.listOperators[index].role!} - ${controller.listOperators[index].phoneNumber!}',
                                      style: GlobalVar.subTextStyle.copyWith(fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : const SizedBox()),
              ],
            )),
    );
  }
}
