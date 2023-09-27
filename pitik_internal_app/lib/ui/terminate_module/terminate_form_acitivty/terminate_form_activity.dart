import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/get_x_creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/terminate_module/terminate_form_acitivty/terminate_form_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class TerminateFormActivity extends StatelessWidget {
  const TerminateFormActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final TerminateFormController controller = Get.put(TerminateFormController(context: context));
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: AppColors.primaryOrange,
        centerTitle: true,
        title: Text(
          "Form Pemusnahan",
          style: AppTextStyle.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(child:ButtonFill(controller: GetXCreator.putButtonFillController("saveButton"), label: "Simpan", onClick: (){
                                if(controller.isEdit.isTrue){
                                    controller.updateTerminate("DRAFT");
                                } else {
                                    controller.createTerminate("DRAFT");
                                }
                            }
                            )),
                            const SizedBox(width: 16,),
                            Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("confirmButtin"), label: "Konfirmasi", onClick: (){_showBottomDialog(context,controller);}))
                        ],
                    ),
                ),
            );
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: appBar(),
        ),  
        body: Obx(() => controller.isLoading.isTrue? const Center(child: ProgressLoading() ):Stack(
            children: [
                SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                        children: [
                          controller.sourceField,
                          controller.categorySKUField,
                          controller.skuField,
                          controller.amountField,
                          controller.totalField,
                          controller.mediaField,
                          Obx(() =>controller.isEdit.isTrue ? controller.isLoadingPicture.isFalse ? Container(
                            margin: const EdgeInsets.only(top: 16),
                            child:Column(
                              children: [
                                Image.network(
                                   controller.mediaField.controller.fileName.isNotEmpty? controller.mediaUploadData.value.url!:controller.terminateModel!.imageLink!,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryOrange,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                      ),
                                      );
                                  },
                          ),
                          const SizedBox(height: 100,)
                              ],
                            ) ,
                          ):const SizedBox() : const SizedBox()),
                          MediaQuery.of(context).viewInsets.bottom > 0.0 ? const SizedBox(height: 120,) : const SizedBox()
                        ],
                    ),
                  ),
                ),
                bottomNavbar(),
                Obx(() => controller.isLoadingPicture.isTrue ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.withOpacity(0.5),
                    child: const Center(
                        child: ProgressLoading(),
                    ),
                ) : const SizedBox())

            ],
        ),  
    ));
  }
  _showBottomDialog(BuildContext context, TerminateFormController controller) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                  child: Text(
                    "Apakah kamu yakin data yang dimasukan sudah benar?",
                    style: AppTextStyle.primaryTextStyle
                        .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                  child: const Text(
                      "Pastikan semua data yang kamu masukan semua sudah benar",
                      style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: SvgPicture.asset(
                    "images/visit_customer.svg",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: controller.yesButton),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: controller.noButton
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constant.bottomSheetMargin,)
              ],
            ),
          );
        });
  }
}