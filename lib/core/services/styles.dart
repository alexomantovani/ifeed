import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  const Styles._();

  // Colors
  static const kPrimaryBlack = Color(0xFF000000);
  static const kPrimaryBlue = Color(0xFF1D9EF3);
  static const kPrimaryBlueLight = Color(0xFF1D9BF0);
  static const kPrimaryGrey = Color(0xFF5F6367);
  static const kPrimaryGreyLight = Color(0xFFC4C6C7);
  static const kPrimaryWhite = Color(0xFFFFFFFF);

  // TextStyles

  static TextStyle titleLarge = GoogleFonts.notoSans(
    color: kPrimaryWhite,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleMedium = GoogleFonts.notoSans(
    color: kPrimaryWhite,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleSmall = GoogleFonts.notoSans(
    color: kPrimaryWhite,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodyLarge = GoogleFonts.notoSans(
    color: kPrimaryGrey,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyMedium = GoogleFonts.notoSans(
    color: kPrimaryGreyLight,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodySmall = GoogleFonts.notoSans(
    color: kPrimaryGreyLight,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
