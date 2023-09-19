import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/manufacture_model.dart';
import 'package:pitik_internal_app/widget/common/manufacture_status.dart';
class CardListManufacture extends StatelessWidget {
  const CardListManufacture({
    super.key, required this.onTap, required this.manufacture,
  });
  final Function() onTap;
  final ManufactureModel manufacture;

  @override
  Widget build(BuildContext context) {

    final DateTime created = Convert.getDatetime(manufacture.createdDate!);
    final DateTime modified = Convert.getDatetime(manufacture.modifiedDate!);
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
                        "${manufacture.input!.name}",
                        style: AppTextStyle.blackTextStyle
                            .copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${manufacture.code} - ${created.day} ${DateFormat.MMM().format(created)} ${created.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16,),
                ManufactureStatus(manufactureStatus: manufacture.status),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "Sumber: ",
                  style: AppTextStyle.greyTextStyle,
                ),
                Text(
                  "${manufacture.operationUnit!.operationUnitName}",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  "Jumlah Ekor: ",
                  style: AppTextStyle.greyTextStyle,
                ),
                Text(
                  "${manufacture.input!.productItems![0]!.quantity} Ekor",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium),
                )
              ],
            ),            
            const SizedBox(
              height: 6,
            ),
           if(manufacture.input!.productItems![0]!.weight !=0 && manufacture.input!.productItems![0]!.weight != null)...[
            Row(
              children: [
                Text(
                  "Total: ",
                  style: AppTextStyle.greyTextStyle,
                ),
                Text(
                  "${manufacture.input!.productItems![0]!.weight} Kg",
                  style: AppTextStyle.blackTextStyle
                      .copyWith(fontWeight: AppTextStyle.medium),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
           ], 
            Text(
              "${manufacture.modifiedBy} - (${modified.day} ${DateFormat.MMM().format(modified)} ${modified.year})",
              style: AppTextStyle.greyTextStyle
                  .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
            )
          ],
        ),
      ),
    );
  }
}
