import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';
import 'package:tautulli_remote/features/users/domain/repositories/users_repository.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user_names.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  GetUserNames usecase;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    usecase = GetUserNames(
      repository: mockUsersRepository,
    );
  });

  final tTautulliId = 'jkl';

  final List<User> tUserList = [];

  final usersJson = json.decode(fixture('users.json'));

  usersJson['response']['data'].forEach((item) {
    tUserList.add(UserModel.fromJson(item));
  });

  test(
    'should get list of User from repository',
    () async {
      // arrange
      when(
        mockUsersRepository.getUserNames(
          tautulliId: anyNamed('tautulliId'),
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
