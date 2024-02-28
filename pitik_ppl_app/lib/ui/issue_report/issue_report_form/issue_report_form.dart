import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/custom_appbar.dart';
import 'issue_report_form_controller.dart';

class IssueReportForm extends StatelessWidget {
  const IssueReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    final IssueReportFormController controller = Get.put(IssueReportFormController(context: context));
    return Obx(
      () => Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: CustomAppbar(title: 'Tambah Isu', onBack: () => Get.back())),
        bottomNavigationBar: controller.isLoading.isTrue
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [controller.btSave, controller.btCancel],
                ),
              ),
        body: controller.isLoading.isTrue
            ? const Center(
                child: ProgressLoading(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      controller.sfCategory,
                      controller.efDescription,
                      controller.isLoadingPicture.isTrue
                          ? SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 32,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(color: GlobalVar.primaryOrange),
                                    const SizedBox(width: 16),
                                    Text('Upload data issue...', style: TextStyle(color: GlobalVar.primaryOrange, fontSize: 14, fontWeight: GlobalVar.medium))
                                  ],
                                ),
                              ))
                          : controller.mfPhoto,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
