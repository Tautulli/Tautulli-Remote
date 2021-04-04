import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/media/domain/repositories/metadata_repository.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_metadata.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockMetadataRepository extends Mock implements MetadataRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetMetadata usecase;
  MockMetadataRepository mockMetadataRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockMetadataRepository = MockMetadataRepository();
    usecase = GetMetadata(
      repository: mockMetadataRepository,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';
  const int tRatingKey = 53052;

  final metadataItemJson = json.decode(fixture('metadata_item.json'));
  final MetadataItem tMetadataItem =
      MetadataItemModel.fromJson(metadataItemJson['response']['data']);

  test(
    'should get MetadataItem from repository',
    () async {
      // arrange
      when(
        mockMetadataRepository.getMetadata(
          tautulliId: anyNamed('tautulliId'),
          ratingKey: anyNamed('ratingKey'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tMetadataItem));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ratingKey: tRatingKey,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tMetadataItem)));
    },
  );
}
