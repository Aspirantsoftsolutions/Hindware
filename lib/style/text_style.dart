import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static final TextStyle blackSegoeUISemiBold36 = TextStyle(
      fontFamily: 'SegoeUI',
      fontSize: 36,
      color: AppColor.textBlack,
      fontWeight: FontWeight.w600);
  static final TextStyle blackRubikMedium22 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 22,
      color: AppColor.textBlack,
      fontWeight: FontWeight.w500);
  static final TextStyle blackRubikMedium16 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 16,
      color: AppColor.textBlack,
      fontWeight: FontWeight.w500);
  static final TextStyle blackRubik12 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 12,
      color: AppColor.textBlack,
      fontWeight: FontWeight.w400);
  static final TextStyle blackRubik14 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 14,
      color: AppColor.textBlack,
      fontWeight: FontWeight.w400);
  static final TextStyle blackRubik15 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 15,
      color: AppColor.textBlack,
      fontWeight: FontWeight.w400);
  static final TextStyle redRubik16 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 16,
      color: AppColor.red.withOpacity(0.8),
      fontWeight: FontWeight.w400);
  static final TextStyle redRubik14 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 14,
      color: AppColor.red.withOpacity(0.8),
      fontWeight: FontWeight.w400);
  static final TextStyle redRubik12 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 12,
      color: AppColor.red.withOpacity(0.8),
      fontWeight: FontWeight.w400);
  static final TextStyle whiteRubik27 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 27,
      color: AppColor.white,
      fontWeight: FontWeight.w400);
  static final TextStyle whiteRubik18 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 18,
      color: AppColor.white,
      fontWeight: FontWeight.w400);
  static final TextStyle greyRubik13 = TextStyle(
      fontFamily: 'Rubik',
      fontSize: 13,
      color: AppColor.textGray,
      fontWeight: FontWeight.w400);

  static final TextStyle textHintStyle = TextStyle(
    // color: AppColor.onBackground

    fontFamily: 'Rubik',
    fontSize: 14,
    color: const Color(0xff000B22).withOpacity(0.5),
    fontWeight: FontWeight.w400,
  );
  static final TextStyle textFieldStyle = TextStyle(
    // color: AppColor.onBackground

    fontFamily: 'Rubik',
    fontSize: 14,
    color: AppColor.textBlack,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle whiteRubik14 = TextStyle(
    // color: AppColor.onBackground

    fontFamily: 'Rubik',
    fontSize: 14,
    color: AppColor.white,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle whiteRubik16 = TextStyle(
    // color: AppColor.onBackground

    fontFamily: 'Rubik',
    fontSize: 16,
    color: AppColor.white,
    fontWeight: FontWeight.w400,
  );
}
