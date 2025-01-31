import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6a0dad), // Dark purple
      surfaceTint: Color(0xff6a0dad),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd8bfd8), // Thistle
      onPrimaryContainer: Color(0xff4b0082),
      secondary: Color(0xff8a2be2), // Blue violet
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdda0dd), // Plum
      onSecondaryContainer: Color(0xff4b0082),
      tertiary: Color(0xff9370db), // Medium purple
      onTertiary: Color(0xff212121),
      tertiaryContainer: Color(0xffe6e6fa), // Lavender
      onTertiaryContainer: Color(0xff4b0082),
      error: Color(0xffd32f2f),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffcdd2),
      onErrorContainer: Color(0xffb71c1c),
      surface: Color(0xfff3e5f5), // Light purple
      onSurface: Color(0xff4b0082),
      onSurfaceVariant: Color(0xff757575),
      outline: Color(0xffbdbdbd),
      outlineVariant: Color(0xffe0e0e0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff424242),
      inversePrimary: Color(0xffd8bfd8),
      primaryFixed: Color(0xffd8bfd8),
      onPrimaryFixed: Color(0xff4b0082),
      primaryFixedDim: Color(0xff9370db),
      onPrimaryFixedVariant: Color(0xff6a0dad),
      secondaryFixed: Color(0xffdda0dd),
      onSecondaryFixed: Color(0xff4b0082),
      secondaryFixedDim: Color(0xffba55d3),
      onSecondaryFixedVariant: Color(0xff8a2be2),
      tertiaryFixed: Color(0xffe6e6fa),
      onTertiaryFixed: Color(0xff4b0082),
      tertiaryFixedDim: Color(0xffd8bfd8),
      onTertiaryFixedVariant: Color(0xff9370db),
      surfaceDim: Color(0xfff3e5f5),
      surfaceBright: Color(0xfff3e5f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8bbd0),
      surfaceContainer: Color(0xfff3e5f5),
      surfaceContainerHigh: Color(0xffe1bee7),
      surfaceContainerHighest: Color(0xffce93d8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffcdd2), // Medium purple
      surfaceTint: Color(0xff9370db),
      onPrimary: Color(0xffffffff), // White
      primaryContainer: Color(0xff6a0dad), // Dark purple
      onPrimaryContainer: Color(0xffffffff), // White
      secondary: Color(0xffba55d3), // Medium orchid
      onSecondary: Color(0xffffffff), // White
      secondaryContainer: Color(0xff8a2be2), // Blue violet
      onSecondaryContainer: Color(0xffffffff), // White
      tertiary: Color(0xffd8bfd8), // Thistle
      onTertiary: Color(0xffffffff), // White
      tertiaryContainer: Color(0xff9370db), // Medium purple
      onTertiaryContainer: Color(0xffffffff), // White
      error: Color(0xffd32f2f),
      onError: Color(0xffffffff), // White
      errorContainer: Color(0xffffcdd2),
      onErrorContainer: Color(0xffffffff), // White
      surface: Color(0xff3a2a4e), // Dark purple
      onSurface: Color(0xffffffff), // White
      onSurfaceVariant: Color(0xffffffff), // White
      outline: Color(0xff757575),
      outlineVariant: Color(0xff616161),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e0e0),
      inversePrimary: Color(0xff6a0dad),
      primaryFixed: Color(0xff6a0dad),
      onPrimaryFixed: Color(0xffffffff), // White
      primaryFixedDim: Color(0xff9370db),
      onPrimaryFixedVariant: Color(0xff8a2be2),
      secondaryFixed: Color(0xff8a2be2),
      onSecondaryFixed: Color(0xffffffff), // White
      secondaryFixedDim: Color(0xffba55d3),
      onSecondaryFixedVariant: Color(0xffba55d3),
      tertiaryFixed: Color(0xff9370db),
      onTertiaryFixed: Color(0xffffffff), // White
      tertiaryFixedDim: Color(0xffd8bfd8),
      onTertiaryFixedVariant: Color(0xff6a0dad),
      surfaceDim: Color(0xff5a4b81), // Subtle indigo
      surfaceBright: Color(0xff7a5d9b), // Subtle dark purple
      surfaceContainerLowest: Color(0xff4a3a5e), // Subtle dark purple
      surfaceContainerLow: Color(0xff5a4b81), // Subtle indigo
      surfaceContainer: Color(0xff7a5d9b), // Subtle dark purple
      surfaceContainerHigh: Color(0xff8b79b2), // Subtle medium slate blue
      surfaceContainerHighest: Color(0xffa18cc7), // Subtle medium purple
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  // Predefined container colors
  static const Color containerLight = Color(0xffd8bfd8); // Light purple
  static const Color containerDark = Color(0xff8a2be2); // Dark grey

  // Method to get container color based on brightness
  static Color getContainerColor(Brightness brightness) {
    return brightness == Brightness.light ? containerLight : containerDark;
  }
}
