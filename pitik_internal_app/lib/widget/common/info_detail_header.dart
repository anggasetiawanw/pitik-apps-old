import 'package:flutter/material.dart';
import 'package:global_variable/text_style.dart';

class InfoDetailHeader extends StatelessWidget {
    final String title;
    final String name;
    const InfoDetailHeader({
        super.key, required this.title, required this.name,
    });

    @override
    Widget build(BuildContext context) {
        return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Text(
            title,
            style: AppTextStyle.greyTextStyle.copyWith(fontSize: 10),
            ),
            Text(
            name,
            style: AppTextStyle.blackTextStyle
                .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
            )
        ],
        );
    }
}