/// @author [Angga Setiawan Wahyudin]
/// @email [angga.setiawan@pitik.id]
/// @create date 2023-02-17 17:43:25
/// @modify date 2023-02-17 17:43:25
/// @desc [description]
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

/*
  @author DICKY <dicky.maulana@pitik.id>
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

class AppleSignInButton extends StatelessWidget {
    Function() onUserResult;
    AppleSignInButton({super.key, required this.onUserResult});

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: onUserResult,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: Colors.white54,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                        children: [
                            SvgPicture.asset('images/apple_logo.svg', width: 64, height: 64),
                            Text(
                                "Login with Apple ID",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: AppTextStyle.medium),
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}
