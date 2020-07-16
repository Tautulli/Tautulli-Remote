import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote_tdd/features/settings/data/models/settings_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/entities/settings.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/repositories/settings_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/get_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  GetSettings getSettings;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    getSettings = GetSettings(repository: mockSettingsRepository);
  });

  test(
    'should get connectionAddress from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getConnectionAddress())
          .thenAnswer((_) async => 'http://tautulli.com');
      // act
      final result = await getSettings.connectionAddress();
      // assert
      expect(result, equals('http://tautulli.com'));
      verify(mockSettingsRepository.getConnectionAddress());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'should get deviceToken from settings',
    () async {
      // arrange
      when(mockSettingsRepository.getDeviceToken()).thenAnswer((_) async => 'abc');
      // act
      final result = await getSettings.deviceToken();
      // assert
      expect(result, equals('abc'));
      verify(mockSettingsRepository.getDeviceToken());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );

  test(
    'should get SettingsModel with all saved settings',
    () async {
      // arrange
      final Settings tSettingsModel = SettingsModel(
        connectionAddress: 'http://tautulli.com',
        connectionProtocol: 'http',
        connectionDomain: 'tautulli.com',
        connectionUser: 'user',
        connectionPassword: 'pass',
        deviceToken: 'abc',
      );
      when(mockSettingsRepository.load())
          .thenAnswer((_) async => tSettingsModel);
      // act
      final result = await getSettings.load();
      // assert
      expect(result, equals(tSettingsModel));
      verify(mockSettingsRepository.load());
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
