import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user_names.dart';
import 'package:tautulli_remote/features/users/presentation/bloc/users_list_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUserNames extends Mock implements GetUserNames {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UsersListBloc bloc;
  MockGetUserNames mockGetUserNames;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetUserNames = MockGetUserNames();
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
    bloc = UsersListBloc(
      getUserNames: mockGetUserNames,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';

  final List<User> tUserList = [];

  final userJson = json.decode(fixture('users.json'));
  userJson['response']['data'].forEach((item) {
    tUserList.add(UserModel.fromJson(item));
  });

  void setUpSuccess() {
    when(mockGetUserNames(
      tautulliId: anyNamed('tautulliId'),
      settingsBloc: anyNamed('settingsBloc'),
    )).thenAnswer((_) async => Right(tUserList));
  }

  test(
    'should get data from the GetUserNames use case',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // act
      bloc.add(
        UsersListFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ),
      );
      await untilCalled(
        mockGetUserNames(
          tautulliId: anyNamed('tautulliId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      );
      // assert
      verify(
        mockGetUserNames(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  test(
    'should emit [UsersListSuccess] when users list is fetched successfully',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // assert later
      final expected = [
        UsersListInProgress(),
        UsersListSuccess(
          usersList: tUserList,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        UsersListFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );

  test(
    'should emit [UsersListFailure] when fetching users list fails',
    () async {
      // arrange
      final failure = ServerFailure();
      clearCache();
      when(
        mockGetUserNames(
          tautulliId: anyNamed('tautulliId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Left(failure));
      // assert later
      final expected = [
        UsersListInProgress(),
        UsersListFailure(),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        UsersListFetch(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        ),
      );
    },
  );
}
