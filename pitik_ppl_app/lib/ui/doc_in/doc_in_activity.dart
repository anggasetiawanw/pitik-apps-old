import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pitik_ppl_app/ui/doc_in/doc_in_controller.dart';
import 'package:pitik_ppl_app/widget/common/custom_appbar.dart';

class DocInActivity extends StatelessWidget {
  const DocInActivity({super.key});

  @override
  Widget build(BuildContext context) {
    DocInController controller = Get.put(DocInController(context: context));

    Widget header(){
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: GlobalVar.grayBackground,
                border: const Border.fromBorderSide(BorderSide(width: 1.4, color: GlobalVar.outlineColor))
            ),
            child: Column(
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("Detail DOC", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),),
                            Text(controller.proc.value.deliveryDate != null ?DateFormat("dd/MM/yyyy").format(DateTime.parse(controller.proc.value.deliveryDate??"")) :"", style: GlobalVar.blackTextStyle,)
                        ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("Merk DOC", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12,),),
                            Text(controller.proc.value.details.isNotEmpty ? controller.proc.value.details[0]!.productName! : "", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w500),)
                        ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("Total Populasi", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12,),),
                            Text("${controller.proc.value.details.isNotEmpty? (controller.proc.value.details[0]!.quantity??0).toInt():""} Ekor", style: GlobalVar.blackTextStyle.copyWith(fontSize: 12,fontWeight: FontWeight.w500),)
                        ],
                    ),
                ],
            ),
        );
    }

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
                    child: controller.btSave
                ),
        );
    }

    return Obx(() => Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize:const Size.fromHeight(40), 
            child: CustomAppbar(
                title: "Data DOC In", 
                onBack: (){
                    Get.back();
                    },
                ),
            ),
        body:  controller.isLoading.isTrue ? const Center(child: ProgressLoading()) : Stack(
          children: [
            SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                        children: [
                            header(),
                            controller.dtTanggal,
                            controller.efReceiveDoc,
                            controller.efMoreDOC,
                            Row(children: [
                                Expanded(child: controller.efBw,),
                                const SizedBox(width: 8,),
                                Expanded(child: controller.efUniform,),
                            ],),
                            Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      controller.dtTruckGo,
                                      Text("Dari Hatchery", style: GlobalVar.subTextStyle.copyWith(fontSize: 12),)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      controller.dtTruckCome,
                                      Text("Kandang", style: GlobalVar.subTextStyle.copyWith(fontSize: 12),)
                                    ],
                                  ),
                                ),
                            ],),
                            controller.dtFinishDoc,
                           controller.showRecord.isTrue ?  Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    color: GlobalVar.primaryLight2,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(children: [
                                    SvgPicture.asset("images/calendar-line.svg"),
                                    const SizedBox(width: 8,),
                                    Text("Awal Recoding ${controller.dateDoc}", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),) 
                                ],),
                            ): const SizedBox(),
                            controller.efDesc,
                            controller.mfSuratJalan,
                            controller.mfFormDOC,
                            controller.mfAnotherDoc,
                            const SizedBox(height: 100,),
                            MediaQuery.of(context).viewInsets.bottom > 0.0 ? const SizedBox(height: 120,) : const SizedBox()
                        ],
                    ),
                ),
            ),
            bottomNavbar(),
            controller.isLoadingPicture.isTrue ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: ProgressLoading())) : const SizedBox()
          ],
        ), )
    );
  }
}