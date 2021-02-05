import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/core/error/failure.dart';
import 'package:tautulli_remote/core/helpers/failure_mapper_helper.dart';
import 'package:tautulli_remote/features/media/data/models/metadata_item_model.dart';
import 'package:tautulli_remote/features/media/domain/usecases/get_metadata.dart';
import 'package:tautulli_remote/features/media/presentation/bloc/metadata_bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetMetadata extends Mock implements GetMetadata {}

void main() {
  MetadataBloc bloc;
  MockGetMetadata mockGetMetadata;

  setUp(() {
    mockGetMetadata = MockGetMetadata();

    bloc = MetadataBloc(
      getMetadata: mockGetMetadata,
    );
  });

  final tTautulliId = 'jkl';
  final tRatingKey = 123;

  final tMetadataJson = json.decode(fixture('metadata_item.json'));
  final tMetadataItem =
      MetadataItemModel.fromJson(tMetadataJson['response']['data']);

  void setUpSuccess() {
    when(
      mockGetMetadata(
        tautulliId: tTautulliId,
        ratingKey: anyNamed('ratingKey'),
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
        ));
        await untilCalled(
          mockGetMetadata(
            tautulliId: tTautulliId,
            ratingKey: anyNamed('ratingKey'),
          ),
        );
        // assert
        verify(mockGetMetadata(
          tautulliId: tTautulliId,
          ratingKey: anyNamed('ratingKey'),
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
          ),
        );
      },
    );
  });
}
