import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../types/theme_type.dart';
import 'color_palette_helper.dart';

class ThemeHelper {
  static ThemeType mapStringToTheme(String value) {
    switch (value) {
      case ('dynamic'):
        return ThemeType.dynamic;
      case ('tautulli'):
      default:
        return ThemeType.tautulli;
    }
  }

  static ThemeData tautulli({String? fontName}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: SeedColorScheme.fromSeeds(
        brightness: Brightness.dark,
        primaryKey: PlexColorPalette.gamboge,
        secondaryKey: PlexColorPalette.curiousBlue,
        tertiaryKey: PlexColorPalette.atlantis,
        primary: PlexColorPalette.gamboge,
        onPrimary: TautulliColorPalette.notWhite,
        primaryContainer: const Color(0xffd5950c),
        onPrimaryContainer: TautulliColorPalette.notWhite,
        secondary: PlexColorPalette.curiousBlue,
        onSecondary: TautulliColorPalette.notWhite,
        secondaryContainer: PlexColorPalette.curiousBlue,
        onSecondaryContainer: TautulliColorPalette.notWhite,
        tertiary: PlexColorPalette.atlantis,
        onTertiary: TautulliColorPalette.notWhite,
        tertiaryContainer: PlexColorPalette.atlantis,
        onTertiaryContainer: TautulliColorPalette.notWhite,
        error: Colors.red[900],
        onError: TautulliColorPalette.notWhite,
        errorContainer: Colors.red[900],
        onErrorContainer: TautulliColorPalette.notWhite,
        background: TautulliColorPalette.midnight,
        onBackground: TautulliColorPalette.notWhite,
        surface: TautulliColorPalette.midnight,
        onSurface: TautulliColorPalette.notWhite,
        onSurfaceVariant: TautulliColorPalette.smoke,
        surfaceTint: TautulliColorPalette.notWhite,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      bannerTheme: const MaterialBannerThemeData(
        elevation: 1,
      ),
      cardTheme: const CardTheme().copyWith(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: const EdgeInsets.all(0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationDrawerTheme: const NavigationDrawerThemeData(
        elevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: const TabBarTheme(
        dividerColor: Colors.transparent,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: GoogleFonts.getTextTheme(
        fontName ?? 'Open Sans',
        ThemeData.dark().textTheme,
      ),
    );
  }

  static ThemeData dynamic({
    required Color color,
    String? fontName,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: SeedColorScheme.fromSeeds(
        brightness: Brightness.dark,
        primaryKey: color,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      bannerTheme: const MaterialBannerThemeData(
        elevation: 1,
      ),
      cardTheme: const CardTheme().copyWith(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: const EdgeInsets.all(0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationDrawerTheme: const NavigationDrawerThemeData(
        elevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: const TabBarTheme(
        dividerColor: Colors.transparent,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: GoogleFonts.getTextTheme(
        fontName ?? 'Open Sans',
        ThemeData.dark().textTheme,
      ),
    );
  }

  static Color darkenedColor(Color color) {
    return HSLColor.fromColor(color).withLightness(0.08).toColor();
  }
}
