
import 'dart:io';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/harvest_model.dart';
import 'package:model/realization_model.dart';
import 'package:model/realization_record_model.dart';
import 'package:model/smart_scale/smart_scale_record_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pitik_ppl_app/route.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 29/12/2023

class SmartScaleHarvestDetailController extends GetxController {
    BuildContext context;
    SmartScaleHarvestDetailController({required this.context});

    late Coop coop;
    late Realization realization;

    var isLoading = false.obs;
    var isEdit = true.obs;
    var isPreview = false.obs;
    var isNext = true.obs;
    var pageSelected = 1.obs;
    var buttonNextTitle = 'Selanjutnya'.obs;

    Rx<Widget> containerButtonEditAndPreview = (const SizedBox(width: 0, height: 0)).obs;
    Rx<Row> paginationNumber = (const Row()).obs;
    RxList<List<Row>> paginationWidget = <List<Row>>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        realization = Get.arguments[1];

        if (realization.statusText != GlobalVar.TEREALISASI) {
            isEdit.value = false;
        }

        // try hardcoded
        List<SmartScaleRecord?> record = [
            SmartScaleRecord(id: '1', count: 10, weight: 18.9, section: 1, totalCount: 10, totalWeight: 18.9),
            SmartScaleRecord(id: '2', count: 15, weight: 25.2, section: 2, totalCount: 15, totalWeight: 12.2),
            SmartScaleRecord(id: '3', count: 13, weight: 55.2, section: 3, totalCount: 13, totalWeight: 55.2),
            SmartScaleRecord(id: '4', count: 12, weight: 21.2, section: 4, totalCount: 12, totalWeight: 21.2),
            SmartScaleRecord(id: '5', count: 15, weight: 13.6, section: 5, totalCount: 15, totalWeight: 13.6),
            SmartScaleRecord(id: '6', count: 20, weight: 32.0, section: 6, totalCount: 20, totalWeight: 32.0),
            SmartScaleRecord(id: '7', count: 14, weight: 10.9, section: 7, totalCount: 14, totalWeight: 10.9),
            SmartScaleRecord(id: '8', count: 19, weight: 11.3, section: 8, totalCount: 19, totalWeight: 11.3),
            SmartScaleRecord(id: '9', count: 40, weight: 40.4, section: 9, totalCount: 40, totalWeight: 40.4),
            SmartScaleRecord(id: '10', count: 30, weight: 50.7, section: 10, totalCount: 30, totalWeight: 50.7),
            SmartScaleRecord(id: '11', count: 13, weight: 15.5, section: 11, totalCount: 13, totalWeight: 15.5),
        ];
        realization.records = [
            RealizationRecord(weighingNumber: 'B8819200AC', tonnage: 1002.4, quantity: 199, page: 1, averageWeight: 2.3, image: '', details: record)
        ];

