import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData kDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColor.lightBlack,
  accentColorBrightness: Brightness.dark,
  primaryColor: AppColor.accent,
  accentIconTheme: IconThemeData(
    color: AppColor.accent,
  ),
  accentColor: AppColor.accent,
  appBarTheme: AppBarTheme(
    color: Color(0xff333333),
    brightness: Brightness.dark,
    iconTheme: IconThemeData(
      color: AppColor.accent,
    ),
  ),
  iconTheme: IconThemeData(
    color: AppColor.accent,
  ),
  fontFamily: "Poppins",
);

/*final ThemeData kLightThemeData = ThemeData(
  canvasColor: AppColor.background,
  accentColor: AppColor.accent,
  errorColor: AppColor.error,
  cursorColor: AppColor.primaryVariant,
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  iconTheme: IconThemeData(
    color: AppColor.accent,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: AppColor.accent,
    ),
  ),
  fontFamily: "Montserrat",
);*/

final ThemeData kLightThemeData = ThemeData(
  canvasColor: AppColor.background,
  accentColor: AppColor.accent,
  errorColor: AppColor.error,
  scaffoldBackgroundColor: AppColor.lightWhite,
  brightness: Brightness.light,
  iconTheme: IconThemeData(
    color: AppColor.black,
  ),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      brightness: Brightness.light,
      iconTheme: IconThemeData(
        color: AppColor.black,
      ),
      textTheme: TextTheme(
          bodyText1: TextStyle(
        color: const Color(0xff000000),
      ))),
  backgroundColor: Colors.white,
  primaryColorDark: Color(0xff202020),
  primaryColor: Color(0xff707070),
  cursorColor: Color(0xff202020),
  fontFamily: 'Metropolis',
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xff919191),
        ),
        headline2: TextStyle(
          fontSize: 13,
          color: const Color(0xff000000),
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(
          fontSize: 13,
          color: const Color(0x96000000),
          fontWeight: FontWeight.w500,
        ),
        headline4: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xff000000),
        ),
        headline5: TextStyle(
          fontSize: 17,
          color: const Color(0xff000000),
          fontWeight: FontWeight.w700,
        ),
        headline6: TextStyle(
          fontSize: 22,
          color: const Color(0xff000000),
          fontWeight: FontWeight.w700,
        ),
        bodyText1: TextStyle(
          fontSize: 17,
          color: const Color(0xff000000),
          fontWeight: FontWeight.w500,
        ),
      ),
);

/* ThemeData(
backgroundColor: Colors.white,
primaryColorDark: Color(0xff202020),
primaryColor: Color(0xff707070),
accentColor: Color(0xff04827F),
cursorColor: Color(0xff202020),
fontFamily: 'Hero',
textTheme: ThemeData.light().textTheme.copyWith(
headline1: TextStyle(
fontSize: 11,
fontWeight: FontWeight.w500,
color: const Color(0xff919191),
),
headline2: TextStyle(
fontSize: 13,
color: const Color(0xff000000),
fontWeight: FontWeight.bold,
),
headline3: TextStyle(
fontSize: 13,
color: const Color(0x96000000),
fontWeight: FontWeight.w500,
),
headline4: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w500,
color: const Color(0xff000000),
),
headline5: TextStyle(
fontSize: 17,
color: const Color(0xff000000),
fontWeight: FontWeight.w700,
),
headline6: TextStyle(
fontSize: 22,
color: const Color(0xff000000),
fontWeight: FontWeight.w700,
),
bodyText1: TextStyle(
fontSize: 17,
color: const Color(0xff000000),
fontWeight: FontWeight.w500,
),
bodyText2: TextStyle(
fontSize: 22,
color: const Color(0xffffffff),
fontWeight: FontWeight.w700,
),
),
),*/
