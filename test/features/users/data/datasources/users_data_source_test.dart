import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulliApi;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/datasources/users_data_source.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUserNames extends Mock implements tautulliApi.GetUserNames {}

class MockGetUsersTable extends Mock implements tautulliApi.GetUsersTable {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  UsersDataSourceImpl dataSource;
  MockGetUserNames mockApiGetUserNames;
  MockGetUsersTable mockApiGetUsersTable;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetUserNames = MockGetUserNames();
    mockApiGetUsersTable = MockGetUsersTable();
    dataSource = UsersDataSourceImpl(
      apiGetUserNames: mockApiGetUserNames,
      apiGetUsersTable: mockApiGetUsersTable,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
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
          mockApiGetUserNames(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => usersJson);
        // act
        await dataSource.getUserNames(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetUserNames(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of UserModel',
      () async {
        // arrange
        when(
          mockApiGetUserNames(
            tautulliId: anyNamed('tautulliId'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => usersJson);
        // act
        final result = await dataSource.getUserNames(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
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
        when(mockApiGetUsersTable(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => usersTableJson);
        // act
        await dataSource.getUsersTable(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetUsersTable(
            tautulliId: tTautulliId,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of UserTableModel',
      () async {
        // arrange
        when(mockApiGetUsersTable(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
          settingsBloc: anyNamed('settingsBloc'),
        )).thenAnswer((_) async => usersTableJson);
        // act
        final result = await dataSource.getUsersTable(
          tautulliId: tTautulliId,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tUserTableList));
      },
    );
  });
}
