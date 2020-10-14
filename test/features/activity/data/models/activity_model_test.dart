import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/features/activity/data/models/activity_model.dart';
import 'package:tautulli_remote/features/activity/domain/entities/activity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tActivityItemModel = ActivityItemModel(
    sessionKey: 10,
    sessionId: 'm8bbpxpywe6i91zib3hnfltz',
    art: "/library/metadata/79309/art/1560867619",
    audioChannelLayout: "5.1(side)",
    audioCodec: "eac3",
    bandwidth: "6478",
    channelCallSign: '',
    channelIdentifier: '',
    container: "mkv",
    duration: 2776450,
    friendlyName: "mock_friendly_name",
    grandparentRatingKey: 79309,
    grandparentThumb: '',
    grandparentTitle: "Catch-22",
    height: 1080,
    ipAddress: "mock_ip_address",
    live: 0,
    local: 1,
    location: "wan",
    mediaIndex: 2,
    mediaType: "episode",
    optimizedVersion: 0,
    optimizedVersionProfile: "",
    optimizedVersionTitle: "",
    originallyAvailableAt: '',
    parentMediaIndex: 1,
    parentRatingKey: 1,
    parentThumb: '',
    parentTitle: '',
    platformName: "chrome",
    product: "Plex Web",
    progressPercent: 11,
    qualityProfile: "Original",
    ratingKey: 79329,
    relayed: 0,
    secure: 1,
    state: "playing",
    streamAudioChannelLayout: "Stereo",
    streamAudioCodec: "aac",
    streamAudioDecision: "transcode",
    streamBitrate: 6574,
    streamContainer: "mp4",
    streamContainerDecision: "transcode",
    streamSubtitleCodec: "",
    streamSubtitleDecision: "",
    streamVideoCodec: "h264",
    streamVideoDecision: "copy",
    streamVideoDynamicRange: "SDR",
    streamVideoFullResolution: "1080p",
    subtitleCodec: "",
    subtitles: 0,
    syncedVersion: 0,
    syncedVersionProfile: "",
    thumb: '',
    title: "Episode 2",
    transcodeDecision: "transcode",
    transcodeHwDecoding: 0,
    transcodeHwEncoding: 0,
    transcodeProgress: 21,
    transcodeSpeed: 0.0,
    transcodeThrottled: 1,
    username: "mock_username",
    videoCodec: "h264",
    videoDynamicRange: "SDR",
    videoFullResolution: "1080p",
    viewOffset: 317000,
    width: 1920,
    year: 2019,
  );

  test('should be a subclass of ActivityItem entity', () async {
    //assert
    expect(tActivityItemModel, isA<ActivityItem>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('activity_item.json'));
        //act
        final result = ActivityItemModel.fromJson(jsonMap);
        //assert
        expect(result, tActivityItemModel);
      },
    );

    test(
      'should return an item with properly mapped data',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('activity_item.json'));
        // act
        final result = ActivityItemModel.fromJson(jsonMap);
        // assert
        expect(result.title, equals(jsonMap['title']));
      },
    );
  });
}
