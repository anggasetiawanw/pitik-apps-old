/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-13 14:00:11
/// @modify date 2023-02-13 14:00:11
/// @desc [description]

import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:model/internal_app/customer_model.dart';
import 'lead_status.dart';

class CardListHome extends StatelessWidget {
  final Customer customer;
  final Function() onTap;

  const CardListHome({required this.customer, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? dateCustomer;
    if (customer.latestVisit != null) {
      dateCustomer = Convert.getDatetime(customer.latestVisit!.createdDate!);
    }

    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: customer.isArchived! ? const Color(0xFFF9FAFB) : Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(color: AppColors.outlineColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${customer.businessName.toString()} ${customer.isArchived! ? "(Diarsipkan)" : ""}",
                                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            LeadStatus(leadStatus: customer.latestVisit?.leadStatus),
                          ],
                        ),
                        Text(
                          "${customer.district!.name}, ${customer.city!.name ?? "-"}",
                          style: AppTextStyle.subTextStyle.copyWith(fontSize: 10),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(customer.latestVisit != null ? '${customer.salesperson!.email} - ${dateCustomer!.day} ${dateCustomer.month} ${dateCustomer.year} - ${dateCustomer.hour}:${dateCustomer.minute}' : '-',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10, fontWeight: AppTextStyle.medium))
            ])));
  }
}
