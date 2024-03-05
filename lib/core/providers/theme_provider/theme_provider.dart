import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData themeData;
  ThemeProvider({required this.themeData});

  ThemeData getTheme() => themeData;

  setTheme(ThemeData theme) => {themeData = theme, notifyListeners()};
}
