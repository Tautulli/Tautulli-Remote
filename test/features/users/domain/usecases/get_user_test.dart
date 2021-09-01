// @dart=2.9

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/users/data/models/user_table_model.dart';
import 'package:tautulli_remote/features/users/domain/entities/user_table.dart';
import 'package:tautulli_remote/features/users/domain/repositories/users_repository.dart';
import 'package:tautulli_remote/features/users/domain/usecases/get_user.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockUsersRepository extends Mock implements UsersRepository {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetUser usecase;
  MockUsersRepository mockUsersRepository;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    usecase = GetUser(
      repository: mockUsersRepository,
    );
    mockLogging = MockLogging();
    mockSettings = MockSettings();
    mockOnesignal = MockOnesignal();
    mockRegisterDevice = MockRegisterDevice();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      onesignal: mockOnesignal,
      registerDevice: mockRegisterDevice,
      logging: mockLogging,
    );
  });

  const tTautulliId = 'jkl';
  const tUserId = 123;

  UserTable tUser;

  final userJson = json.decode(fixture('user.json'));

  tUser = UserTableModel.fromJson(userJson['response']['data']);

  test(
    'should get UserTable item from repository',
    () async {
      // arrange
      when(
        mockUsersRepository.getUser(
          tautulliId: anyNamed('tautulliId'),
          userId: anyNamed('userId'),
          settingsBloc: anyNamed('settingsBloc'),
        ),
      ).thenAnswer((_) async => Right(tUser));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        userId: tUserId,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, equals(Right(tUser)));
    },
  );
}
