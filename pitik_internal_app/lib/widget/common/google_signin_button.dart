// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

class GoogleSignInButton extends StatelessWidget {
    Function() onTap;
    GoogleSignInButton({super.key, required this.onTap});

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(width: 2, color: AppColors.grey)
                    ),
                ),
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                        children: [
                            SvgPicture.asset('images/google_icon.svg', width: 64, height: 64),
                            Text(
                                "Login with Google",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 14,
                                    fontWeight: AppTextStyle.medium),
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}
