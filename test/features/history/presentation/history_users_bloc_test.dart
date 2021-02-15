import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/features/history/presentation/bloc/history_users_bloc.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user_names.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetUserNames extends Mock implements GetUserNames {}

class MockLogging extends Mock implements Logging {}

void main() {
  HistoryUsersBloc bloc;
  MockGetUserNames mockGetUserNames;
  MockLogging mockLogging;

  setUp(() {
    mockGetUserNames = MockGetUserNames();
    mockLogging = MockLogging();
    bloc = HistoryUsersBloc(
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
    when(mockGetUserNames(tautulliId: anyNamed('tautulliId')))
        .thenAnswer((_) async => Right(tUserList));
  }

  test(
    'should get data from the GetUserNames use case',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // act
      bloc.add(
        HistoryUsersFetch(
          tautulliId: tTautulliId,
        ),
      );
      await untilCalled(
        mockGetUserNames(
          tautulliId: anyNamed('tautulliId'),
        ),
      );
      // assert
      verify(
        mockGetUserNames(
          tautulliId: tTautulliId,
        ),
      );
    },
  );

  test(
    'should emit [HistoryUsersSuccess] when users list is fetched successfully',
    () async {
      // arrange
      setUpSuccess();
      clearCache();
      // assert later
      final expected = [
        HistoryUsersInProgress(),
        HistoryUsersSuccess(
          usersList: tUserList,
        ),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(
        HistoryUsersFetch(
          tautulliId: tTautulliId,
        ),
      );
    },
  );

  test(
    'should emit [HistoryUsersFailure] when fetching users list fails',
    () async {
      // arrange
      final failure = ServerFailure();
      clearCache();
      when(
        mockGetUserNames(
          tautulliId: anyNamed('tautulliId'),
        ),
      ).thenAnswer((_) async => Left(failure));
      // assert later
      final expected = [
        HistoryUsersInProgress(),
        HistoryUsersFailure(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(
        HistoryUsersFetch(
          tautulliId: tTautulliId,
        ),
      );
    },
  );
}
