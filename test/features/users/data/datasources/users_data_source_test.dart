import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api.dart';
import 'package:tautulli_remote/features/users/data/datasources/users_data_source.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockTautulliApi extends Mock implements TautulliApi {}

void main() {
  UsersDataSourceImpl dataSource;
  MockTautulliApi mockTautulliApi;

  setUp(() {
    mockTautulliApi = MockTautulliApi();
    dataSource = UsersDataSourceImpl(
      tautulliApi: mockTautulliApi,
    );
  });

  final String tTautulliId = 'jkl';

  final List<User> tUserList = [];
  final List<UserTable> tUserTableList = [];

  final usersJson = json.decode(fixture('users.json'));
  final usersTableJson = json.decode(fixture('users_table.json'));

  usersJson['response']['data'].forEach((item) {
    tUserList.add(UserModel.fromJson(item));
  });
  usersTableJson['response']['data']['data'].forEach((item) {
    tUserTableList.add(UserTableModel.fromJson(item));
  });

  group('getUserNames', () {
    test(
      'should call [getUserNames] from TautulliApi',
      () async {
        // arrange
        when(
          mockTautulliApi.getUserNames(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => usersJson);
        // act
        await dataSource.getUserNames(tautulliId: tTautulliId);
        // assert
        verify(
          mockTautulliApi.getUserNames(tautulliId: tTautulliId),
        );
      },
    );

    test(
      'should return a list of UserModel',
      () async {
        // arrange
        when(
          mockTautulliApi.getUserNames(
            tautulliId: anyNamed('tautulliId'),
          ),
        ).thenAnswer((_) async => usersJson);
        // act
        final result = await dataSource.getUserNames(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tUserList));
      },
    );
  });

  group('getUsersTable', () {
    test(
      'should call [getUsersTable] from TautulliApi',
      () async {
        // arrange
        when(mockTautulliApi.getUsersTable(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
        )).thenAnswer((_) async => usersTableJson);
        // act
        await dataSource.getUsersTable(tautulliId: tTautulliId);
        // assert
        verify(
          mockTautulliApi.getUsersTable(tautulliId: tTautulliId),
        );
      },
    );

    test(
      'should return a list of UserTableModel',
      () async {
        // arrange
        when(mockTautulliApi.getUsersTable(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
        )).thenAnswer((_) async => usersTableJson);
        // act
        final result = await dataSource.getUsersTable(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tUserTableList));
      },
    );
  });
}
