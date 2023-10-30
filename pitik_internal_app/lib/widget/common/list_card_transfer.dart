import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:pitik_internal_app/widget/common/transfer_status.dart';
class CardListTransfer extends StatelessWidget {
  const CardListTransfer({
    super.key, required this.onTap, required this.transferModel, required this.isGoodReceipts
  });
  final Function() onTap;
  final TransferModel transferModel;
  final bool isGoodReceipts;

  @override
  Widget build(BuildContext context) {
    final DateTime created = Convert.getDatetime(transferModel.createdDate!);
    // final DateTime modified = Convert.getDatetime(transferModel.modifiedDate!);
    return GestureDetector(
        onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineColor, width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${transferModel.targetOperationUnit!.operationUnitName}",
                        style: AppTextStyle.blackTextStyle
                            .copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${transferModel.code} - ${created.day} ${DateFormat.MMM().format(created)} ${created.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16,),
                TransferStatus(transferStatus: transferModel.status, isGoodReceipts: isGoodReceipts,),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Sumber: ",
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  "${transferModel.sourceOperationUnit!.operationUnitName}",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  "SKU: ",
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  " ${transferModel.products!.isNotEmpty ? transferModel.products![0]!.productItems != null ? transferModel.products![0]!.productItems![0]!.name : "null" : "-"}",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  "Total Ekor: ",
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  "${transferModel.products!.isNotEmpty ? transferModel.products![0]!.productItems != null ? transferModel.products![0]!.productItems![0]!.quantity : "null" : "-"} Ekor",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  "Dibuat oleh: ",
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  "${transferModel.createdBy}",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
