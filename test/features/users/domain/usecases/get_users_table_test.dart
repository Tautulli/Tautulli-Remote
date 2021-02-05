import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote/features/users/domain/repositories/users_repository.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_users_table.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

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

  final List<UserTable> tUserTableList = [];

  final usersTableJson = json.decode(fixture('users_table.json'));

  usersTableJson['response']['data']['data'].forEach((item) {
    tUserTableList.add(UserTableModel.fromJson(item));
  });

  test(
    'should get list of UserTable from repository',
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
      ).thenAnswer((_) async => Right(tUserTableList));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
      );
      // assert
      expect(result, equals(Right(tUserTableList)));
    },
  );
}
