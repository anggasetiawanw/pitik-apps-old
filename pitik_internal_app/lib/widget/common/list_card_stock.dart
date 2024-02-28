import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/opname_model.dart';
import 'stock_status.dart';

class CardListStock extends StatelessWidget {
  const CardListStock({
    required this.onTap,
    required this.opnameModel,
    required this.isApprove,
    super.key,
  });
  final Function() onTap;
  final OpnameModel opnameModel;
  final bool isApprove;

  @override
  Widget build(BuildContext context) {
    // final DateTime modified = Convert.getDatetime(opnameModel.modifiedDate!);
    final DateTime createdDate = Convert.getDatetime(opnameModel.createdDate!);
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
                        '${opnameModel.operationUnit!.operationUnitName}',
                        style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        '${opnameModel.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year}',
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                StockStatus(
                  stockStatus: opnameModel.status,
                  isApprove: isApprove,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  'SKU: ',
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                ),
                Text(
                  opnameModel.products!.isNotEmpty
                      ? opnameModel.products!.length > 1
                          ? '${opnameModel.products![0]?.name} and ${opnameModel.products!.length - 1} lainnya'
                          : '${opnameModel.products?[0]?.name}'
                      : '-',
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
                  '${opnameModel.totalWeight}',
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
                  '${opnameModel.createdBy}',
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
