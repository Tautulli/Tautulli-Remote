import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/entities/settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/repositories/settings_repository.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/set_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  SetSettings setSettings;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    setSettings = SetSettings(repository: mockSettingsRepository);
  });

  final tConnectionAddress = 'http://tautulli.com';
  final tConnectionProtocol = 'http';
  final tConnectionDomain = 'tautulli.com';
  final tConnectionUser = 'user';
  final tConnectionPassword = 'password';
  final tDeviceToken = 'abc';
  final Settings tSettings = SettingsModel(
    connectionAddress: tConnectionAddress,
    connectionProtocol: tConnectionProtocol,
    connectionDomain: tConnectionDomain,
    connectionUser: tConnectionUser,
    connectionPassword: tConnectionPassword,
    deviceToken: tDeviceToken,
  );

  test(
    'should save URL to settings',
    () async {
      // act
      await setSettings.setConnection(tConnectionAddress);
      // assert
      verify(mockSettingsRepository.setConnection(tConnectionAddress));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'should save Device Token to settings',
    () async {
      // act
      await setSettings.setDeviceToken(tDeviceToken);
      // assert
      verify(mockSettingsRepository.setDeviceToken(tDeviceToken));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'should take in SettingsModel and save all values to settings',
    () async {
      // act
      await setSettings.save(tSettings);
      // assert
      verify(mockSettingsRepository.save(tSettings));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
