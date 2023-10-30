import 'package:flutter/material.dart';
import 'package:global_variable/global_variable.dart';

class CustomAppbar extends StatelessWidget {
    final String title;
    final bool isBack;
    final Function() onBack;
    final bool isFlat;
    const CustomAppbar({
        super.key, required this.title, required this.onBack, this.isFlat = false, this.isBack = true
    });

    @override
    Widget build(BuildContext context) {
        final circularRadius = isFlat ? 0.0 : 8.0;
        return AppBar(
            automaticallyImplyLeading: isBack,
            elevation: 0,
            leading: isBack? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack) : null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(circularRadius), bottomRight: Radius.circular(circularRadius)),
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