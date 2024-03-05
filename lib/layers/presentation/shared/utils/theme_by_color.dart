import 'package:flutter/material.dart';
import 'package:pokedex_app/layers/presentation/shared/theme/styles.dart';

ThemeData getThemeByColor(Color primaryColor) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor.withOpacity(0.8),
      titleTextStyle: appBarTextStyle,
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: MaterialStateProperty.resolveWith((states) => black),
      trackColor: MaterialStateProperty.resolveWith((states) => white),
      thumbColor: MaterialStateProperty.resolveWith((states) => primaryColor.withOpacity(0.6)),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor.withOpacity(0.6),
      indicatorColor: primaryColor.withOpacity(0.6),
    ),
  );
}