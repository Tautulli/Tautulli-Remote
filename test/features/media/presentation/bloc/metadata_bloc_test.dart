import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/image_url/domain/usecases/get_image_url.dart';
import 'package:tautulli_remote/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_metadata.dart';
import 'package:tautulli_remote/features/media/presentation/bloc/metadata_bloc.dart';
import 'package:tautulli_remote/features/settings/domain/usecases/settings.dart';
import 'package:tautulli_remote/features/settings/presentation/bloc/settings_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetMetadata extends Mock implements GetMetadata {}

class MockGetImageUrl extends Mock implements GetImageUrl {}

class MockSettings extends Mock implements Settings {}

class MockLogging extends Mock implements Logging {}

void main() {
  MetadataBloc bloc;
  MockGetMetadata mockGetMetadata;
  MockGetImageUrl mockGetImageUrl;
  MockSettings mockSettings;
  MockLogging mockLogging;
  SettingsBloc settingsBloc;

  setUp(() {
    mockGetMetadata = MockGetMetadata();
    mockGetImageUrl = MockGetImageUrl();
    mockLogging = MockLogging();

    bloc = MetadataBloc(
      getMetadata: mockGetMetadata,
      getImageUrl: mockGetImageUrl,
      logging: mockLogging,
    );
    mockSettings = MockSettings();
    settingsBloc = SettingsBloc(
      settings: mockSettings,
      logging: mockLogging,
    );
  });

  final tTautulliId = 'jkl';
  final tRatingKey = 123;

  final tMetadataJson = json.decode(fixture('metadata_item.json'));
  final tMetadataItem =
      MetadataItemModel.fromJson(tMetadataJson['response']['data']);

  void setUpSuccess() {
    String imageUrl =
        'https://tautulli.domain.com/api/v2?img=/library/metadata/98329/thumb/1591948561&rating_key=98329&width=null&height=300&opacity=null&background=null&blur=null&fallback=poster&cmd=pms_image_proxy&apikey=3c9&app=true';
    when(
      mockGetImageUrl(
        tautulliId: anyNamed('tautulliId'),
        img: anyNamed('img'),
        ratingKey: anyNamed('ratingKey'),
        fallback: anyNamed('fallback'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(imageUrl));
    when(
      mockGetMetadata(
        tautulliId: tTautulliId,
        ratingKey: anyNamed('ratingKey'),
        settingsBloc: anyNamed('settingsBloc'),
      ),
    ).thenAnswer((_) async => Right(tMetadataItem));
  }

  test(
    'initialState should be MetadataInitial',
    () async {
      // assert
      expect(bloc.state, MetadataInitial());
    },
  );

  group('MetadataFetched', () {
    test(
      'should get data from GetMetadata use case',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // act
        bloc.add(MetadataFetched(
          tautulliId: tTautulliId,
          ratingKey: tRatingKey,
          settingsBloc: settingsBloc,
        ));
        await untilCalled(
          mockGetMetadata(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        );
        // assert
        verify(mockGetMetadata(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
          settingsBloc: anyNamed('settingsBloc'),
        ));
      },
    );

    test(
      'should emit [MetadataSuccess] when data is fetched successfully',
      () async {
        // arrange
        setUpSuccess();
        clearCache();
        // assert later
        final expected = [
          MetadataInProgress(),
          MetadataSuccess(metadata: tMetadataItem),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          MetadataFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );

    test(
      'should emit [MetadataFailure] when metadata comes back empty',
      () async {
        // arrange
        final failure = MetadataEmptyFailure();
        when(
          mockGetMetadata(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
            settingsBloc: anyNamed('settingsBloc'),
          ),
        ).thenAnswer((_) async => Left(failure));
        clearCache();
        // assert later
        final expected = [
          MetadataInProgress(),
          MetadataFailure(
            failure: failure,
            message: METADATA_EMPTY_FAILURE_MESSAGE,
            suggestion: METADATA_EMPTY_FAILURE_SUGGESTION,
          ),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(
          MetadataFetched(
            tautulliId: tTautulliId,
            ratingKey: tRatingKey,
            settingsBloc: settingsBloc,
          ),
        );
      },
    );
  });
}
