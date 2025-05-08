import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppCss {
  static TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );
  static TextStyle largeBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static TextStyle largeRegular = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static TextStyle mediumBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static TextStyle mediumRegular = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static TextStyle smallBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static TextStyle smallRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
  static TextStyle minimumBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static TextStyle minimumRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static BorderRadius radius4 = BorderRadius.circular(4);
  static BorderRadius radius8 = BorderRadius.circular(8);
  static BorderRadius radius12 = BorderRadius.circular(12);
  static BorderRadius radius16 = BorderRadius.circular(16);
  static BorderRadius radius20 = BorderRadius.circular(20);
  static BorderRadius radius24 = BorderRadius.circular(24);
}

extension TextStyleExt on TextStyle {
  TextStyle setColor(Color color) => copyWith(color: color);
  TextStyle setSize(double size) => copyWith(fontSize: size);
  TextStyle setHeight(double height) => copyWith(height: height);
}
