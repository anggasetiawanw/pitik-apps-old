// ignore_for_file: must_be_immutable

import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sapronak_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class SapronakActivity extends GetView<SapronakController> {
  const SapronakActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Expandable(
                expanded: true,
                controller: GetXCreator.putAccordionController("sapronakFeed"),
                headerText: "Pakan",
                child: Column(
                  children: List.generate(controller.feedData.length + 1, (index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tanggal', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black)),
                            Text('Jenis', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black)),
                            Text('QTY', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black)),
                          ],
                        ),
                      );
                    } else {
                      String data = '${controller.feedData[index - 1]!.subcategoryName!} - ${controller.feedData[index - 1]!.productName ?? ''}';
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(controller.feedData[index - 1]!.date!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)))),
                            Flexible(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(data, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                )),
                            Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(controller.feedData[index - 1]!.quantity == null ? '-' : controller.feedData[index - 1]!.quantity!.toStringAsFixed(0),
                                      style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                ))
                          ],
                        ),
                      );
                    }
                  }),
                )),
            const SizedBox(height: 16),
            Expandable(
                expanded: true,
                controller: GetXCreator.putAccordionController("sapronakOvk"),
                headerText: "OVK",
                child: Column(
                  children: List.generate(controller.ovkData.length + 1, (index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tanggal', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black)),
                            Text('Produk', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black), textAlign: TextAlign.left),
                            Text('QTY', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: Colors.black)),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(controller.ovkData[index - 1]!.date!, style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)))),
                            Flexible(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(controller.ovkData[index - 1]!.productName ?? '', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                )),
                            Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(controller.ovkData[index - 1]!.quantity == null ? '-' : controller.ovkData[index - 1]!.quantity!.toStringAsFixed(0),
                                      style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                ))
                          ],
                        ),
                      );
                    }
                  }),
                )),
            const SizedBox(height: 100)
          ],
        ));
  }
}
