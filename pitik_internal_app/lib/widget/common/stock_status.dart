import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import '../../utils/enum/stock_status.dart';

class StockStatus extends StatelessWidget {
  const StockStatus({required this.stockStatus, required this.isApprove, super.key});

  final String? stockStatus;
  final bool? isApprove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: stockStatus == EnumStock.draft
              ? const Color(0xFFFEEFD2)
              : stockStatus == EnumStock.confirmed
                  ? AppColors.primaryLight2
                  : stockStatus == EnumStock.finished
                      ? const Color(0xFFCEFCD8)
                      : stockStatus == EnumStock.rejected
                          ? const Color(0xFFFDDFD1)
                          : const Color(0xFFFDDFD1),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
        stockStatus == EnumStock.draft
            ? 'Draft'
            : stockStatus == EnumStock.confirmed
                ? 'Perlu Persetujuan'
                : stockStatus == EnumStock.finished
                    ? isApprove!
                        ? 'Disetujui'
                        : 'Selesai'
                    : stockStatus == EnumStock.rejected
                        ? 'Ditolak'
                        : 'Dibatalkan',
        style: stockStatus == EnumStock.draft
            ? const TextStyle(color: Color(0xFFF47B20))
            : stockStatus == EnumStock.confirmed
                ? const TextStyle(color: Color(0xFFF47B20))
                : stockStatus == EnumStock.finished
                    ? const TextStyle(color: Color(0xFF14CB82))
                    : stockStatus == EnumStock.rejected
                        ? const TextStyle(color: Color(0xFFDD1E25))
                        : const TextStyle(color: Color(0xFFDD1E25)),
      )),
    );
  }
}
