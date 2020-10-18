import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/settings/data/models/plex_server_info_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/plex_server_info.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tPlexServerInfoModel = PlexServerInfoModel(
    pmsIdentifier: 'abc',
    pmsIp: '192.168.0.10',
    pmsIsRemote: 0,
    pmsName: 'Supremacy',
    pmsPlatform: 'Linux',
    pmsPlexpass: 1,
    pmsPort: 32400,
    pmsSsl: 1,
    pmsUrl: 'https://192-168-0-10.def.plex.direct:32400',
    pmsUrlManual: 0,
    pmsVersion: '1.20.3.3437-f1f08d65b',
  );

  test('should be a subclass of PlexServerInfo entity', () async {
    //assert
    expect(tPlexServerInfoModel, isA<PlexServerInfo>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('plex_server_info.json'));
        //act
        final result = PlexServerInfoModel.fromJson(jsonMap['response']['data']);
        //assert
        expect(result, tPlexServerInfoModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('plex_server_info.json'));
        // act
        final result = PlexServerInfoModel.fromJson(jsonMap['response']['data']);
        // assert
        expect(result.pmsName, equals(jsonMap['response']['data']['pms_name']));
      },
    );
  });
}