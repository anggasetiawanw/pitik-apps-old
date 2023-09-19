import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/sales_module/edit_data_activity/edit_data_controller.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class EditData extends GetView<EditDataController> {
    const EditData({super.key});

    @override
    Widget build(BuildContext context) {
        final EditDataController controller = Get.put(EditDataController(context: context));

        Widget appBar() {
            return AppBar(
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                ),
                backgroundColor: AppColors.primaryOrange,
                centerTitle: true,
                title: Text(
                    "Edit Customer",
                    style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                ),
            );
        }

        return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: appBar(),
            ),
            body:Obx(() => controller.isLoading.isTrue ?const Center(
                  child: ProgressLoading()
                ): Stack(
                children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                    controller.editNamaBisnis,
                                    controller.spinnerTipeBisnis,
                                    controller.editNamaPemilik,
                                    controller.editNomorTelepon,
                                    Obx(() => controller.isLoading.isTrue ? controller.spinnerPicSales : controller.spinnerPicSales),
                                    controller.editLokasiGoogle,
                                    Obx(() => controller.isLoadApi.isTrue ? controller.spinnerProvince : controller.spinnerProvince),
                                    Obx(() => controller.isLoadApi.isTrue ? controller.spinnerKota : controller.spinnerKota),
                                    Obx(() => controller.isLoadApi.isTrue ? controller.spinnerKecamatan : controller.spinnerKecamatan),
                                    controller.spinnerSupplier,
                                    controller.editNamaSupplier,
                                    Obx(() => controller.isLoading.isTrue ? controller.skuCard : controller.skuCard),
                                    const SizedBox(height: 100),
                                ],
                            ),
                        ),
                    ),
                    Align(
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
                            child: controller.simpanButton,
                        ),
                    ),
                ],
            ),
        ));
    }
}
