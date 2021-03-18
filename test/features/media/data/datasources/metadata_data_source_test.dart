import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/datasources/metadata_data_source.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetMetadata extends Mock implements tautulliApi.GetMetadata {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  MetadataDataSourceImpl dataSource;
  MockGetMetadata mockApiGetMetadata;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetMetadata = MockGetMetadata();
    dataSource = MetadataDataSourceImpl(
      apiGetMetadata: mockApiGetMetadata,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final String tTautulliId = 'jkl';
  final int tRatingKey = 53052;

  final metadataItemJson = json.decode(fixture('metadata_item.json'));
  final MetadataItem tMetadataItem =
      MetadataItemModel.fromJson(metadataItemJson['response']['data']);

  group('getMetadata', () {
    test(
      'should call [getMetadata] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetMetadata(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => metadataItemJson);
        // act
        await dataSource.getMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a MetadataItem',
      () async {
        // arrange
        when(
          mockApiGetMetadata(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => metadataItemJson);
        // act
        final result = await dataSource.getMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tMetadataItem));
      },
    );
  });
}
