import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/core/database/data/models/server_model.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/repositories/settings_repository.dart';
import 'package:tautulli_remote_tdd/features/settings/domain/usecases/settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  Settings settings;
  MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    settings = Settings(
      repository: mockSettingsRepository,
    );
  });

  final int tId = 1;
  final String tPrimaryConnectionAddress = 'http://tautuli.domain.com';
  final String tPrimaryConnectionProtocol = 'http';
  final String tPrimaryConnectionDomain = 'tautuli.domain.com';
  final String tPrimaryConnectionPath = '/tautulli';
  final String tSecondaryConnectionAddress = 'http://tautuli.domain.com';
  final String tDeviceToken = 'abc';
  final String tTautulliId = 'jkl';
  final String tPlexName = 'Plex';

  final ServerModel tServerModel = ServerModel(
    id: tId,
    primaryConnectionAddress: tPrimaryConnectionAddress,
    primaryConnectionProtocol: tPrimaryConnectionProtocol,
    primaryConnectionDomain: tPrimaryConnectionDomain,
    primaryConnectionPath: tPrimaryConnectionPath,
    deviceToken: tDeviceToken,
    tautulliId: tTautulliId,
    plexName: tPlexName,
  );

  final List<ServerModel> tServerList = [tServerModel];

  test(
    'addServer should forward the request to the repository',
    () async {
      // act
      settings.addServer(
        primaryConnectionAddress: tPrimaryConnectionAddress,
        deviceToken: tDeviceToken,
        tautulliId: tTautulliId,
        plexName: tPlexName,
      );
      // assert
      verify(
        mockSettingsRepository.addServer(
          primaryConnectionAddress: tPrimaryConnectionAddress,
          deviceToken: tDeviceToken,
          tautulliId: tTautulliId,
          plexName: tPlexName,
        ),
      );
    },
  );

  test(
    'deleteServer should forward the request to the repository',
    () async {
      // act
      settings.deleteServer(tId);
      // assert
      verify(mockSettingsRepository.deleteServer(tId));
    },
  );

  test(
    'updateServer should forward the request to the repository',
    () async {
      // act
      settings.updateServer(tServerModel);
      // assert
      verify(mockSettingsRepository.updateServer(tServerModel));
    },
  );

  test(
    'updateServerById should forward the request to the repository',
    () async {
      // act
      settings.updateServerById(
        id: tId,
        primaryConnectionAddress: tPrimaryConnectionAddress,
        secondaryConnectionAddress: tSecondaryConnectionAddress,
        deviceToken: tDeviceToken,
        tautulliId: tTautulliId,
        plexName: tPlexName,
      );
      // assert
      verify(
        mockSettingsRepository.updateServerById(
          id: tId,
          primaryConnectionAddress: tPrimaryConnectionAddress,
          secondaryConnectionAddress: tSecondaryConnectionAddress,
          deviceToken: tDeviceToken,
          tautulliId: tTautulliId,
          plexName: tPlexName,
        ),
      );
    },
  );

  test(
    'getAllServers should return a List of ServerModel',
    () async {
      // arrange
      when(mockSettingsRepository.getAllServers())
          .thenAnswer((_) async => tServerList);
      // act
      final List<ServerModel> servers = await settings.getAllServers();
      // assert
      expect(servers, equals(tServerList));
    },
  );

  test(
    'getServer should return a single ServerModel',
    () async {
      // arrange
      when(mockSettingsRepository.getServer(any))
          .thenAnswer((_) async => tServerModel);
      // act
      final server = await settings.getServer(tId);
      // assert
      expect(server, equals(tServerModel));
    },
  );

  test(
    'getServerByTautulliId should return a single ServerModel',
    () async {
      // arrange
      when(mockSettingsRepository.getServerByTautulliId(any))
          .thenAnswer((_) async => tServerModel);
      // act
      final server = await settings.getServerByTautulliId(tTautulliId);
      // assert
      expect(server, equals(tServerModel));
    },
  );

  test(
    'updatePrimaryConnection should forward the request to the repository',
    () async {
      // act
      settings.updatePrimaryConnection(
        id: tId,
        primaryConnectionAddress: tPrimaryConnectionAddress,
      );
      // assert
      verify(
        mockSettingsRepository.updatePrimaryConnection(
          id: tId,
          primaryConnectionAddress: tPrimaryConnectionAddress,
        ),
      );
    },
  );

  test(
    'updateSecondaryConnection should forward the request to the repository',
    () async {
      // act
      settings.updateSecondaryConnection(
        id: tId,
        secondaryConnectionAddress: tPrimaryConnectionAddress,
      );
      // assert
      verify(
        mockSettingsRepository.updateSecondaryConnection(
          id: tId,
          secondaryConnectionAddress: tPrimaryConnectionAddress,
        ),
      );
    },
  );

  test(
    'updateDeviceToken should forward the request to the repository',
    () async {
      // act
      settings.updateDeviceToken(
        id: tId,
        deviceToken: tDeviceToken,
      );
      // assert
      verify(
        mockSettingsRepository.updateDeviceToken(
          id: tId,
          deviceToken: tDeviceToken,
        ),
      );
    },
  );
}
