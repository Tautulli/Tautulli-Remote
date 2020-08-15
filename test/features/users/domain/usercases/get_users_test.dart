import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_model.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user.dart';
import 'package:tautulli_remote_tdd/features/users/domain/repositories/users_repository.dart';
import 'package:tautulli_remote_tdd/features/users/domain/usercases/get_users.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  GetUsers usecase;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    usecase = GetUsers(
      repository: mockUsersRepository,
    );
  });

  final tTautulliId = 'jkl';

  final List<User> tUserList = [];

  final usersJson = json.decode(fixture('users.json'));

  usersJson['response']['data']['data'].forEach((item) {
    tUserList.add(UserModel.fromJson(item));
  });

  test(
    'should get list of User from repository',
    () async {
      // arrange
      when(
        mockUsersRepository.getUsers(
          tautulliId: anyNamed('tautulliId'),
          grouping: anyNamed('grouping'),
          orderColumn: anyNamed('orderColumn'),
          orderDir: anyNamed('orderDir'),
          start: anyNamed('start'),
          length: anyNamed('length'),
          search: anyNamed('search'),
        ),
      ).thenAnswer((_) async => Right(tUserList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
      );
      // assert
      expect(result, equals(Right(tUserList)));
    },
  );
}
