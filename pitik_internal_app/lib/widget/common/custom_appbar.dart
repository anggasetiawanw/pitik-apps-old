import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';

class CustomAppbar extends StatelessWidget {
    final String title;
    final Function() onBack;
    const CustomAppbar({
        super.key, required this.title, required this.onBack,
    });

    @override
    Widget build(BuildContext context) {
        return AppBar(
            elevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            backgroundColor: AppColors.primaryOrange,
            centerTitle: true,
            title: Text(
                title,
                style: AppTextStyle.whiteTextStyle
                    .copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
            ),
        );
    }
}