import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_palette_helper.dart';

class ThemeHelper {
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

  static ThemeData material({String? fontName}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: SeedColorScheme.fromSeeds(
        brightness: Brightness.dark,
        primaryKey: Color.fromRGBO(189, 195, 255, 1),
        // primaryKey: Colors.orange,
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

  static ThemeData tautulliOld({String? fontName}) {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        color: TautulliColorPalette.midnight,
        iconTheme: const IconThemeData(
          color: TautulliColorPalette.notWhite,
        ),
        titleTextStyle: GoogleFonts.openSans(
          textStyle: const TextStyle(
            fontSize: 20,
            color: TautulliColorPalette.notWhite,
          ),
        ),
      ),
      bannerTheme: const MaterialBannerThemeData(
        elevation: 1,
      ),
      cardColor: TautulliColorPalette.gunmetal, //Flutter's 'About Licenses' page uses the cardColor
      cardTheme: const CardTheme(
        margin: EdgeInsets.all(0),
        elevation: 0,
        color: TautulliColorPalette.gunmetal,
        clipBehavior: Clip.antiAlias,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
            return null;
          },
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: TautulliColorPalette.createSwatch(),
        backgroundColor: TautulliColorPalette.midnight,
        brightness: Brightness.dark,
        errorColor: Colors.red[900],
      ).copyWith(
        secondary: PlexColorPalette.gamboge,
        tertiary: TautulliColorPalette.notWhite,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: TautulliColorPalette.gunmetal,
      ),
      dividerTheme: const DividerThemeData(
        color: PlexColorPalette.gamboge,
        thickness: 1,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: TautulliColorPalette.gunmetal,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PlexColorPalette.gamboge,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: TautulliColorPalette.notWhite,
        backgroundColor: PlexColorPalette.gamboge,
        extendedTextStyle: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(
        color: TautulliColorPalette.notWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: TautulliColorPalette.smoke,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[900]!,
          ),
        ),
        // floatingLabelStyle: TextStyle(
        //   color: PlexColorPalette.gamboge,
        // ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: PlexColorPalette.gamboge,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[900]!,
          ),
        ),
        iconColor: TautulliColorPalette.smoke,
        isDense: true,
        labelStyle: const TextStyle(
          color: TautulliColorPalette.smoke,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: TautulliColorPalette.notWhite,
        tileColor: TautulliColorPalette.gunmetal,
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        elevation: 0,
        indicatorColor: HSLColor.fromColor(
          TautulliColorPalette.gunmetal,
        ).withLightness(0.25).toColor(),
        labelTextStyle: MaterialStateProperty.resolveWith(
          (states) => const TextStyle(
            color: TautulliColorPalette.notWhite,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PlexColorPalette.gamboge,
          side: const BorderSide(
            color: PlexColorPalette.gamboge,
          ),
        ),
      ),
      primarySwatch: TautulliColorPalette.createSwatch(),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: TautulliColorPalette.notWhite,
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
            return null;
          },
        ),
      ),
      scaffoldBackgroundColor: TautulliColorPalette.midnight,
      snackBarTheme: const SnackBarThemeData(
        actionTextColor: TautulliColorPalette.notWhite,
        behavior: SnackBarBehavior.floating,
        backgroundColor: PlexColorPalette.shark,
        contentTextStyle: TextStyle(
          color: TautulliColorPalette.notWhite,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
            return null;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge.withAlpha(175);
            }
            return null;
          },
        ),
      ),
      tabBarTheme: const TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: PlexColorPalette.gamboge,
            width: 2,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: TautulliColorPalette.notWhite,
        dividerColor: Colors.transparent,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TautulliColorPalette.notWhite,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: PlexColorPalette.gamboge,
        selectionHandleColor: PlexColorPalette.gamboge,
        selectionColor: PlexColorPalette.gamboge,
      ),
      textTheme: GoogleFonts.getTextTheme(
        fontName ?? 'Open Sans',
        ThemeData.dark().textTheme.copyWith(
              bodyLarge: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              bodyMedium: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              labelLarge: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              bodySmall: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              displayLarge: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              displayMedium: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              displaySmall: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headlineMedium: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headlineSmall: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              titleLarge: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              labelSmall: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              titleMedium: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              titleSmall: const TextStyle(
                color: TautulliColorPalette.smoke,
              ),
            ),
      ),
      unselectedWidgetColor: TautulliColorPalette.notWhite,
    );
  }
}
