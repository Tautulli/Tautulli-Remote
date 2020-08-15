import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/api/tautulli_api.dart';
import 'package:tautulli_remote_tdd/features/users/data/datasources/users_data_source.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_model.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user.dart';

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

  final usersJson = json.decode(fixture('users.json'));

  usersJson['response']['data']['data'].forEach((item) {
    tUserList.add(UserModel.fromJson(item));
  });

  group('getUsers', () {
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
        )).thenAnswer((_) async => usersJson);
        // act
        await dataSource.getUsers(tautulliId: tTautulliId);
        // assert
        verify(
          mockTautulliApi.getUsersTable(tautulliId: tTautulliId),
        );
      },
    );

    test(
      'should return a list of UserModel',
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
        )).thenAnswer((_) async => usersJson);
        // act
        final result = await dataSource.getUsers(tautulliId: tTautulliId);
        // assert
        expect(result, equals(tUserList));
      },
    );
  });
}
