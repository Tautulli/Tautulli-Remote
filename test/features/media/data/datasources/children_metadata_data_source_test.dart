import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/api/tautulli_api/tautulli_api.dart'
    as tautulli_api;
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/datasources/children_metadata_data_source.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/entities/metadata_item.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/register_device.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetChildrenMetadata extends Mock
    implements tautulli_api.GetChildrenMetadata {}

class MockSettings extends Mock implements Settings {}

class MockOnesignal extends Mock implements OneSignalDataSource {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockLogging extends Mock implements Logging {}

void main() {
  ChildrenMetadataDataSourceImpl dataSource;
  MockGetChildrenMetadata mockApiGetChildrenMetadata;
  MockSettings mockSettings;
  MockOnesignal mockOnesignal;
  MockRegisterDevice mockRegisterDevice;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockApiGetChildrenMetadata = MockGetChildrenMetadata();
    dataSource = ChildrenMetadataDataSourceImpl(
      apiGetChildrenMetadata: mockApiGetChildrenMetadata,
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

  const String tTautulliId = 'jkl';
  const int tRatingKey = 53052;

  final tChildrenMetadataInfoJson =
      json.decode(fixture('children_metadata.json'));

  final List<MetadataItem> tChildrenMetadataList = [];
  tChildrenMetadataInfoJson['response']['data']['children_list']
      .forEach((item) {
    tChildrenMetadataList.add(MetadataItemModel.fromJson(item));
  });

  group('getChildrenMetadata', () {
    test(
      'should call [getChildrenMetadata] from TautulliApi',
      () async {
        // arrange
        when(
          mockApiGetChildrenMetadata(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tChildrenMetadataInfoJson);
        // act
        await dataSource.getChildrenMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          settingsBloc: settingsBloc,
        );
        // assert
        verify(
          mockApiGetChildrenMetadata(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should return a list of MetadataItem',
      () async {
        // arrange
        when(
          mockApiGetChildrenMetadata(
            tautulliId: anyNamed('tautulliId'),
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => tChildrenMetadataInfoJson);
        // act
        final result = await dataSource.getChildrenMetadata(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          settingsBloc: settingsBloc,
        );
        // assert
        expect(result, equals(tChildrenMetadataList));
      },
    );
  });
}