        generatePaginationNumber();
        _getSmartScaleDataWidget();
        _generateButtonBottom();
    }

    void _generateButtonBottom() => {
        if (isEdit.isTrue && isPreview.isFalse) {
            containerButtonEditAndPreview.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSmartScaleHarvestEditRealization"), label: "Edit", onClick: () {
                                        Harvest harvest = Harvest(
                                            id: realization.id,
                                            deliveryOrder: realization.deliveryOrder,
                                            status: realization.status.toString(),
                                            statusText: realization.statusText,
                                            datePlanned: realization.harvestRequestDate,
                                            minWeight: realization.minWeight,
                                            maxWeight: realization.maxWeight,
                                            quantity: realization.quantity,
                                            reason: realization.reason,
                                            weighingNumber: realization.weighingNumber,
                                            coopName: realization.coopName,
                                            addressName: realization.addressName,
                                            bakulName: realization.bakulName,
                                            truckLicensePlate: realization.truckLicensePlate
                                        );

                                        Get.toNamed(RoutePage.smartScaleHarvestForm, arguments: [
                                            coop,
                                            harvest,
                                            realization.weighingTime,
                                            realization.truckDepartingTime,
                                            realization.driver,
                                            realization.witnessName,
                                            realization.receiverName,
                                            realization.weigherName
                                        ])!.then((value) => Get.back());
                                    })
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnSmartScaleHarvestPreviewRealization"), label: "Preview", onClick: () {
                                    isPreview.value = true;
                                    _generateButtonBottom();
                                }))
                            ]
                        )
                    )
                )
            )
        } else if (isPreview.isTrue) {
            containerButtonEditAndPreview.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: ButtonFill(controller: GetXCreator.putButtonFillController("btnSmartScaleHarvestNextRealization"), label: buttonNextTitle.value, onClick: () {
                                        isNext.value = !isNext.value;
                                        buttonNextTitle.value = isNext.value ? 'Selanjutnya' : 'Sebelumnya';
                                        _generateButtonBottom();
                                    }),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnSmartScaleHarvestDownloadRealization"), label: "Download PDF", onClick: () => _createPdf()))
                            ]
                        )
                    )
                )
            )
        } else {
            containerButtonEditAndPreview.value = SizedBox(
                child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2)]
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(child: ButtonOutline(controller: GetXCreator.putButtonOutlineController("btnSmartScaleHarvestPreviewRealization"), label: "Preview", onClick: () {
                                    isPreview.value = true;
                                    _generateButtonBottom();
                                }))
                            ]
                        )
                    )
                )
            )
        }
    };

    String getQuantityText() => '${realization.quantity == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.quantity.toString(), '', '.')} Ekor';
    String getTonnageText() => '${realization.tonnage == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.tonnage.toString(), '', '.')} Kg';
    String getAverageWeightText() => '${realization.averageChickenWeighed == null ? '-' : Convert.toCurrencyWithoutDecimal(realization.averageChickenWeighed.toString(), '', '.')} Kg';
    String getBwText() => '${realization.minWeight == null ? '-' : realization.minWeight!.toStringAsFixed(1)} Kg s.d ${realization.maxWeight == null ? '-' : realization.maxWeight!.toStringAsFixed(1)} Kg';

    Widget getRealizationStatusWidget({required String statusText}) {
        Color background = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryLight2 :
                           statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.redBackground :
                           statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.greenBackground:
                           statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE ? GlobalVar.blueBackground :
                           Colors.white;

        Color textColor = statusText == GlobalVar.PENGAJUAN || statusText == GlobalVar.SUBMITTED || statusText == GlobalVar.NEED_APPROVAL ? GlobalVar.primaryOrange :
                          statusText == GlobalVar.DITOLAK || statusText == GlobalVar.ABORT ? GlobalVar.red :
                          statusText == GlobalVar.DIPROSES || statusText == GlobalVar.SELESAI ? GlobalVar.green:
                          statusText == GlobalVar.DEAL || statusText == GlobalVar.TEREALISASI || statusText == GlobalVar.AVAILABLE ? GlobalVar.blue :
                          Colors.white;

        return Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                color: background
            ),
            child: Text(
                statusText,
                style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: textColor)
            )
        );
    }

    void generatePaginationNumber() {
        if (realization.records.isNotEmpty && realization.records[0]!.details.isNotEmpty) {
            paginationNumber.value = Row(
                children: List.generate((realization.records[0]!.details.length / 10).ceil(), (index) {
                    return GestureDetector(
                        onTap: () {
                            pageSelected.value = index + 1;
                            generatePaginationNumber();
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('${index + 1}', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.bold, color: pageSelected.value == index + 1 ? GlobalVar.primaryOrange : GlobalVar.gray))
                        ),
                    );
                }),
            );
        }
    }

    void _getSmartScaleDataWidget() {
        if (realization.records.isNotEmpty && realization.records[0]!.details.isNotEmpty) {
            paginationWidget.clear();

            int idx = 0;
            int number = 1;
            int page = 0;
            List<Row> data = [];
            for (var element in realization.records[0]!.details) {
                final EditField totalChick = EditField(controller: GetXCreator.putEditFieldController("totalChickenDetailSmartScaleHarvest$number"), label: "", hint: "", alertText: "", hideLabel: true,
                    textUnit: "Ekor", inputType: TextInputType.number, maxInput: 10,
                    onTyping: (text, editField) {}
                );

                final EditField totalWeight = EditField(controller: GetXCreator.putEditFieldController("totalWeighingDetailSmartScaleHarvest$number"), label: "", hint: "", alertText: "", hideLabel: true,
                    textUnit: "kg", inputType: TextInputType.number, maxInput: 10,
                    onTyping: (text, editField) {}
                );

                totalChick.setInput('${element!.count ?? element.totalCount ?? ''}');
                totalWeight.setInput('${element.weight ?? element.totalWeight ?? ''}');

                totalChick.controller.disable();
                totalWeight.controller.disable();

                if (idx == 10) {
                    page++;
                    paginationWidget.add([]);
                    data = [];
                    data.add(_createDataScale(number: number, totalChick: totalChick, totalWeight: totalWeight));
                    paginationWidget.insert(page, data);
                    idx = 1;
                } else {
                    data.add(_createDataScale(number: number, totalChick: totalChick, totalWeight: totalWeight));
                    paginationWidget.insert(page, data);
                    idx++;
                }

                number++;
            }
        }
    }

    Row _createDataScale({required int number, required EditField totalChick, required EditField totalWeight}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Container(
                    height: 50,
                    width: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: GlobalVar.gray
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Center(child: Text('$number', style: GlobalVar.whiteTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: const Color(0xFF9E9D9D))))
                    )
                )
            ),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        const SizedBox(width: 8),
                        Expanded(child: totalChick),
                        const SizedBox(width: 8),
                        Expanded(child: totalWeight)
                    ]
                )
            )
        ]
    );

    void _createPdf() async {
        isLoading.value = true;
        final pdf = pw.Document();

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
                return pw.Column(
                    children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('No. Timbang', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.weighingNumber ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Tanggal Tangkap', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.harvestDate ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Nama Kandang', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.coopName ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Alamat', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.addressName ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Jam Tangkap', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.weighingTime ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Jam Berangkat', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.truckDepartingTime ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Bakul', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.bakulName ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Nama Sopir', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.driver ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Nopol Kendaraan', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.truckLicensePlate ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Rentang BW', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text('${realization.minWeight == null ? '- Kg' : '${realization.minWeight} Kg'} s/d ${realization.maxWeight == null ? '- Kg' : '${realization.maxWeight} Kg'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Jumlah Ayam', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text('${realization.quantity ?? '-'} Ekor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Alasan Panen', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.reason ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 16),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Diketahui Oleh', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.witnessName ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Diterima Oleh', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.receiverName ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                                pw.Text('Ditimbang Oleh', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                                pw.Text(realization.weigherName ?? '-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))
                            ]
                        ),
                        pw.SizedBox(height: 16),
                        pw.Table(
                            border: pw.TableBorder.all(width: 1.4),
                            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                            children: List.generate(realization.records.isNotEmpty && realization.records[0]!.details.isNotEmpty ? realization.records[0]!.details.length + 1 : 1, (index) {
                                if (index == 0) {
                                    return pw.TableRow(
                                        children: [
                                            pw.Text('NO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                                            pw.Text('Jumlah Ayam', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                                            pw.Text('Timbangan', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                                        ]
                                    );
                                } else {
                                    return pw.TableRow(
                                        children: [
                                            pw.Text('$index', style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 11)),
                                            pw.Text('${realization.records[0]!.details[index - 1] != null ? realization.records[0]!.details[index - 1]!.totalCount ?? '-' : '-'} Ekor', style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 11)),
                                            pw.Text('${realization.records[0]!.details[index - 1] != null ? realization.records[0]!.details[index - 1]!.totalWeight ?? '-' : '-'} Ekor', style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 11)),
                                        ]
                                    );
                                }
                            })
                        )
                    ]
                ); // Center
            })
        ); //

        Directory root = await getApplicationDocumentsDirectory();
        String fullPathIncludeName = "${root.path}/${DateTime.now().millisecondsSinceEpoch}_SmartScaleHarvest.pdf";
        final file = File(fullPathIncludeName);
        await file.writeAsBytes(await pdf.save());// Page
        isLoading.value = false;
        print('directory -> $fullPathIncludeName');
        Get.snackbar("Pesan", 'Berhasil mengunduh data ($fullPathIncludeName)...', snackPosition: SnackPosition.TOP, colorText: Colors.black, backgroundColor: Colors.white);
    }
}

class SmartScaleHarvestDetailBinding extends Bindings {
    BuildContext context;
    SmartScaleHarvestDetailBinding({required this.context});

    @override
    void dependencies() => Get.lazyPut<SmartScaleHarvestDetailController>(() => SmartScaleHarvestDetailController(context: context));
}