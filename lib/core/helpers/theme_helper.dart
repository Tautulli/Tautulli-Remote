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
        primaryKey: PlexColorPalette.primaryGold,
        secondaryKey: PlexColorPalette.blue,
        tertiaryKey: PlexColorPalette.seaGreen,
        primary: PlexColorPalette.primaryGold,
        onPrimary: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        primaryContainer: const Color(0xffd5950c),
        onPrimaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        secondary: PlexColorPalette.blue,
        onSecondary: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        secondaryContainer: PlexColorPalette.blue,
        onSecondaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        tertiary: PlexColorPalette.seaGreen,
        onTertiary: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        tertiaryContainer: PlexColorPalette.seaGreen,
        onTertiaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        error: Colors.red,
        onError: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        errorContainer: Colors.red,
        onErrorContainer: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        background: enhancement == ThemeEnhancementType.ultraContrastDark ? PlexColorPalette.black : TautulliColorPalette.midnight,
        onBackground: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        surface: enhancement == ThemeEnhancementType.ultraContrastDark ? PlexColorPalette.black : TautulliColorPalette.midnight,
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
