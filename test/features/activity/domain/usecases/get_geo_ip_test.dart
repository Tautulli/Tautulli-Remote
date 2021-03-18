import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/activity/data/models/geo_ip_model.dart';
import 'package:tautulli_remote/features/activity/domain/repositories/geo_ip_repository.dart';
import 'package:tautulli_remote/features/activity/domain/usecases/get_geo_ip.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

class MockGeoIpRepository extends Mock implements GeoIpRepository {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  GetGeoIp usecase;
  MockGeoIpRepository mockGeoIpRepository;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGeoIpRepository = MockGeoIpRepository();
    usecase = GetGeoIp(
      repository: mockGeoIpRepository,
    );
    mockSettings = MockSettings();
    mockLogging = MockLogging();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';

  final tIpAddress = '10.0.0.1';

  final tGeoIpItemModel = GeoIpItemModel(
    accuracy: null,
    city: "Toronto",
    code: "CA",
    continent: null,
    country: "Canada",
    latitude: 43.6403,
    longitude: -79.3711,
    postalCode: "M5E",
    region: "Ontario",
    timezone: "America/Toronto",
  );

  test(
    'should get GeoIpItem from repository',
    () async {
      // arrange
      when(
        mockGeoIpRepository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      ).thenAnswer((_) async => Right(tGeoIpItemModel));
      // act
      final result = await usecase(
        tautulliId: tTautulliId,
        ipAddress: tIpAddress,
        settingsBloc: settingsBloc,
      );
      // assert
      expect(result, Right(tGeoIpItemModel));
      verify(
        mockGeoIpRepository.getGeoIp(
          tautulliId: tTautulliId,
          ipAddress: tIpAddress,
          settingsBloc: settingsBloc,
        ),
      );
      verifyNoMoreInteractions(mockGeoIpRepository);
    },
  );
}
