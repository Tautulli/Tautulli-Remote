import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

abstract class OpenInPlex {
  Future<bool> open({
    required String plexIdentifier,
    required int ratingKey,
    bool useLegacy,
  });
}

class OpenInPlexImpl implements OpenInPlex {
  @override
  Future<bool> open({
    required String plexIdentifier,
    required int ratingKey,
    bool useLegacy = false,
  }) async {
    String plexAppUrl = Platform.isAndroid
        ? 'plex://server://$plexIdentifier/com.plexapp.plugins.library/library/metadata/$ratingKey'
        : 'plex://preplay/?server=$plexIdentifier&metadataKey=/library/metadata/$ratingKey';
    String plexWebUrl =
        'https://app.plex.tv/desktop#!/server/$plexIdentifier/details?key=%2Flibrary%2Fmetadata%2F$ratingKey${useLegacy ? '&legacy=1' : ''}';

    if (await canLaunchUrlString(plexAppUrl)) {
      return launchUrlString(plexAppUrl, mode: LaunchMode.externalApplication);
    } else {
      return launchUrlString(plexWebUrl, mode: LaunchMode.externalApplication);
    }
  }
}
