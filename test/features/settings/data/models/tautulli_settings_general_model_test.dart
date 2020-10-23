import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/settings/data/models/tautulli_settings_general_model.dart';
import 'package:tautulli_remote/features/settings/domain/entities/tautulli_settings_general.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tTautulliSettingsGeneralModel = TautulliSettingsGeneralModel(
    dateFormat: 'YYYY-MM-DD',
    timeFormat: 'HH:mm',
  );

  test('should be a subclass of TautulliSettingsGeneral entity', () async {
    //assert
    expect(tTautulliSettingsGeneralModel, isA<TautulliSettingsGeneral>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('tautulli_settings.json'));
        //act
        final result = TautulliSettingsGeneralModel.fromJson(jsonMap['response']['data']['General']);
        //assert
        expect(result, tTautulliSettingsGeneralModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('tautulli_settings.json'));
        // act
        final result = TautulliSettingsGeneralModel.fromJson(jsonMap['response']['data']['General']);
        // assert
        expect(result.dateFormat, equals(jsonMap['response']['data']['General']['date_format']));
      },
    );
  });
}