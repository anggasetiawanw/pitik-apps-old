import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/purchase_model.dart';
import 'package:pitik_internal_app/widget/common/purchase_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 05/04/23

class CardListPurchase extends StatelessWidget {
  final Purchase purchase;
  final Function() onTap;

  const CardListPurchase({super.key, required this.purchase, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final DateTime createdDate = Convert.getDatetime(purchase.createdDate!);
    // final DateTime modifiedDate = Convert.getDatetime(purchase.modifiedDate!);

    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all(color: AppColors.outlineColor, width: 1), borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${purchase.vendor == null ? purchase.jagal == null ? "-" : purchase.jagal!.operationUnitName! : purchase.vendor!.name}",
                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${purchase.code} - ${createdDate.day} ${DateFormat.MMM().format(createdDate)} ${createdDate.year}",
                          style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  PurchaseStatus(purchaseStatus: purchase.status),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Jenis Sumber: ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Text(
                    purchase.vendor != null
                        ? "Vendor"
                        : purchase.jagal != null
                            ? "Jagal Eksternal"
                            : "",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tujuan: ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Text(
                    "${purchase.operationUnit == null ? "-" : purchase.operationUnit!.operationUnitName}",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SKU: ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                    Expanded(
                        child: Text(
                      purchase.products!.isEmpty
                          ? "-"
                          : purchase.products!.length > 1
                              ? "${purchase.products![0]!.name} dan ${purchase.products!.length - 1} lainnya"
                              : "${purchase.products![0]!.name}",
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                      overflow: TextOverflow.clip,
                    ))
                  ]),
              const SizedBox(
                height: 6,
              ),
              Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Ekor: ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                    Expanded(
                        child: Text(
                      purchase.totalQuantity != null ? "${purchase.totalQuantity} Ekor" : "-",
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                      overflow: TextOverflow.clip,
                    ))
                  ]),
              const SizedBox(
                height: 6,
              ),
              Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dibuat oleh: ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                    Expanded(
                        child: Text(
                      purchase.createdBy ?? "-",
                      style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium, fontSize: 12),
                      overflow: TextOverflow.clip,
                    ))
                  ]),
            ])));
  }
}
