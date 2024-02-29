import 'package:flutter/material.dart';

class PitikColors {
  PitikColors._();

  static const MaterialColor primary = MaterialColor(0xFFF47B20, {
    500: Color(0xFFFEEFD2), // 20%
    50: Color(0xFFFDDAA5), // 40%
    100: Color(0xFFFBBF78), // 60%
    200: Color(0xFFF8A556), // 80%
    300: Color(0xFFF47B20), // 100%
  });

  static const MaterialColor secondary = MaterialColor(0xFFDD1E25, {
    500: Color(0xFFFDDFD1), // 20%
    50: Color(0xFFFBB8A4), // 40%
    100: Color(0xFFF48775), // 60%
    200: Color(0xFFEA5A52), // 80%
    300: Color(0xFFDD1E25), // 100%
  });
  static const MaterialColor accentPrimary = MaterialColor(0xFFDD1E25, {
    500: Color(0xFFFEF6D2), // 20%
    50: Color(0xFFFDEBA5), // 40%
    100: Color(0xFFFBDC78), // 60%
    200: Color(0xFFF8CC56), // 80%
    300: Color(0xFFF4B420), // 100%
  });
  static const MaterialColor accentSecondary = MaterialColor(0xFFDD1E25, {
    500: Color(0xFFFAEDCF), // 20%
    50: Color(0xFFF6D8A0), // 40%
    100: Color(0xFFE5B66D), // 60%
    200: Color(0xFFCC9046), // 80%
    300: Color(0xFFAB6116), // 100%
  });

  //Base Color
  static const Color baseColor = Color(0xFF121212);
  static const Color baseColorLight = Color(0xFFFFFFFF);

  //Background Color
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFFAFAFA);
  static const Color bgTertiary = Color(0xFFFFF93D);

  //Text Color
  static const Color textPrimary = Color(0xFF2C2B2B);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textTertiary = Color(0xFF9E9D9D);

  //Color Warning System
  static const Color warningSuccess = Color(0xFF14CB82);
  static const Color warningBgSuccess = Color(0xFFCEFCD8);
  static const Color warningInformation = Color(0xFF198BDB);
  static const Color warningBgInformation = Color(0xFFD0F5FD);
  static const Color warning = Color(0xFFF4B420);
  static const Color warningBg = Color(0xFFFEF6D2);
  static const Color warningFailed = Color(0xFFDD1E25);
  static const Color warningBgFailed = Color(0xFFFDDFD1);

  //Fill Color
  static const Color imagePlaceholder = Color(0xFFFFF2DA);
  static const Color textFieldsPrimary = Color(0xFFFFFFFF);
  static const Color textFieldSecondary = Color(0xFFFFF93D);
  static const Color iconPrimary = Color(0xFFF47B20);
  static const Color iconSecondary = Color(0xFF361402);
  static const Color disable = Color(0xFFCACACA);

  //Primary Color
  static final Color primary100 = primary.shade300;
  static final Color primary80 = primary.shade200;
  static final Color primary60 = primary.shade100;
  static final Color primary40 = primary.shade50;
  static final Color primary20 = primary.shade500;

  //secondary Color
  static final Color secondary100 = secondary.shade300;
  static final Color secondary80 = secondary.shade200;
  static final Color secondary60 = secondary.shade100;
  static final Color secondary40 = secondary.shade50;
  static final Color secondary20 = secondary.shade500;

  //accentPrimary Color
  static final Color accentPrimary100 = accentPrimary.shade300;
  static final Color accentPrimary80 = accentPrimary.shade200;
  static final Color accentPrimary60 = accentPrimary.shade100;
  static final Color accentPrimary40 = accentPrimary.shade50;
  static final Color accentPrimary20 = accentPrimary.shade500;
  
  //accentSecondary Color
  static final Color accentSecondary100 = accentSecondary.shade300;
  static final Color accentSecondary80 = accentSecondary.shade200;
  static final Color accentSecondary60 = accentSecondary.shade100;
  static final Color accentSecondary40 = accentSecondary.shade50;
  static final Color accentSecondary20 = accentSecondary.shade500;
}
