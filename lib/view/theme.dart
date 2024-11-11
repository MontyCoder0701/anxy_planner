import 'package:flutter/material.dart';

class CustomColor {
  CustomColor._();

  static const primary = Color(0xFF9072A6);
  static const warning = Color(0xffd17c76);
}

class CustomThemeData {
  static final ThemeData lightTheme =
      _themeDataFromColorScheme(_lightColorScheme);

  static final ThemeData darkTheme =
      _themeDataFromColorScheme(_darkColorScheme);

  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: CustomColor.primary,
    primary: CustomColor.primary,
    error: CustomColor.warning,
    brightness: Brightness.light,
  );

  static final _darkColorScheme = ColorScheme.fromSeed(
    seedColor: CustomColor.primary,
    brightness: Brightness.dark,
  );

  static ThemeData _themeDataFromColorScheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      dialogTheme: DialogTheme(
        titleTextStyle: CustomTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomTypography {
  static const _baseStyle = TextStyle(fontWeight: FontWeight.w500);

  static final titleLarge = _baseStyle.copyWith(fontSize: 20.0);
  static final titleMedium = _baseStyle.copyWith(fontSize: 18.0);
  static final titleSmall = _baseStyle.copyWith(fontSize: 16.0);

  static final bodyLarge = _baseStyle.copyWith(fontSize: 18.0);
  static final bodyMedium = _baseStyle.copyWith(fontSize: 16.0);
  static final bodySmall = _baseStyle.copyWith(fontSize: 14.0);

  static final subtitleLarge = _baseStyle.copyWith(fontSize: 16.0);
  static final subtitleMedium = _baseStyle.copyWith(fontSize: 14.0);
  static final subtitleSmall = _baseStyle.copyWith(fontSize: 12.0);
}
