import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/change_branch/change_branch_controller.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class ChangeBranchActivity extends StatelessWidget {
  const ChangeBranchActivity({super.key});

  @override
  Widget build(BuildContext context) {
    ChangeBranchController controller = Get.put(ChangeBranchController(context: context));

    Widget bottomNavbar() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(20, 158, 157, 157),
                  blurRadius: 5,
                  offset: Offset(0.75, 0.0))
            ],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          padding: const EdgeInsets.only(left: 16, bottom: 16,right: 16),
          child: controller.btSimpan,
        ),
      );
    }
    return Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: CustomAppbar(title: "Ganti Branch", onBack: ()=> Get.back())),
        body: Obx(() =>controller.isLoading.isTrue ? Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: ProgressLoading()
                  )
              ),
            )
              : Stack(
            children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.spBranch,
                ),
                bottomNavbar(),
            ],
        )),
    );
  }
}