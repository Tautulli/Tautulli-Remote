import '../types/section_type.dart';

class AssetHelper {
  static const String _platformsAssetPath = 'assets/platforms/';
  static const String _librariesAssetPath = 'assets/libraries/';

  /// Returns an asset path for a given platform.
  static String mapPlatformToPath(String? platform) {
    switch (platform) {
      case 'alexa':
        return '${_platformsAssetPath}alexa.svg';
      case 'android':
        return '${_platformsAssetPath}android.svg';
      case 'atv':
        return '${_platformsAssetPath}atv.svg';
      case 'chrome':
        return '${_platformsAssetPath}chrome.svg';
      case 'chromecast':
        return '${_platformsAssetPath}chromecast.svg';
      case 'dlna':
        return '${_platformsAssetPath}dlna.svg';
      case 'firefox':
        return '${_platformsAssetPath}firefox.svg';
      case 'ie':
        return '${_platformsAssetPath}ie.svg';
      case 'ios':
        return '${_platformsAssetPath}ios.svg';
      case 'kodi':
        return '${_platformsAssetPath}kodi.svg';
      case 'lg':
        return '${_platformsAssetPath}lg.svg';
      case 'linux':
        return '${_platformsAssetPath}linux.svg';
      case 'macos':
        return '${_platformsAssetPath}macos.svg';
      case 'msedge':
        return '${_platformsAssetPath}msedge.svg';
      case 'opera':
        return '${_platformsAssetPath}opera.svg';
      case 'playstation':
        return '${_platformsAssetPath}playstation.svg';
      case 'plex':
        return '${_platformsAssetPath}plex.svg';
      case 'plexamp':
        return '${_platformsAssetPath}plexamp.svg';
      case 'roku':
        return '${_platformsAssetPath}roku.svg';
      case 'safari':
        return '${_platformsAssetPath}safari.svg';
      case 'samsung':
        return '${_platformsAssetPath}samsung.svg';
      case 'synclounge':
        return '${_platformsAssetPath}synclounge.svg';
      case 'tivo':
        return '${_platformsAssetPath}tivo.svg';

      case 'windows':
      case 'wp':
        return '${_platformsAssetPath}windows.svg';

      case 'xbox':
        return '${_platformsAssetPath}xbox.svg';
      default:
        return '${_platformsAssetPath}default.svg';
    }
  }

  static String mapSectionTypeToPath(SectionType? sectionType) {
    switch (sectionType) {
      case (SectionType.artist):
        return '${_librariesAssetPath}artist.svg';
      case (SectionType.live):
        return '${_librariesAssetPath}live.svg';
      case (SectionType.movie):
        return '${_librariesAssetPath}movie.svg';
      case (SectionType.photo):
        return '${_librariesAssetPath}photo.svg';
      case (SectionType.playlist):
        return '${_librariesAssetPath}playlist.svg';
      case (SectionType.show):
        return '${_librariesAssetPath}show.svg';
      case (SectionType.video):
      default:
        return '${_librariesAssetPath}video.svg';
    }
  }
}
