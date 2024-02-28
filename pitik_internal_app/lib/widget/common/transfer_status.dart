import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

class TransferStatus extends StatelessWidget {
  const TransferStatus({required this.transferStatus, required this.isGoodReceipts, super.key});

  final String? transferStatus;
  final bool isGoodReceipts;
  //"DRAFT" | "CONFIRMED" | "ORDERED" | "ASSIGNED" | "DELIVERED" | "CANCELED"
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: transferStatus == null
              ? AppColors.grey
              : transferStatus == 'DRAFT'
                  ? const Color(0xFFFEEFD2)
                  : transferStatus == 'CONFIRMED'
                      ? const Color(0xFFD0F5FD)
                      : transferStatus == 'BOOKED'
                          ? const Color(0xFFFAEDCF)
                          : transferStatus == 'READY_TO_DELIVER'
                              ? const Color(0xFFFEF6D2)
                              : transferStatus == 'ON_DELIVERY'
                                  ? const Color(0xFFEAECF5)
                                  : transferStatus == 'ASSIGNED'
                                      ? const Color(0xFFFEF6D2)
                                      : transferStatus == 'RECEIVED'
                                          ? const Color(0xFFCEFCD8)
                                          : (transferStatus == 'DELIVERED' && !isGoodReceipts)
                                              ? const Color(0xFFCEFCD8)
                                              : (transferStatus == 'DELIVERED' && isGoodReceipts)
                                                  ? const Color(0xFFD0F5FD)
                                                  : const Color(0xFFFDDFD1),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
        transferStatus == null
            ? 'N/A'
            : transferStatus == 'DRAFT'
                ? 'Draft'
                : transferStatus == 'CONFIRMED'
                    ? 'Terkonfirmasi'
                    : transferStatus == 'BOOKED'
                        ? 'Dipesan'
                        : transferStatus == 'ASSIGNED'
                            ? 'Siap Kirim'
                            : transferStatus == 'READY_TO_DELIVER'
                                ? 'Siap Kirim'
                                : transferStatus == 'ON_DELIVERY'
                                    ? 'Perjalanan'
                                    : transferStatus == 'RECEIVED'
                                        ? 'Diterima'
                                        : transferStatus == 'DELIVERED'
                                            ? 'Terkirim'
                                            : 'Dibatalkan',
        style: transferStatus == null
            ? AppTextStyle.blackTextStyle
            : transferStatus == 'DRAFT'
                ? const TextStyle(color: Color(0xFFF47B20))
                : transferStatus == 'CONFIRMED'
                    ? const TextStyle(color: Color(0xFF198BDB))
                    : transferStatus == 'BOOKED'
                        ? const TextStyle(color: Color(0xFFAB6116))
                        : transferStatus == 'ASSIGNED'
                            ? const TextStyle(color: Color(0xFFF4B420))
                            : transferStatus == 'DELIVERED' && !isGoodReceipts
                                ? const TextStyle(color: Color(0xFF14CB82))
                                : transferStatus == 'DELIVERED' && isGoodReceipts
                                    ? const TextStyle(color: Color(0xFF198BDB))
                                    : transferStatus == 'READY_TO_DELIVER'
                                        ? const TextStyle(color: Color(0xFFF4B420))
                                        : transferStatus == 'ON_DELIVERY'
                                            ? const TextStyle(color: Color(0xFF6938EF))
                                            : transferStatus == 'RECEIVED'
                                                ? const TextStyle(color: Color(0xFF14CB82))
                                                : const TextStyle(color: Color(0xFFDD1E25)),
      )),
    );
  }
}
