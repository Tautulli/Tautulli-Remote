import 'package:flutter/material.dart';

import '../../../../core/helpers/tautulli_api_url_helper.dart';
import '../../../settings/domain/entities/settings.dart';
import '../../domain/entities/activity.dart';

class BackgroundImageChooser extends StatelessWidget {
  final TautulliApiUrls tautulliApiUrls;
  final ActivityItem activity;
  final Settings settings;

  const BackgroundImageChooser({
    Key key,
    @required this.tautulliApiUrls,
    @required this.activity,
    @required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return activity.live == 1
        ? _BackgroundImageLiveTv()
        : activity.mediaType == 'photo'
            ? _BackgroundImageGeneral(
                tautulliApiUrls: tautulliApiUrls,
                connectionProtocol: settings.connectionProtocol,
                connectionDomain: settings.connectionDomain,
                connectionUser: settings.connectionUser,
                connectionPassword: settings.connectionPassword,
                deviceToken: settings.deviceToken,
                art: activity.thumb,
                ratingKey: activity.ratingKey,
              )
            : _BackgroundImageGeneral(
                tautulliApiUrls: tautulliApiUrls,
                connectionProtocol: settings.connectionProtocol,
                connectionDomain: settings.connectionDomain,
                connectionUser: settings.connectionUser,
                connectionPassword: settings.connectionPassword,
                deviceToken: settings.deviceToken,
                art: activity.art,
                ratingKey: activity.ratingKey,
              );
  }
}

class _BackgroundImageGeneral extends StatelessWidget {
  final TautulliApiUrls tautulliApiUrls;
  final String connectionProtocol;
  final String connectionDomain;
  final String connectionUser;
  final String connectionPassword;
  final String deviceToken;
  final String art;
  final int ratingKey;

  const _BackgroundImageGeneral({
    Key key,
    @required this.tautulliApiUrls,
    @required this.connectionProtocol,
    @required this.connectionDomain,
    @required this.connectionUser,
    @required this.connectionPassword,
    @required this.deviceToken,
    this.art,
    this.ratingKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(
            tautulliApiUrls.pmsImageProxyUrl(
              protocol: connectionProtocol,
              domain: connectionDomain,
              deviceToken: deviceToken,
              img: art,
              ratingKey: ratingKey,
              fallback: 'art',
            ),
            headers: tautulliApiUrls.buildBasicAuthHeader(
              user: connectionUser,
              password: connectionPassword,
            ),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}

class _BackgroundImageLiveTv extends StatelessWidget {
  const _BackgroundImageLiveTv({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Uses asset image since fallback image from API is pre-blurred
    // Does not add opacity layer as it makes the image too dark
    return Image.asset(
      'assets/images/livetv_fallback.png',
      fit: BoxFit.cover,
    );
  }
}
