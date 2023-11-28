// ignore_for_file: use_key_in_widget_constructors, slash_for_doc_comments

import 'package:common_page/smart_scale/detail_smart_scale/detail_smart_scale_controller.dart';
import 'package:common_page/smart_scale/smart_scale_additional_util.dart';
import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 08/09/2023
 */

class DetailSmartScaleActivity extends GetView<DetailSmartScaleController> {

    @override
    Widget build(BuildContext context) {
        DetailSmartScaleController controller = Get.put(DetailSmartScaleController(context: context));

        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: appBar(),
            ),
            body: Obx(() =>
                controller.isLoading.isTrue ?
                const Center(child: ProgressLoading()) :
                Stack(
                    children: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                                children: [
                                    Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: GlobalVar.grayBackground
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                        "Detail Timbangan",
                                                        style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: GlobalVar.black)
                                                    ),
                                                    const SizedBox(height: 16),
                                                    controller.smartScale.value.startDate != null ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text(
                                                                "Mulai Timbang",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                            ),
                                                            Text(
                                                                SmartScaleAdditionalUtil.getStartWeighing(controller.smartScale.value),
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            ),
                                                        ],
                                                    ) : controller.smartScale.value.date != null ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text(
                                                                "Tanggal Timbang",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                            ),
                                                            Text(
                                                                SmartScaleAdditionalUtil.getDateWeighing(controller.smartScale.value),
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            ),
                                                        ],
                                                    ) : const SizedBox(),
                                                    controller.smartScale.value.executionDate != null ? Column(
                                                        children: [
                                                            const SizedBox(height: 8),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Text(
                                                                        "Selesai Timbang",
                                                                        style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                                    ),
                                                                    Text(
                                                                        SmartScaleAdditionalUtil.getEndWeighing(controller.smartScale.value),
                                                                        style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                                    ),
                                                                ],
                                                            )
                                                        ],
                                                    ) : const SizedBox(),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text(
                                                                "Total Ayam",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                            ),
                                                            Text(
                                                                "${SmartScaleAdditionalUtil.getTotalChicken(controller.smartScale.value)} Ekor",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            ),
                                                        ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text(
                                                                "Total Tonase",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                            ),
                                                            Text(
                                                                "${SmartScaleAdditionalUtil.getTonase(controller.smartScale.value).toStringAsFixed(2)} kg",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            ),
                                                        ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text(
                                                                "Berat Rata-Rata",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                            ),
                                                            Text(
                                                                "${SmartScaleAdditionalUtil.getAverageWeight(controller.smartScale.value).toStringAsFixed(2)} kg",
                                                                style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.black)
                                                            ),
                                                        ],
                                                    )
                                                ]
                                            )
                                        )
                                    ),
                                    const SizedBox(height: 16),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(
                                                    "No",
                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                ),
                                                Text(
                                                    "Jumlah Ayam",
                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                ),
                                                Text(
                                                    "Timbangan",
                                                    style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                ),
                                            ],
                                        ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (controller.smartScale.value.records.isNotEmpty) ...[
                                        for (int i = 0; i < controller.smartScale.value.records.length; i++) ...[
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            "${i + 1}",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                        ),
                                                        Text(
                                                            "${controller.smartScale.value.records[i]!.count} Ekor",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                        ),
                                                        Text(
                                                            "${controller.smartScale.value.records[i]!.weight!.toStringAsFixed(2)} kg",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            const SizedBox(height: 4),
                                        ]
                                    ] else if (controller.smartScale.value.details.isNotEmpty) ... [
                                        for (int i = 0; i < controller.smartScale.value.details.length; i++) ...[
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            "${i + 1}",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                        ),
                                                        Text(
                                                            "${controller.smartScale.value.details[i]!.totalCount} Ekor",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                        ),
                                                        Text(
                                                            "${controller.smartScale.value.details[i]!.totalWeight!.toStringAsFixed(2)} kg",
                                                            style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.grayText)
                                                        ),
                                                    ],
                                                ),
                                            ),
                                            const SizedBox(height: 4),
                                        ]
                                    ] else ...[]
                                ],
                            )
                        ),
                        controller.isThisDay() ? bottomNavBar() : const SizedBox()
                    ]
                )
            )
        );
    }

    Widget appBar() => AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text("Data Timbang", style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium)),
    );

    Widget bottomNavBar() => Align(
        alignment: Alignment.bottomCenter,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(20, 158, 157, 157),
                                blurRadius: 5,
                                offset: Offset(0.75, 0.0))
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                                child: ButtonFill(
                                    controller: GetXCreator.putButtonFillController("submitSmartScaleWeighing"),
                                    label: "Timbang Ulang",
                                    onClick: () => controller.rescale()
                                )
                            )
                        ]
                    )
                )
            ]
        )
    );
}