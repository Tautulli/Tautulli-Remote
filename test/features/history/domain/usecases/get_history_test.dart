import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/history/data/models/history_model.dart';
import 'package:tautulli_remote/features/history/domain/entities/history.dart';
import 'package:tautulli_remote/features/history/domain/repositories/history_repository.dart';
import 'package:tautulli_remote/features/history/domain/usecases/get_history.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetHistory usecase;
  MockHistoryRepository mockHistoryRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockHistoryRepository = MockHistoryRepository();
    usecase = GetHistory(
      repository: mockHistoryRepository,
    );
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const String tTautulliId = 'jkl';

  final List<History> tHistoryList = [];

  final historyJson = json.decode(fixture('history.json'));

  historyJson['response']['data']['data'].forEach((item) {
    tHistoryList.add(HistoryModel.fromJson(item));
  });

  test(
    'should get list of History from repository',
    () async {
      // arrange
      when(
        mockHistoryRepository.getHistory(
          tautulliId: tTautulliId,
          grouping: anyNamed('grouping'),
          user: anyNamed('user'),
          userId: anyNamed('userId'),
          ratingKey: anyNamed('ratingKey'),
          parentRatingKey: anyNamed('parentRatingKey'),
          grandparentRatingKey: anyNamed('grandparentRatingKey'),
          startDate: anyNamed('startDate'),
          sectionId: anyNamed('sectionId'),
          mediaType: anyNamed('mediaType'),
          transcodeDecision: anyNamed('transcodeDecision'),
          guid: anyNamed('guid'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tHistoryList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tHistoryList)));
    },
  );
}
