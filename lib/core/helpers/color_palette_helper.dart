import 'package:color/color.dart' hide Color;
import 'package:flutter/material.dart';

/// Provides access to official Plex colors.
///
/// Creates a custom [MaterialColor] swatch with [createSwatch()].
class PlexColorPalette {
  /// Returns a [MaterialColor] swatch based on Plex's `Shark` color
  ///
  /// Can take in a [r], [g], and [b] value to create a custom [MaterialColor] swatch.
  static createSwatch({
    int r = 40,
    int g = 42,
    int b = 45,
  }) {
    Map<int, Color> colorMap = {
      50: Color.fromRGBO(r, g, b, 0.1),
      100: Color.fromRGBO(r, g, b, 0.2),
      200: Color.fromRGBO(r, g, b, 0.3),
      300: Color.fromRGBO(r, g, b, 0.4),
      400: Color.fromRGBO(r, g, b, 0.5),
      500: Color.fromRGBO(r, g, b, 0.6),
      600: Color.fromRGBO(r, g, b, 0.7),
      700: Color.fromRGBO(r, g, b, 0.8),
      800: Color.fromRGBO(r, g, b, 0.9),
      900: Color.fromRGBO(r, g, b, 1.0),
    };

    // Uses Color package to convert RGB to HEX, append '0xff' with string interpolation, and parse as int for MaterialColor
    int hexColor = int.parse(
      '0xff${RgbColor(r, g, b).toHexColor().toString()}',
    );

    MaterialColor customSwatch = MaterialColor(hexColor, colorMap);

    return customSwatch;
  }

  // Primary Color Palette
  static const Color gamboge = Color.fromRGBO(229, 160, 13, 1.0);
  static const Color shark = Color.fromRGBO(40, 42, 45, 1.0);
  static const Color white = Colors.white;

  // Shades of gray
  // From dark to light
  static const Color river_bed = Color.fromRGBO(63, 66, 69, 1.0);
  static const Color shuttle_gray = Color.fromRGBO(87, 91, 97, 1.0);
  static const Color raven = Color.fromRGBO(134, 140, 150, 1.0);
  static const Color gray_chateau = Color.fromRGBO(179, 186, 193, 1.0);
  static const Color mercury = Color.fromRGBO(224, 227, 230, 1.0);
  static const Color athens_gray = Color.fromRGBO(242, 243, 244, 1.0);
  static const Color alabaster = Color.fromRGBO(249, 249, 249, 1.0);

  //Secondary Colors Palette
  static const Color cinnabar = Color.fromRGBO(240, 100, 100, 1.0);
  static const Color atlantis = Color.fromRGBO(150, 200, 60, 1.0);
  static const Color curious_blue = Color.fromRGBO(25, 160, 215, 1.0);
}

/// Provides access to colors used by Tautulli.
class TautulliColorPalette {
  static const Color midnight = Color.fromRGBO(31, 31, 31, 1.0);
  static const Color gunmetal = Color.fromRGBO(40, 40, 40, 1.0);
  static const Color smoke = Color.fromRGBO(170, 170, 170, 1.0);
  static const Color not_white = Color.fromRGBO(238, 238, 238, 1.0);
  static const Color amber = Color.fromRGBO(249, 190, 3, 1.0);

  /// Returns a given [Color] for the provided platform.
  /// 
  /// Unknown platforms default to Plex's `Gamboge` orange.
  Color mapPlatformToColor(String platform) {
    switch (platform) {
      case 'android':
        return Color.fromRGBO(164, 202, 57, 1.0);

      case 'atv':
      case 'ios':
      case 'macos':
        return Color.fromRGBO(133, 132, 135, 1.0);

      case 'chrome':
        return Color.fromRGBO(237, 94, 80, 1.0);
      case 'chromecast':
        return Color.fromRGBO(16, 164, 232, 1.0);
      case 'dlna':
        return Color.fromRGBO(12, 177, 75, 1.0);
      case 'firefox':
        return Color.fromRGBO(230, 102, 23, 1.0);
      case 'ie':
        return Color.fromRGBO(0, 89, 158, 1.0);
      case 'kodi':
        return Color.fromRGBO(94, 175, 225, 1.0);
      case 'lg':
        return Color.fromRGBO(165, 0, 52, 1.0);
      case 'linux':
        return Color.fromRGBO(23, 147, 208, 1.0);
      case 'msedge':
        return Color.fromRGBO(0, 120, 215, 1.0);
      case 'opera':
        return Color.fromRGBO(255, 27, 45, 1.0);
      case 'playstation':
        return Color.fromRGBO(3, 77, 162, 1.0);
      case 'roku':
        return Color.fromRGBO(109, 60, 151, 1.0);
      case 'safari':
        return Color.fromRGBO(0, 169, 236, 1.0);
      case 'samsung':
        return Color.fromRGBO(3, 78, 162, 1.0);
      case 'synclounge':
        return Color.fromRGBO(21, 25, 36, 1.0);
      case 'tivo':
        return Color.fromRGBO(0, 167, 255, 1.0);
      case 'windows':
        return Color.fromRGBO(47, 192, 245, 1.0);
      case 'wp':
        return Color.fromRGBO(104, 33, 122, 1.0);
      case 'xbox':
        return Color.fromRGBO(16, 124, 16, 1.0);
      default:
        return PlexColorPalette.gamboge;
    }
  }
}
