import 'package:flutter/widgets.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 05/04/23

class PurchaseStatus extends StatelessWidget {
  const PurchaseStatus({required this.purchaseStatus, super.key});

  final String? purchaseStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: purchaseStatus == null
              ? AppColors.grey
              : purchaseStatus == 'CANCELLED'
                  ? const Color(0xFFFEE4E2)
                  : purchaseStatus == 'DRAFT'
                      ? const Color(0xFFFEEFD2)
                      : purchaseStatus == 'CONFIRMED'
                          ? const Color(0xFFD0F5FD)
                          : const Color(0xFFCEFCD8),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
        purchaseStatus == null
            ? 'Draft'
            : purchaseStatus == 'CONFIRMED'
                ? 'Terkonfirmasi'
                : purchaseStatus == 'CANCELLED'
                    ? 'Dibatalkan'
                    : purchaseStatus == 'RECEIVED'
                        ? 'Diterima'
                        : purchaseStatus == 'FINISHED'
                            ? 'Selesai'
                            : 'Draft',
        style: purchaseStatus == null
            ? AppTextStyle.blackTextStyle
            : purchaseStatus == 'CANCELLED'
                ? const TextStyle(color: Color(0xFFDD1E25))
                : purchaseStatus == 'DRAFT'
                    ? AppTextStyle.primaryTextStyle
                    : purchaseStatus == 'CONFIRMED'
                        ? const TextStyle(color: Color(0xFF198BDB))
                        : const TextStyle(color: Color(0xFF14CB82)),
      )),
    );
  }
}
