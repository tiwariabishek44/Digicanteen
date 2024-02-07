import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merocanteen/app/config/colors.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class AppStyles {
  static TextStyle get titleStyle {
    return GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.black));
  }

  static TextStyle get subtitleStyle {
    return GoogleFonts.poppins(
        textStyle: const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500,
    ));
  }
}

class AppPadding {
  static EdgeInsetsGeometry get screenHorizontalPadding {
    return EdgeInsets.symmetric(horizontal: 4.w);
  }
}
