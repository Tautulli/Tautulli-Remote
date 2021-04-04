import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user.dart';
import 'package:tautulli_remote/features/users/presentation/bloc/user_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUser extends Mock implements GetUser {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UserBloc bloc;
  MockGetUser mockGetUser;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetUser = MockGetUser();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
    bloc = UserBloc(
      getUser: mockGetUser,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tUserId = 123;

  UserTable tUser;

  final userJson = json.decode(fixture('user.json'));

  tUser = UserTableModel.fromJson(userJson['response']['data']);

  void setUpSuccess() {
    when(mockGetUser(
      tautulliId: anyNamed('tautulliId'),
      userId: anyNamed('userId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tUser));
  }

  test(
    'initialState should be UserInitial',
    () async {
      // assert
      expect(bloc.state, UserInitial());
    },
  );

  group('UserFetch', () {
    test(
      'should get data from GetUser use case',
      () async {
        // arrange
        clearCache();
        setUpSuccess();
        // act
        bloc.add(UserFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(mockGetUser(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
        // assert
        verify(
          mockGetUser(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [UserSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          UserInProgress(),
          UserSuccess(
            user: tUser,
          ),
        ];
        // ignore: unawaited_futures
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(UserFetch(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        ));
      },
    );
  });
}
