import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyle {
  static TextStyle primaryTextStyle = const TextStyle(
    color: AppColors.primaryOrange,
    fontFamily: 'Montserrat_Medium',
  );
  static TextStyle lightTextStyle = const TextStyle(
    color: AppColors.primaryLight,
    fontFamily: 'Montserrat_Medium',
  );

  static TextStyle blackTextStyle = const TextStyle(
    color: AppColors.black,
    fontFamily: 'Montserrat_Medium',
  );

  static TextStyle redTextStyle = const TextStyle(
    color: AppColors.red,
    fontFamily: 'Montserrat_Medium',
  );

  static TextStyle whiteTextStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'Montserrat_Medium',
  );

  static TextStyle greyTextStyle = const TextStyle(
    color: AppColors.greyText,
    fontFamily: 'Montserrat_Medium',
  );
  static TextStyle grayTextStyle = const TextStyle(
    color: AppColors.grey,
    fontFamily: 'Montserrat_Medium',
  );

  static TextStyle subTextStyle = const TextStyle(
    color: AppColors.subGreyText,
    fontFamily: 'Montserrat_Medium',
  );

  static TextStyle greenTextStyle = const TextStyle(
    color: AppColors.green,
    fontFamily: 'Montserrat_Medium',
  );

  //WEIGHT 300
  static FontWeight light = FontWeight.w300;
  //WEIGHT 400
  static FontWeight regular = FontWeight.w400;
  //WEIGHT 500
  static FontWeight medium = FontWeight.w500;
  //WEIGHT 600
  static FontWeight semiBold = FontWeight.w600;
  //WEIGHT 700
  static FontWeight bold = FontWeight.w700;
}
