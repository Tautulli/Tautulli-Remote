import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../types/theme_enhancement_type.dart';
import '../types/theme_type.dart';
import 'color_palette_helper.dart';

class ThemeHelper {
  static ThemeData materialThemeSelector({
    required ThemeType theme,
    required Color color,
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    switch (theme) {
      case (ThemeType.tautulli):
        return tautulliMaterial(enhancement: enhancement, fontName: fontName);
      case (ThemeType.dynamic):
        return dynamicMaterial(color: color, enhancement: enhancement, fontName: fontName);
    }
  }

  static CupertinoThemeData cupertinoThemeSelector({
    required ThemeType theme,
    required Color color,
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    switch (theme) {
      case (ThemeType.tautulli):
        return tautulliCupertino(enhancement: enhancement, fontName: fontName);
      case (ThemeType.dynamic):
        return dynamicCupertino(color: color, enhancement: enhancement, fontName: fontName);
    }
  }

  //* Material Themes
  static ThemeData tautulliMaterial({
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    final surfaceColor = enhancement == ThemeEnhancementType.ultraContrastDark
        ? PlexColorPalette.black
        : TautulliColorPalette.midnight;

    return ThemeData(
      useMaterial3: true,
      colorScheme: SeedColorScheme.fromSeeds(
        brightness: Brightness.dark,
        primaryKey: PlexColorPalette.primaryGold,
        secondaryKey: PlexColorPalette.blue,
        tertiaryKey: PlexColorPalette.orange,
        primary: PlexColorPalette.primaryGold,
        onPrimary: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.black : TautulliColorPalette.notWhite,
        primaryContainer: const Color(0xffd5950c),
        onPrimaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.black
            : TautulliColorPalette.notWhite,
        secondary: PlexColorPalette.blue,
        onSecondary: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.black
            : TautulliColorPalette.notWhite,
        secondaryContainer: PlexColorPalette.blue,
        onSecondaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.black
            : TautulliColorPalette.notWhite,
        tertiary: PlexColorPalette.orange,
        onTertiary: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.black
            : TautulliColorPalette.notWhite,
        tertiaryContainer: PlexColorPalette.orange,
        onTertiaryContainer: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.black
            : TautulliColorPalette.notWhite,
        error: Colors.red,
        onError: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        errorContainer: Colors.red,
        onErrorContainer: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.black
            : TautulliColorPalette.notWhite,
        surface: surfaceColor,
        onSurface: enhancement == ThemeEnhancementType.ultraContrastDark ? Colors.white : TautulliColorPalette.notWhite,
        surfaceContainerHighest: const Color(0xff404040),
        onSurfaceVariant: enhancement == ThemeEnhancementType.ultraContrastDark
            ? Colors.white
            : TautulliColorPalette.smoke,
        surfaceTint: TautulliColorPalette.notWhite,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      bannerTheme: const MaterialBannerThemeData(
        elevation: 1,
      ),
      cardTheme: const CardThemeData().copyWith(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: const EdgeInsets.all(0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TautulliColorPalette.gunmetal,
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
        backgroundColor: TautulliColorPalette.midnight,
        elevation: 0,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: TautulliColorPalette.gunmetal,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          // secondaryContainer in this theme is PlexColorPalette.blue (unrelated to gold),
          // so override with a dark tonal amber that matches M3's container intent.
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => states.contains(WidgetState.selected) ? const Color(0xff4a3800) : null,
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => states.contains(WidgetState.selected) ? TautulliColorPalette.notWhite : null,
          ),
          iconColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => states.contains(WidgetState.selected) ? TautulliColorPalette.notWhite : null,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      tabBarTheme: const TabBarThemeData(
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

  static ThemeData dynamicMaterial({
    required Color color,
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    final FlexTones flexTones = (enhancement == ThemeEnhancementType.ultraContrastDark)
        ? FlexTones.ultraContrast(Brightness.dark)
        : FlexTones.chroma(Brightness.dark);

    final colorScheme = SeedColorScheme.fromSeeds(
      brightness: Brightness.dark,
      tones: flexTones,
      primaryKey: color,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
      ),
      bannerTheme: const MaterialBannerThemeData(
        elevation: 1,
      ),
      cardTheme: const CardThemeData().copyWith(
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
      tabBarTheme: const TabBarThemeData(
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

  //* Cupertino Themes
  static CupertinoThemeData tautulliCupertino({
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    return CupertinoThemeData(
      applyThemeToAll: true,
      brightness: Brightness.dark,
      primaryColor: PlexColorPalette.primaryGold,
      primaryContrastingColor: CupertinoColors.black,
      scaffoldBackgroundColor: enhancement == ThemeEnhancementType.ultraContrastDark
          ? PlexColorPalette.black
          : TautulliColorPalette.midnight,
    );
  }

  static CupertinoThemeData dynamicCupertino({
    required Color color,
    required ThemeEnhancementType enhancement,
    String? fontName,
  }) {
    return CupertinoThemeData(
      applyThemeToAll: true,
      brightness: Brightness.dark,
      primaryColor: color,
      primaryContrastingColor: CupertinoColors.black,
      scaffoldBackgroundColor: enhancement == ThemeEnhancementType.ultraContrastDark
          ? PlexColorPalette.black
          : TautulliColorPalette.midnight,
    );
  }

  static const Color cupertinoListTileIconColor = CupertinoColors.white;
  static const Color cupertinoActionSheetActionColor = CupertinoColors.white;
  static const Color cupertinoAlertCardButtonTextColor = CupertinoColors.white;
  static const Color cupertinoAlertCardIconColor = CupertinoColors.white;
  static const Color cupertinoCardIconColor = CupertinoColors.white;
  static const Color cupertinoBottomSheetTextColor = CupertinoColors.white;
  static const Color cupertinoBottomSheetHeadingColor = CupertinoColors.systemGrey2;
  static const Color cupertinoNavigationBarItemColor = CupertinoColors.white;
  static const Color cupertinoStandardTextColor = CupertinoColors.white;
  static const Color cupertinoChartLineColor = CupertinoColors.systemGrey;

  //* Utilities
  static Color darkenedColor(Color color) {
    return HSLColor.fromColor(color).withLightness(0.08).toColor();
  }
}
