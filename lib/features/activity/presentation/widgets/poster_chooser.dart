import 'package:flutter/material.dart';

import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../settings/domain/entities/settings.dart';
import '../../domain/entities/activity.dart';

class PosterChooser extends StatelessWidget {
  final TautulliApiUrls tautulliApiUrls;
  final ActivityItem activity;
  final Settings settings;

  const PosterChooser({
    Key key,
    @required this.tautulliApiUrls,
    @required this.activity,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return activity.mediaType == 'movie'
        ? _PosterGeneral(
            posterUrl: tautulliApiUrls.pmsImageProxyUrl(
              protocol: settings.connectionProtocol,
              domain: settings.connectionDomain,
              deviceToken: settings.deviceToken,
              img: activity.thumb,
              ratingKey: activity.ratingKey,
              fallback: activity.live == 0 ? 'poster' : 'poster-live',
            ),
            headers: tautulliApiUrls.buildBasicAuthHeader(
              user: settings.connectionUser,
              password: settings.connectionPassword,
            ),
          )
        : activity.mediaType == 'episode'
            ? _PosterGeneral(
                posterUrl: tautulliApiUrls.pmsImageProxyUrl(
                  protocol: settings.connectionProtocol,
                  domain: settings.connectionDomain,
                  deviceToken: settings.deviceToken,
                  img: activity.grandparentThumb,
                  ratingKey: activity.grandparentRatingKey,
                  fallback: activity.live == 0 ? 'poster' : 'poster-live',
                ),
                headers: tautulliApiUrls.buildBasicAuthHeader(
                  user: settings.connectionUser,
                  password: settings.connectionPassword,
                ),
              )
            : activity.mediaType == 'track'
                ? _PosterMusic(
                    posterUrl: tautulliApiUrls.pmsImageProxyUrl(
                      protocol: settings.connectionProtocol,
                      domain: settings.connectionDomain,
                      deviceToken: settings.deviceToken,
                      img: activity.thumb,
                      ratingKey: activity.parentRatingKey,
                      fallback: 'cover',
                    ),
                    posterUrlBlur: tautulliApiUrls.pmsImageProxyUrl(
                      protocol: settings.connectionProtocol,
                      domain: settings.connectionDomain,
                      deviceToken: settings.deviceToken,
                      img: activity.thumb,
                      ratingKey: activity.parentRatingKey,
                      opacity: 40,
                      background: 282828,
                      blur: 15,
                      fallback: 'poster',
                    ),
                    headers: tautulliApiUrls.buildBasicAuthHeader(
                      user: settings.connectionUser,
                      password: settings.connectionPassword,
                    ),
                  )
                : _PosterGeneral(
                    posterUrl: tautulliApiUrls.pmsImageProxyUrl(
                      protocol: settings.connectionProtocol,
                      domain: settings.connectionDomain,
                      deviceToken: settings.deviceToken,
                      ratingKey: activity.ratingKey,
                    ),
                    headers: tautulliApiUrls.buildBasicAuthHeader(
                      user: settings.connectionUser,
                      password: settings.connectionPassword,
                    ),
                  );
  }
}

class _PosterGeneral extends StatelessWidget {
  final String posterUrl;
  final Map headers;

  _PosterGeneral({
    @required this.posterUrl,
    @required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        padding: EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            posterUrl,
            headers: headers,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _PosterMusic extends StatelessWidget {
  final String posterUrl;
  final Map headers;
  final String posterUrlBlur;

  _PosterMusic({
    @required this.posterUrl,
    @required this.headers,
    @required this.posterUrlBlur,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        padding: EdgeInsets.all(3),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  posterUrlBlur,
                  headers: headers,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Image.network(
                posterUrl,
                headers: headers,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
