import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/users/data/datasources/users_data_source.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_model.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote_tdd/features/users/data/repositories/users_repository_impl.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersDataSource extends Mock implements UsersDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFailureMapperHelper extends Mock implements FailureMapperHelper {}

void main() {
  UsersTableRepositoryImpl repository;
  MockUsersDataSource mockUsersDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockFailureMapperHelper mockFailureMapperHelper;

  setUp(() {
    mockUsersDataSource = MockUsersDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFailureMapperHelper = MockFailureMapperHelper();
    repository = UsersTableRepositoryImpl(
      dataSource: mockUsersDataSource,
      networkInfo: mockNetworkInfo,
      failureMapperHelper: mockFailureMapperHelper,
    );
  });

  final tTautulliId = 'jkl';

  final List<User> tUsersList = [];
  final List<UserTable> tUsersTableList = [];

  final usersJson = json.decode(fixture('users.json'));
  final usersTableJson = json.decode(fixture('users_table.json'));

  usersJson['response']['data'].forEach((item) {
    tUsersList.add(UserModel.fromJson(item));
  });
  usersTableJson['response']['data']['data'].forEach((item) {
    tUsersTableList.add(UserTableModel.fromJson(item));
  });

  group('getUserNames', () {
    test(
      'should check if device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getUserNames(tautulliId: tTautulliId);
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
          );
          // assert
          verify(
            mockUsersDataSource.getUserNames(
              tautulliId: tTautulliId,
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
            ),
          ).thenAnswer((_) async => tUsersList);
          // act
          final result = await repository.getUserNames(
            tautulliId: tTautulliId,
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
        repository.getUsersTable(tautulliId: tTautulliId);
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
          );
          // assert
          verify(
            mockUsersDataSource.getUsersTable(
              tautulliId: tTautulliId,
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
            ),
          ).thenAnswer((_) async => tUsersTableList);
          // act
          final result = await repository.getUsersTable(
            tautulliId: tTautulliId,
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
          );
          // assert
          expect(result, equals(Left(ConnectionFailure())));
        },
      );
    });
  });
}
