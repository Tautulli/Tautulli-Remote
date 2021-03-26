import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/users/data/models/user_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    friendlyName: 'Friendly Name',
    userId: 1,
  );

  test('should be a subclass of User entity', () async {
    //assert
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user_name.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tUserModel));
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user_name.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result.userId, equals(jsonMap['user_id']));
      },
    );
  });
}
