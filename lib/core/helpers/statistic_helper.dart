import '../../features/media/data/models/media_model.dart';
import '../../features/statistics/data/models/statistic_data_model.dart';
import '../types/media_type.dart';

MediaType? normalizeStatisticMediaType(MediaType? mediaType) {
  switch (mediaType) {
    case MediaType.album:
    case MediaType.track:
      return MediaType.artist;
    case MediaType.episode:
    case MediaType.season:
      return MediaType.show;
    default:
      return mediaType;
  }
}

MediaModel buildMediaModelFromStatistic(
  StatisticDataModel statData, {
  MediaType? mediaTypeOverride,
}) {
  return MediaModel(
    grandparentRatingKey: statData.grandparentRatingKey,
    grandparentTitle: statData.grandparentTitle,
    imageUri: statData.posterUri,
    mediaIndex: statData.mediaIndex,
    mediaType: mediaTypeOverride ?? statData.mediaType,
    parentMediaIndex: statData.parentMediaIndex,
    ratingKey: statData.ratingKey,
    title: statData.title,
    year: statData.year,
  );
}
