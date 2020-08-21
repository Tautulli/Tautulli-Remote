import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote_tdd/features/users/domain/repositories/users_table_repository.dart';
import 'package:tautulli_remote_tdd/features/users/domain/usercases/get_users_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersRepository extends Mock implements UsersTableRepository {}

void main() {
  GetUsersTable usecase;
  MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    usecase = GetUsersTable(
      repository: mockUsersRepository,
    );
  });

  final tTautulliId = 'jkl';

  final List<UserTable> tUserList = [];

  final usersJson = json.decode(fixture('users.json'));

  usersJson['response']['data']['data'].forEach((item) {
    tUserList.add(UserTableModel.fromJson(item));
  });

  test(
    'should get list of User from repository',
    () async {
      // arrange
      when(
        mockUsersRepository.getUsersTable(
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
