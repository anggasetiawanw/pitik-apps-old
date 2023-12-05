/// @author [Angga Setiawan Wahyudin]
/// @email [anggasetiaw@gmail.com]
/// @create date 2023-11-15 11:44:47
/// @modify date 2023-11-15 11:44:47
/// @desc [description]
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
    final String title;
    final Function() onBack;
    final bool isFlat;
    final List<Widget>? actions;
    const CustomAppbar({
        super.key, required this.title, required this.onBack, this.isFlat = false, this.actions = const []
    });

    @override
    Widget build(BuildContext context) {
        final circularRadius = isFlat ? 0.0 : 8.0;
        return AppBar(
            elevation: 0,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(circularRadius), bottomRight: Radius.circular(circularRadius)),
            ),
            backgroundColor: GlobalVar.primaryOrange,
            centerTitle: true,
            title: Text(
                title,
                style: GlobalVar.whiteTextStyle
                    .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
            ),
            actions: actions,
        );
    }
}