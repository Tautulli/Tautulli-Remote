import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/core/network/network_info.dart';
import 'package:tautulli_remote_tdd/features/users/data/datasources/users_data_source.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_model.dart';
import 'package:tautulli_remote_tdd/features/users/data/repositories/users_repository_impl.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersDataSource extends Mock implements UsersDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFailureMapperHelper extends Mock implements FailureMapperHelper {}

void main() {
  UsersRepositoryImpl repository;
  MockUsersDataSource mockUsersDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockFailureMapperHelper mockFailureMapperHelper;

  setUp(() {
    mockUsersDataSource = MockUsersDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockFailureMapperHelper = MockFailureMapperHelper();
    repository = UsersRepositoryImpl(
      dataSource: mockUsersDataSource,
      networkInfo: mockNetworkInfo,
      failureMapperHelper: mockFailureMapperHelper,
    );
  });

  final tTautulliId = 'jkl';

  final List<User> tUserList = [];

  final usersJson = json.decode(fixture('users.json'));

  usersJson['response']['data']['data'].forEach((item) {
    tUserList.add(UserModel.fromJson(item));
  });

  test(
    'should check if device is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getUsers(tautulliId: tTautulliId);
      // assert
      verify(mockNetworkInfo.isConnected);
    },
  );

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should call the data source getUsers()',
      () async {
        // act
        await repository.getUsers(
          tautulliId: tTautulliId,
        );
        // assert
        verify(
          mockUsersDataSource.getUsers(
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
          mockUsersDataSource.getUsers(
            tautulliId: anyNamed('tautulliId'),
            grouping: anyNamed('grouping'),
            orderColumn: anyNamed('orderColumn'),
            orderDir: anyNamed('orderDir'),
            start: anyNamed('start'),
            length: anyNamed('length'),
            search: anyNamed('search'),
          ),
        ).thenAnswer((_) async => tUserList);
        // act
        final result = await repository.getUsers(
          tautulliId: tTautulliId,
        );
        // assert
        expect(result, equals(Right(tUserList)));
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
        final result = await repository.getUsers(
          tautulliId: tTautulliId,
        );
        // assert
        expect(result, equals(Left(ConnectionFailure())));
      },
    );
  });
}
