import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/utils/constant.dart';

Future<dynamic> modalBottomSheetTrueData(BuildContext context, ButtonFill iyaVisitButton, ButtonOutline tidakVisitButton) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 16, right: 73),
                child: Text(
                  "Apakah kamu yakin data yang dimasukan sudah benar?",
                  style: AppTextStyle.primaryTextStyle
                      .copyWith(fontSize: 21, fontWeight: AppTextStyle.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, left: 16, right: 52),
                child: const Text(
                    "Pastikan semua data yang kamu masukan semua sudah benar",
                    style: TextStyle(color: Color(0xFF9E9D9D), fontSize: 12)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: SvgPicture.asset(
                  "images/visit_customer.svg",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: iyaVisitButton),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: tidakVisitButton
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constant.bottomSheetMargin,)
            ],
          ),
        );
      });
}