import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/metadata_item.dart';

class MetadataItemModel extends MetadataItem {
  MetadataItemModel({
    final List actors,
    final String art,
    final int audioChannels,
    final String audioCodec,
    final String contentRating,
    final List directors,
    final int duration,
    final List genres,
    final int grandparentRatingKey,
    final String grandparentThumb,
    final String grandparentTitle,
    final int mediaIndex,
    final String mediaType,
    final int parentMediaIndex,
    final int parentRatingKey,
    final String parentThumb,
    final String parentTitle,
    final double rating,
    final String ratingImage,
    final int ratingKey,
    final String studio,
    final String summary,
    final String tagline,
    final String title,
    final String thumb,
    final String videoCodec,
    final String videoFullResolution,
    final List writers,
    final int year,
    String posterUrl,
  }) : super(
          actors: actors,
          art: art,
          audioChannels: audioChannels,
          audioCodec: audioCodec,
          contentRating: contentRating,
          directors: directors,
          duration: duration,
          genres: genres,
          grandparentRatingKey: grandparentRatingKey,
          grandparentThumb: grandparentThumb,
          grandparentTitle: grandparentTitle,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          parentMediaIndex: parentMediaIndex,
          parentRatingKey: parentRatingKey,
          parentThumb: parentThumb,
          parentTitle: parentTitle,
          rating: rating,
          ratingImage: ratingImage,
          ratingKey: ratingKey,
          studio: studio,
          summary: summary,
          tagline: tagline,
          title: title,
          thumb: thumb,
          videoCodec: videoCodec,
          videoFullResolution: videoFullResolution,
          writers: writers,
          year: year,
          posterUrl: posterUrl,
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
      mediaIndex: ValueHelper.cast(
        value: json['media_index'],
        type: CastType.int,
      ),
      mediaType: ValueHelper.cast(
        value: json['media_type'],
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
