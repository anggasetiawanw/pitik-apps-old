import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/req_doc_in/req_doc_in_controller.dart';
import 'package:pitik_ppl_app/utils/widgets/custom_appbar.dart';

class RequestDocIn extends StatelessWidget {
    const RequestDocIn({super.key});

    @override
    Widget build(BuildContext context) {
        RequestDocInController controller = Get.put(RequestDocInController(context: context));

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
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(child: controller.btNext),
                                if(controller.boEdit.controller.activeField.isTrue)...[
                                    const SizedBox(width: 8,),
                                    Expanded(child: controller.boEdit)
                                ]
                            ]
                        )
                    )
                );
        }

        return Scaffold(
            appBar: PreferredSize(preferredSize: const Size.fromHeight(40), child: CustomAppbar(title: "Request Doc In", isFlat: true, onBack: () => Get.back())),
            body: Obx(() =>
                controller.isLoading.isTrue ? const Center(child: ProgressLoading()) :
                Stack(
                    children: [
                        SingleChildScrollView(
                            child: Column(
                                children: [
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16, top: 12),
                                        decoration: const BoxDecoration(
                                            color: GlobalVar.primaryOrange,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                        ),
                                        child: Text("${controller.coop.coopName}", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                            children: [
                                                controller.dtTanggal,
                                                controller.efPopulasi
                                            ]
                                        )
                                    )
                                ]
                            )
                        ),
                        bottomNavbar(),
                    ],
                ),
            )
        );
    }
}
