import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/media/domain/repositories/children_metadata_repository.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_children_metadata.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockChildrenMetadataRepository extends Mock
    implements ChildrenMetadataRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetChildrenMetadata usecase;
  MockChildrenMetadataRepository mockChildrenMetadataRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockChildrenMetadataRepository = MockChildrenMetadataRepository();
    usecase = GetChildrenMetadata(
      repository: mockChildrenMetadataRepository,
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

  final tChildrenMetadataJson = json.decode(fixture('children_metadata.json'));

  final List<MetadataItem> tChildrenMetadataList = [];
  tChildrenMetadataJson['response']['data']['children_list'].forEach((item) {
    tChildrenMetadataList.add(MetadataItemModel.fromJson(item));
  });

  test(
    'should get list of MetadataItem from repository',
    () async {
      // arrange
      when(
        mockChildrenMetadataRepository.getChildrenMetadata(
          tautulliId: anyNamed('tautulliId'),
          ratingKey: anyNamed('ratingKey'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tChildrenMetadataList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ratingKey: tRatingKey,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tChildrenMetadataList)));
    },
  );
}
