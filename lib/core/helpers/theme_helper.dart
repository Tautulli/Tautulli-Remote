import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../types/theme_enhancement_type.dart';
import '../types/theme_type.dart';
import 'color_palette_helper.dart';

class ThemeHelper {
  static ThemeData themeSelector({
    required ThemeType theme,
    required Color color,
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    switch (theme) {
      case (ThemeType.tautulli):
        return tautulli(enhancement: enhancement, fontName: fontName);
      case (ThemeType.dynamic):
        return dynamic(color: color, enhancement: enhancement, fontName: fontName);
    }
  }

  static ThemeData tautulli({
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: SeedColorScheme.fromSeeds(
        brightness: Brightness.dark,
        primaryKey: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xfff4be48) : PlexColorPalette.gamboge,
        secondaryKey: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff3fb9e9) : PlexColorPalette.curiousBlue,
        tertiaryKey: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xffc1de8c) : PlexColorPalette.atlantis,
        primary: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xfff4be48) : PlexColorPalette.gamboge,
        onPrimary: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff0d0d0d) : TautulliColorPalette.notWhite,
        primaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xffb48113) : const Color(0xffd5950c),
        onPrimaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        secondary: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff3fb9e9) : PlexColorPalette.curiousBlue,
        onSecondary: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff0d0d0d) : TautulliColorPalette.notWhite,
        secondaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff1d87b4) : PlexColorPalette.curiousBlue,
        onSecondaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        tertiary: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xffc1de8c) : PlexColorPalette.atlantis,
        onTertiary: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff0d0d0d) : TautulliColorPalette.notWhite,
        tertiaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff80ab30) : PlexColorPalette.atlantis,
        onTertiaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        error: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xffd82222) : Colors.red[900],
        onError: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        errorContainer: Colors.red[900],
        onErrorContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        background: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff0d0d0d) : TautulliColorPalette.midnight,
        onBackground: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        surface: enhancement == ThemeEnhancementType.ultraContrastDark ? const Color(0xff0d0d0d) : TautulliColorPalette.midnight,
        onSurface: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        surfaceVariant: const Color(0xff404040),
        onSurfaceVariant: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.smoke,
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
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    final FlexTones flexTones =
        (enhancement == ThemeEnhancementType.ultraContrastDark) ? FlexTones.ultraContrast(Brightness.dark) : FlexTones.chroma(Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: SeedColorScheme.fromSeeds(
        brightness: Brightness.dark,
        tones: flexTones,
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
