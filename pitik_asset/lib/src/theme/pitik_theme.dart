import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pitik_asset/src/style/styles.dart';

class PitikTheme {
  const PitikTheme._({
    required this.brightness,
    required this.themeData,
  });

  factory PitikTheme.light(
    ThemeData themeData,
  ) =>
      PitikTheme._(
        brightness: Brightness.light,
        themeData: themeData.copyWith(
          scaffoldBackgroundColor: PitikColors.bgPrimary,
          primaryColor: PitikColors.primary,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: PitikColors.primary,
            onPrimary: Colors.white,
            secondary: PitikColors.secondary,
            onSecondary: Colors.white,
            error: PitikColors.warningFailed,
            onError: Colors.white,
            background: PitikColors.bgPrimary,
            onBackground: PitikColors.bgSecondary,
            surface: PitikColors.bgSecondary,
            onSurface: PitikColors.textTertiary,
          ),

          appBarTheme: const AppBarTheme(
            color: PitikColors.primary,
            foregroundColor: PitikColors.bgSecondary,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: PitikColors.primary,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          //   textButtonTheme: TextButtonThemeData(
          //     style: themeData.textButtonTheme.style?.copyWith(
          //       shape: MaterialStatePropertyAll(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8.r),
          //         ),
          //       ),
          //     ),
          //   ),
        ),
      );

  factory PitikTheme.dark(
    ThemeData themeData,
  ) =>
      PitikTheme._(
        brightness: Brightness.dark,
        themeData: themeData.copyWith(
          scaffoldBackgroundColor: PitikColors.bgPrimary,
          primaryColor: PitikColors.primary,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: PitikColors.primary,
            onPrimary: Colors.white,
            secondary: PitikColors.secondary,
            onSecondary: Colors.white,
            error: PitikColors.warningFailed,
            onError: Colors.white,
            background: PitikColors.bgPrimary,
            onBackground: PitikColors.bgSecondary,
            surface: PitikColors.bgSecondary,
            onSurface: PitikColors.textTertiary,
          ),

          appBarTheme: const AppBarTheme(
            color: PitikColors.bgPrimary,
            foregroundColor: PitikColors.bgSecondary,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          //   textButtonTheme: TextButtonThemeData(
          //     style: themeData.textButtonTheme.style?.copyWith(
          //       shape: MaterialStatePropertyAll(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8.r),
          //         ),
          //       ),
          //     ),
          //   ),
        ),
      );
  final Brightness brightness;
  final ThemeData themeData;
}
