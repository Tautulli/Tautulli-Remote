import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote_tdd/features/users/domain/entities/user_table.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserTableModel = UserTableModel(
    duration: 8132145,
    friendlyName: 'Derek Rivard',
    isActive: 1,
    ipAddress: '192.168.0.224',
    lastPlayed: 'Hannah Gadsby: Douglas',
    lastSeen: 1597194400,
    mediaType: 'movie',
    plays: 3878,
    ratingKey: 99902,
    userId: 1526265,
    userThumb: 'https://plex.tv/users/5df7320378672025/avatar?c=1578073887',
  );

  test('should be a subclass of UserTable entity', () async {
    //assert
    expect(tUserTableModel, isA<UserTable>());
  });
  
  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user_table.json'));
        // act
        final result = UserTableModel.fromJson(jsonMap);
        // assert
        expect(result, equals(tUserTableModel));
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user_table.json'));
        // act
        final result = UserTableModel.fromJson(jsonMap);
        // assert
        expect(result.userId, equals(jsonMap['user_id']));
      },
    );
  });
}
