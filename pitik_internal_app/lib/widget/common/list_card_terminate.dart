import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/terminate_model.dart';
import 'transfer_terminate.dart';

class CardListTerminate extends StatelessWidget {
  const CardListTerminate({
    required this.onTap,
    required this.terminateModel,
    required this.isApproved,
    super.key,
  });
  final Function() onTap;
  final TerminateModel terminateModel;

  final bool isApproved;

  @override
  Widget build(BuildContext context) {
    final DateTime created = Convert.getDatetime(terminateModel.createdDate!);
    // final DateTime modified = Convert.getDatetime(terminateModel.modifiedDate!);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: AppColors.outlineColor, width: 1), borderRadius: BorderRadius.circular(8)),
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
                        '${terminateModel.product!.productItem!.name}',
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${terminateModel.code} - ${created.day} ${DateFormat.MMM().format(created)} ${created.year}',
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                TerminateStatus(
                  terminateStatus: terminateModel.status,
                  isApproved: isApproved,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  'Sumber: ',
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  '${terminateModel.operationUnit!.operationUnitName}',
                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  'Jumlah Ekor: ',
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  '${terminateModel.product!.productItem!.quantity} Ekor',
                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  'Total Kg: ',
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  '${terminateModel.product!.productItem!.weight} Kg',
                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  'Dibuat: ',
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  '${terminateModel.createdBy}',
                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
