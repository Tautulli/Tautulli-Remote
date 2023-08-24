import 'package:flutter/material.dart';

/// Provides access to official Plex colors.
///
/// Creates a custom [MaterialColor] swatch with [createSwatch].
class PlexColorPalette {
  // Primary Palette
  static const Color primaryGold = Color.fromRGBO(235, 175, 0, 1.0);
  static const Color black = Color.fromRGBO(25, 25, 25, 1.0);
  static const Color white = Color.fromRGBO(255, 251, 248, 1.0);

  // Secondary Palette
  static const Color secondaryGold = Color.fromRGBO(247, 198, 0, 1.0);
  static const Color blue = Color.fromRGBO(21, 169, 252, 1.0);
  static const Color cerise = Color.fromRGBO(247, 67, 102, 1.0);
  static const Color seaGreen = Color.fromRGBO(105, 221, 88, 1.0);
  static const Color orange = Color.fromRGBO(193, 79, 24, 1.0);
  static const Color deepPurple = Color.fromRGBO(50, 45, 91, 1.0);
  static const Color maroon = Color.fromRGBO(91, 34, 68, 1.0);
  static const Color forest = Color.fromRGBO(10, 55, 44, 1.0);
}

/// Provides access to colors used by Tautulli.
class TautulliColorPalette {
  static const Color midnight = Color.fromRGBO(31, 31, 31, 1.0);
  static const Color gunmetal = Color.fromRGBO(40, 40, 40, 1.0);
  static const Color smoke = Color.fromRGBO(170, 170, 170, 1.0);
  static const Color notWhite = Color.fromRGBO(238, 238, 238, 1.0);
  static const Color amber = Color.fromRGBO(249, 190, 3, 1.0);

  /// Returns a given [Color] for the provided platform.
  ///
  /// Unknown platforms default to Plex's `Gamboge` orange.
  static Color mapPlatformToColor(String? platform) {
    switch (platform) {
      case 'alexa':
        return const Color.fromRGBO(0, 202, 255, 1.0);
      case 'android':
        return const Color.fromRGBO(61, 220, 132, 1.0);

      case 'atv':
      case 'ios':
      case 'macos':
        return const Color.fromRGBO(162, 170, 173, 1.0);

      case 'chrome':
        return const Color.fromRGBO(219, 68, 55, 1.0);
      case 'chromecast':
        return const Color.fromRGBO(66, 133, 244, 1.0);
      case 'dlna':
        return const Color.fromRGBO(75, 163, 47, 1.0);
      case 'firefox':
        return const Color.fromRGBO(255, 113, 57, 1.0);
      case 'ie':
        return const Color.fromRGBO(24, 188, 239, 1.0);
      case 'kodi':
        return const Color.fromRGBO(48, 170, 218, 1.0);
      case 'lg':
        return const Color.fromRGBO(153, 0, 51, 1.0);
      case 'linux':
        return const Color.fromRGBO(0, 153, 204, 1.0);
      case 'msedge':
        return const Color.fromRGBO(0, 120, 215, 1.0);
      case 'opera':
        return const Color.fromRGBO(250, 30, 78, 1.0);
      case 'playstation':
        return const Color.fromRGBO(0, 48, 135, 1.0);
      case 'roku':
        return const Color.fromRGBO(103, 50, 147, 1.0);
      case 'safari':
        return const Color.fromRGBO(0, 211, 249, 1.0);
      case 'samsung':
        return const Color.fromRGBO(3, 78, 162, 1.0);
      case 'synclounge':
        return const Color.fromRGBO(21, 25, 36, 1.0);
      case 'tivo':
        return const Color.fromRGBO(0, 167, 225, 1.0);
      case 'windows':
        return const Color.fromRGBO(0, 120, 215, 1.0);
      case 'wp':
        return const Color.fromRGBO(104, 33, 122, 1.0);
      case 'xbox':
        return const Color.fromRGBO(16, 124, 16, 1.0);
      default:
        return PlexColorPalette.primaryGold;
    }
  }
}
