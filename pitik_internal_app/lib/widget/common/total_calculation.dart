import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';
import 'package:intl/intl.dart';

class TotalCalculation extends StatelessWidget {
  final int sumChick;
  final double sumNeededMin;
  final double sumNeededMax;
  final double sumPriceMin;
  final double sumPriceMax;
  const TotalCalculation({
    required this.sumChick,
    required this.sumNeededMin,
    required this.sumNeededMax,
    required this.sumPriceMin,
    required this.sumPriceMax,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(color: AppColors.outlineColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Pembelian',
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.bold),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Kg',
                  style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                sumNeededMax - sumNeededMin == 0 ? '${sumNeededMin.toStringAsFixed(2)} Kg' : '${sumNeededMin.toStringAsFixed(2)} Kg - ${sumNeededMax.toStringAsFixed(2)} Kg',
                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                overflow: TextOverflow.clip,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Ekor',
                  style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                '$sumChick Ekor',
                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                overflow: TextOverflow.clip,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Rp',
                  style: AppTextStyle.subTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                  sumPriceMax - sumPriceMin == 0
                      ? NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(sumPriceMin)
                      : "${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(sumPriceMin)} - ${NumberFormat.currency(locale: 'id', symbol: "Rp ", decimalDigits: 2).format(sumPriceMax)}",
                  style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14, fontWeight: AppTextStyle.medium),
                  overflow: TextOverflow.clip),
            ],
          )
        ],
      ),
    );
  }
}
