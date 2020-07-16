/// Helper functions for mapping assets to identifiers.
class AssetMapperHelper {
  static const String _platformsAssetPath = 'assets/platforms/';
  /// Returns an asset path for a given platform.
  String mapPlatformtoPath(String platform) {
    switch (platform) {
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
}