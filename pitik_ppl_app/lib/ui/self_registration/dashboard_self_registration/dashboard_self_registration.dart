import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/self_registration/dashboard_self_registration/dashboard_self_registration_controller.dart';
import 'package:pitik_ppl_app/utils/widgets/custom_appbar.dart';

class DashboardSelfRegistration extends StatelessWidget {
  const DashboardSelfRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardSelfRegistrationController controller = Get.put(DashboardSelfRegistrationController(context: context));
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(40), child: CustomAppbar(title: "Operator Kandang", onBack: () => Get.back())),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           controller.btAddOperator,
            controller.btAddTask
          ],
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
                                      "${controller.listOperators[index].role!} - ${controller.listOperators[index].phoneNumber!}",
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
