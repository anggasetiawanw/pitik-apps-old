import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';

class InfoDetailSku extends StatelessWidget {
  final String title;
  final String name;
  const InfoDetailSku({
    required this.title,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.subTextStyle.copyWith(fontSize: 12),
          ),
          Text(
            name,
            style: AppTextStyle.blackTextStyle.copyWith(fontSize: 12, fontWeight: AppTextStyle.medium),
          )
        ],
      ),
    );
  }
}
