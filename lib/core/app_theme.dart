import 'package:flutter/material.dart';

final pc2= Color(0xffb494cc);
final sc2 =Color(0xfff49cac);
final primaryColor = Color(0xff642d94);
final secondaryColor = Color(0xffffffff);
// final secondaryColor = Color(0xffef5575);

Map<int, Color> color =
{
  50:primaryColor.withOpacity(0.1),
  100:primaryColor.withOpacity(0.2),
  200:primaryColor.withOpacity(0.3),
  300:primaryColor.withOpacity(0.4),
  400:primaryColor.withOpacity(0.5),
  500:primaryColor.withOpacity(0.6),
  600:primaryColor.withOpacity(0.7),
  700:primaryColor.withOpacity(0.8),
  800:primaryColor.withOpacity(0.9),
  900:primaryColor.withOpacity(1.0),
};
int hexOfRGBA(int r,int g,int b,{double opacity=1})
{
  var  value=((((opacity * 0xff ~/ 1) & 0xff) << 24) |
  ((r                    & 0xff) << 16) |
  ((g                    & 0xff) << 8)  |
  ((b                    & 0xff) << 0)) & 0xFFFFFFFF;
  return value;
}

final appTheme = ThemeData(
    //fontFamily: "HELVE",
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
    ),
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: secondaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: primaryColor),
        iconColor: secondaryColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        )));
