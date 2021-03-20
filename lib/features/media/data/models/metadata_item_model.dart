import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/metadata_item.dart';

class MetadataItemModel extends MetadataItem {
  MetadataItemModel({
    final List actors,
    final String art,
    final int audioChannels,
    final String audioCodec,
    final int bitrate,
    final int childrenCount,
    final String container,
    final String contentRating,
    final List directors,
    final int duration,
    final int fileSize,
    final List genres,
    final int grandparentRatingKey,
    final String grandparentThumb,
    final String grandparentTitle,
    final int maxYear,
    final int mediaIndex,
    final String mediaType,
    final int minYear,
    final String originallyAvailableAt,
    final int parentMediaIndex,
    final int parentRatingKey,
    final String parentThumb,
    final String parentTitle,
    final String playlistType,
    final double rating,
    final String ratingImage,
    final int ratingKey,
    final String studio,
    final String subMediaType,
    final String summary,
    final String tagline,
    final String title,
    final String thumb,
    final String videoCodec,
    final String videoFullResolution,
    final List writers,
    final int year,
    final String posterUrl,
    final String parentPosterUrl,
    final String grandparentPosterUrl,
  }) : super(
          actors: actors,
          art: art,
          audioChannels: audioChannels,
          audioCodec: audioCodec,
          bitrate: bitrate,
          childrenCount: childrenCount,
          container: container,
          contentRating: contentRating,
          directors: directors,
          duration: duration,
          fileSize: fileSize,
          genres: genres,
          grandparentRatingKey: grandparentRatingKey,
          grandparentThumb: grandparentThumb,
          grandparentTitle: grandparentTitle,
          maxYear: maxYear,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          minYear: minYear,
          originallyAvailableAt: originallyAvailableAt,
          parentMediaIndex: parentMediaIndex,
          parentRatingKey: parentRatingKey,
          parentThumb: parentThumb,
          parentTitle: parentTitle,
          playlistType: playlistType,
          rating: rating,
          ratingImage: ratingImage,
          ratingKey: ratingKey,
          studio: studio,
          subMediaType: subMediaType,
          summary: summary,
          tagline: tagline,
          title: title,
          thumb: thumb,
          videoCodec: videoCodec,
          videoFullResolution: videoFullResolution,
          writers: writers,
          year: year,
          posterUrl: posterUrl,
          parentPosterUrl: parentPosterUrl,
          grandparentPosterUrl: grandparentPosterUrl,
        );

  factory MetadataItemModel.fromJson(Map<String, dynamic> json) {
    final bool mediaInfoEmpty =
        !json.containsKey('media_info') || json['media_info'].isEmpty;

    return MetadataItemModel(
      actors: json['actors'],
      art: ValueHelper.cast(
        value: json['art'],
        type: CastType.string,
      ),
      audioChannels: !mediaInfoEmpty
          ? ValueHelper.cast(
              value: json['media_info'][0]['audio_channels'],
              type: CastType.int,
            )
          : null,
      audioCodec: !mediaInfoEmpty
          ? ValueHelper.cast(
              value: json['media_info'][0]['audio_codec'],
              type: CastType.string,
            )
          : null,
      bitrate: !mediaInfoEmpty
          ? ValueHelper.cast(
              value: json['media_info'][0]['bitrate'],
              type: CastType.int,
            )
          : null,
      childrenCount: ValueHelper.cast(
        value: json['children_count'],
        type: CastType.int,
      ),
      container: !mediaInfoEmpty
          ? ValueHelper.cast(
              value: json['media_info'][0]['container'],
              type: CastType.string,
            )
          : null,
      contentRating: ValueHelper.cast(
        value: json['content_rating'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      directors: json['directors'],
      duration: ValueHelper.cast(
        value: json['duration'],
        type: CastType.int,
      ),
      fileSize: !mediaInfoEmpty
          ? ValueHelper.cast(
              value: json['media_info'][0]['parts'][0]['file_size'],
              type: CastType.int,
            )
          : null,
      genres: json['genres'],
      grandparentRatingKey: ValueHelper.cast(
        value: json['grandparent_rating_key'],
        type: CastType.int,
      ),
      grandparentThumb: ValueHelper.cast(
        value: json['grandparent_thumb'],
        type: CastType.string,
      ),
      grandparentTitle: ValueHelper.cast(
        value: json['grandparent_title'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      maxYear: ValueHelper.cast(
        value: json['max_year'],
        type: CastType.int,
      ),
      mediaIndex: ValueHelper.cast(
        value: json['media_index'],
        type: CastType.int,
      ),
      mediaType: ValueHelper.cast(
        value: json['media_type'],
        type: CastType.string,
      ),
      minYear: ValueHelper.cast(
        value: json['min_year'],
        type: CastType.int,
      ),
      originallyAvailableAt: ValueHelper.cast(
        value: json['originally_available_at'],
        type: CastType.string,
      ),
      parentMediaIndex: ValueHelper.cast(
        value: json['parent_media_index'],
        type: CastType.int,
      ),
      parentRatingKey: ValueHelper.cast(
        value: json['parent_rating_key'],
        type: CastType.int,
      ),
      parentThumb: ValueHelper.cast(
        value: json['parent_thumb'],
        type: CastType.string,
      ),
      parentTitle: ValueHelper.cast(
        value: json['parent_title'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      playlistType: ValueHelper.cast(
        value: json['playlist_type'],
        type: CastType.string,
      ),
      rating: ValueHelper.cast(
        value: json['rating'],
        type: CastType.double,
      ),
      ratingImage: ValueHelper.cast(
        value: json['rating_image'],
        type: CastType.string,
      ),
      ratingKey: ValueHelper.cast(
        value: json['rating_key'],
        type: CastType.int,
      ),
      studio: ValueHelper.cast(
        value: json['studio'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      subMediaType: ValueHelper.cast(
        value: json['sub_media_type'],
        type: CastType.string,
      ),
      summary: ValueHelper.cast(
        value: json['summary'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      tagline: ValueHelper.cast(
        value: json['tagline'],
        type: CastType.string,
        nullEmptyString: false,
      ),
      title: ValueHelper.cast(
        value: json['title'],
        type: CastType.string,
      ),
      thumb: ValueHelper.cast(
        value: json['thumb'],
        type: CastType.string,
      ),
      videoCodec: !mediaInfoEmpty
          ? ValueHelper.cast(
              value: json['media_info'][0]['video_codec'],
              type: CastType.string,
            )
          : null,
      videoFullResolution: !mediaInfoEmpty &&
              json['media_info'][0]['video_full_resolution'] != 'p'
          ? ValueHelper.cast(
              value: json['media_info'][0]['video_full_resolution'],
              type: CastType.string,
            )
          : null,
      writers: json['writers'],
      year: ValueHelper.cast(
        value: json['year'],
        type: CastType.int,
      ),
    );
  }
}
