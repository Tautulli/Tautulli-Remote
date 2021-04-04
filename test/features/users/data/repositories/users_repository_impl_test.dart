import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/network/network_info.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/datasources/users_data_source.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/data/repositories/users_repository_impl.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersDataSource extends Mock implements UsersDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UsersTableRepositoryImpl repository;
  MockUsersDataSource mockUsersDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockUsersDataSource = MockUsersDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UsersTableRepositoryImpl(
      dataSource: mockUsersDataSource,
      networkInfo: mockNetworkInfo,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'jkl';
  const tUserId = 123;

  UserTable tUser;
  final List<User> tUsersList = [];
  final List<UserTable> tUsersTableList = [];

  final userJson = json.decode(fixture('user.json'));
  final usersJson = json.decode(fixture('users.json'));
  final usersTableJson = json.decode(fixture('users_table.json'));

  tUser = UserTableModel.fromJson(userJson['response']['data']);
  usersJson['response']['data'].forEach((item) {
    tUsersList.add(UserModel.fromJson(item));
  });
  usersTableJson['response']['data']['data'].forEach((item) {
    tUsersTableList.add(UserTableModel.fromJson(item));
  });

  group('getUser', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getUser(
          tautulliId: tTautulliId,
          userId: tUserId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getUser()',
        () async {
          // act
          await repository.getUser(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockUsersDataSource.getUser(
              tautulliId: tTautulliId,
              userId: tUserId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return UserTable item when call to API is successful',
        () async {
          // arrange
          when(
            mockUsersDataSource.getUser(
              tautulliId: anyNamed('tautulliId'),
              userId: anyNamed('userId'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tUser);
          // act
          final result = await repository.getUser(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tUser)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getUser(
            tautulliId: tTautulliId,
            userId: tUserId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('getUserNames', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getUserNames(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getUserNames()',
        () async {
          // act
          await repository.getUserNames(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockUsersDataSource.getUserNames(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of User when call to API is successful',
        () async {
          // arrange
          when(
            mockUsersDataSource.getUserNames(
              tautulliId: anyNamed('tautulliId'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tUsersList);
          // act
          final result = await repository.getUserNames(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tUsersList)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getUserNames(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });

  group('getUsersTable', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        await repository.getUsersTable(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should call the data source getUsersTable()',
        () async {
          // act
          await repository.getUsersTable(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          verify(
            mockUsersDataSource.getUsersTable(
              tautulliId: tTautulliId,
              settingsBloc: settingsBloc,
            ),
          );
        },
      );

      test(
        'should return list of UserTable when call to API is successful',
        () async {
          // arrange
          when(
            mockUsersDataSource.getUsersTable(
              tautulliId: anyNamed('tautulliId'),
              grouping: anyNamed('grouping'),
              orderColumn: anyNamed('orderColumn'),
              orderDir: anyNamed('orderDir'),
              start: anyNamed('start'),
              length: anyNamed('length'),
              search: anyNamed('search'),
              settingsBloc: anyNamed('settingsBloc'),
            ),
          ).thenAnswer((_) async => tUsersTableList);
          // act
          final result = await repository.getUsersTable(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Right(tUsersTableList)));
        },
      );
    });

    group('device is offline', () {
      test(
        'should return a ConnectionFailure when there is no network connection',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          // act
          final result = await repository.getUsersTable(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
