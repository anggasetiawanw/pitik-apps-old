/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-16 08:38:06
/// @modify date 2023-02-16 08:38:06
/// @desc [description]

import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/convert.dart';
import 'package:global_variable/text_style.dart';
import 'package:intl/intl.dart';
import 'package:model/internal_app/visit_customer_model.dart';
import 'package:pitik_internal_app/widget/common/lead_status.dart';

class CardListDetail extends StatelessWidget {
    final VisitCustomer customer;
    final Function() onTap;

    const CardListDetail({super.key, required this.customer, required this.onTap});

    @override
    Widget build(BuildContext context) {
        final DateTime dateCustomer = Convert.getDatetime(customer.createdDate!);
        return GestureDetector(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppColors.outlineColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                                          "${dateCustomer.day} ${DateFormat.MMM().format(dateCustomer)} ${dateCustomer.year} - ${dateCustomer.hour}:${dateCustomer.minute}",
                                                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                                                          overflow: TextOverflow.clip,
                                                        ),
                                                    ),
                                                    LeadStatus(leadStatus: customer.leadStatus),
                                                ],
                                            ),
                                        ],
                                    ),
                                ) ,
                            ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${customer.salesperson!.email} ",
                          style: AppTextStyle.blackTextStyle.copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
                        ),
                    ],
                ),
            ),
        );
    }
}
