import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:model/internal_app/transfer_model.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';
import 'package:pitik_internal_app/widget/common/transfer_status.dart';
class CardListDelivery extends StatelessWidget {
  const CardListDelivery({
    super.key, required this.isPenjualan, required this.onTap, this.order, this.transferModel,
  });
  final bool isPenjualan;
  final Order? order;
  final TransferModel? transferModel;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime created = isPenjualan ? Convert.getDatetime(order!.createdDate!) :Convert.getDatetime(transferModel!.createdDate!) ;
    final DateTime modified = isPenjualan ? Convert.getDatetime(order!.modifiedDate!):Convert.getDatetime(transferModel!.modifiedDate!) ;

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
                        "${isPenjualan? order!.customer!.businessName : transferModel!.targetOperationUnit!.operationUnitName}",
                        style: AppTextStyle.blackTextStyle
                            .copyWith(fontWeight: AppTextStyle.medium, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        isPenjualan ? "${order!.code} - ${created.day} ${DateFormat.MMM().format(created)} ${created.year}" : "${transferModel!.code} - ${created.day} ${DateFormat.MMM().format(created)} ${created.year}",
                        style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                      )
                    ],
                  ),
                ),
                isPenjualan? OrderStatus(orderStatus: order!.status,returnStatus: order!.returnStatus,grStatus: order!.grStatus,soPage: true,) : TransferStatus(transferStatus: transferModel!.status,isGoodReceipts: false,),
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
                  isPenjualan ? "${order!.operationUnit?.operationUnitName}" :  "${transferModel!.sourceOperationUnit!.operationUnitName}",
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
                  "SKU: ",
                  style: AppTextStyle.greyTextStyle,
                ),
                Expanded(
                  child: Text(
                    isPenjualan? order!.products!.length > 1 ? "${order!.products![0]!.name} and ${order!.products!.length -1 } lainnya" : "${order!.products![0]!.name}": "${transferModel!.products!.isNotEmpty ? transferModel!.products![0]!.productItems != null ? transferModel!.products![0]!.productItems![0]!.name : "null" : "-"}",
                    style: AppTextStyle.blackTextStyle
                        .copyWith(fontWeight: AppTextStyle.medium),
                        overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
             isPenjualan ?  "${order!.salesperson == null ? "-" : order!.salesperson!.email!.toString()}" "${" - "}" " ${modified.day} ${DateFormat.MMM().format(modified)} ${modified.year}  ":"${transferModel!.modifiedBy} - (${modified.day} ${DateFormat.MMM().format(modified)} ${modified.year})",
              style: AppTextStyle.greyTextStyle
                  .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
            )
          ],
        ),
      ),
    );
  }
}
