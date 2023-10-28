import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/order_model.dart';
import 'package:pitik_internal_app/widget/common/order_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 11/05/23

class CardListOrder extends StatelessWidget {
  final Order order;
  final bool isSoPage;
  final Function() onTap;

  const CardListOrder({super.key, required this.order, required this.onTap, this.isSoPage = false});

  @override
  Widget build(BuildContext context) {
    final DateTime dateOrder = Convert.getDatetime(order.createdDate!);
    final DateTime dateModified = Convert.getDatetime(order.modifiedDate!);
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
                          "Penjualan ${order.category}",
                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${order.code} - ${dateOrder.day} ${DateFormat.MMM().format(dateOrder)} ${dateOrder.year} (${dateOrder.hour} : ${dateOrder.minute})",
                          style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  OrderStatus(
                    orderStatus: order.status,
                    returnStatus: order.returnStatus,
                    grStatus: order.grStatus,
                    soPage: isSoPage,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer : ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Expanded(
                    child: Text(
                      "${order.customer == null ? "-" : order.customer?.businessName}",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kategori : ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Text(
                    order.type == "LB" ? "LB" : "Non LB",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SKU : ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Expanded(
                    child: Text(
                      order.products!.isEmpty
                          ? "-"
                          : order.products!.length > 1
                              ? "${order.products![0]!.name} and ${order.products!.length - 1} lainnya"
                              : "${order.products![0]!.name}",
                      style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Ekor : ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Text(
                    order.totalQuantity == null ? "-" : "${order.totalQuantity} Ekor",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dibuat Oleh : ", style: AppTextStyle.subTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                  Text(
                    order.userCreator?.fullName == null ? "-" : "${order.userCreator?.fullName}",
                    style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "${order.salesperson == null ? "-" : order.salesperson!.email!.toString()}" "${" - "}" "(${dateModified.day} ${DateFormat.MMM().format(dateModified)} ${dateModified.year})",
                style: AppTextStyle.subTextStyle.copyWith(fontSize: 11),
                overflow: TextOverflow.clip,
              ),
            ])));
  }
}
