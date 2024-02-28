import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/custom_appbar.dart';
import 'add_operator_self_registration_controller.dart';

class AddOperatorSelfRegistration extends StatelessWidget {
  const AddOperatorSelfRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    final AddOperatorSelfRegistrationController controller = Get.put(AddOperatorSelfRegistrationController(context: context));
    return Obx(
      () => controller.isLoading.isTrue
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: GlobalVar.primaryOrange,
                ),
              ),
            )
          : Scaffold(
              appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: CustomAppbar(title: 'Tambah Operator Kandang', onBack: () => Get.back())),
              bottomNavigationBar: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Color.fromARGB(20, 158, 157, 157), blurRadius: 5, offset: Offset(0.75, 0.0))],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                padding: const EdgeInsets.only(left: 16, bottom: 24, right: 16),
                child: controller.btnSubmit,
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: GlobalVar.primaryLight2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kandang Penugasan',
                              style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${controller.coop.coopName}', style: GlobalVar.blackTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium)),
                                Text("Chickin ${controller.coop.startDate == null || controller.coop.startDate!.isEmpty ? '-' : Convert.getDate(controller.coop.startDate)}", style: GlobalVar.greyTextStyle.copyWith(fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      controller.efHandphoneNumber,
                      controller.efOperatorName,
                      controller.efTask,
                      controller.efPassword,
                      controller.efConfirmPassword,
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
