import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/error/failure.dart';
import 'package:tautulli_remote_tdd/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote_tdd/features/users/domain/usercases/get_users_table.dart';
import 'package:tautulli_remote_tdd/features/users/presentation/bloc/users_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetUsers extends Mock implements GetUsersTable {}

class MockLogging extends Mock implements Logging {}

void main() {
  UsersBloc bloc;
  MockGetUsers mockGetUsers;
  MockLogging mockLogging;

  setUp(() {
    mockGetUsers = MockGetUsers();
    mockLogging = MockLogging();
    bloc = UsersBloc(
      getUsersTable: mockGetUsers,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';

  final List<UserTable> tUsersList = [];
  final List<UserTable> tUsersList25 = [];

  final userJson = json.decode(fixture('users_table.json'));

  userJson['response']['data']['data'].forEach((item) {
    tUsersList.add(UserTableModel.fromJson(item));
  });

  for (int i = 0; i < 25; i++) {
    userJson['response']['data']['data'].forEach((item) {
      tUsersList25.add(UserTableModel.fromJson(item));
    });
  }

  void setUpSuccess(List list) {
    when(mockGetUsers(
      tautulliId: anyNamed('tautulliId'),
      grouping: anyNamed('grouping'),
      orderColumn: anyNamed('orderColumn'),
      orderDir: anyNamed('orderDir'),
      start: anyNamed('start'),
      length: anyNamed('length'),
      search: anyNamed('search'),
    )).thenAnswer((_) async => Right(list));
  }

  test(
    'initialState should be UsersInitial',
    () async {
      // assert
      expect(bloc.state, UsersInitial());
    },
  );

  group('UsersFetch', () {
    test(
      'should get data from GetUsers use case',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        // act
        bloc.add(UsersFetch(tautulliId: tTautulliId));
        await untilCalled(mockGetUsers(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
        ));
        // assert
        verify(
          mockGetUsers(
            tautulliId: tTautulliId,
            length: 25,
          ),
        );
      },
    );

    test(
      'should emit [RecentlyAddedSuccess] with hasReachedMax as true when data is fetched successfully and the list length is under 25',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(tautulliId: tTautulliId));
      },
    );

    test(
      'when state is [RecentlyAddedSuccess] should emit [RecentlyAddedSuccess] with hasReachedMax as true when data is fetched successfully and list length under 25',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        bloc.emit(
          UsersSuccess(
            list: tUsersList25,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList25 + tUsersList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(tautulliId: tTautulliId));
      },
    );

    test(
      'should emit [RecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully and the list length is 25 or more',
      () async {
        // arrange
        setUpSuccess(tUsersList25);
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(tautulliId: tTautulliId));
      },
    );

    test(
      'when state is [RecentlyAddedSuccess] should emit [RecentlyAddedSuccess] with hasReachedMax as false when data is fetched successfully and list length is 25 or more',
      () async {
        // arrange
        setUpSuccess(tUsersList25);
        bloc.emit(
          UsersSuccess(
            list: tUsersList25,
            hasReachedMax: false,
          ),
        );
        // assert later
        final expected = [
          UsersSuccess(
            list: tUsersList25 + tUsersList25,
            hasReachedMax: false,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(tautulliId: tTautulliId));
      },
    );

    test(
      'should emit [UsersFailure] with a proper message when getting data fails',
      () async {
        // arrange
        final failure = ServerFailure();
        when(mockGetUsers(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
        )).thenAnswer((_) async => Left(failure));
        // assert later
        final expected = [
          UsersFailure(
            failure: failure,
            message: SERVER_FAILURE_MESSAGE,
            suggestion: CHECK_SERVER_SETTINGS_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(UsersFetch(tautulliId: tTautulliId));
      },
    );
  });

  group('UsersFilter', () {
    test(
      'should emit [UsersInitial] before executing as normal',
      () async {
        // arrange
        setUpSuccess(tUsersList);
        // assert later
        final expected = [
          UsersInitial(),
          UsersSuccess(
            list: tUsersList,
            hasReachedMax: true,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(UsersFilter(tautulliId: tTautulliId));
      },
    );
  });
}
