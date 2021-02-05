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
    String backgroundUrl,
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
          mediaIndex: parentMediaIndex,
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
          backgroundUrl: backgroundUrl,
        );

  factory MetadataItemModel.fromJson(Map<String, dynamic> json) {
    final bool mediaInfoEmpty = json['media_info'].isEmpty;

    return MetadataItemModel(
      actors: json['actors'],
      art: json['art'],
      audioChannels: !mediaInfoEmpty
          ? int.tryParse(json['media_info'][0]['audio_channels'])
          : null,
      audioCodec: !mediaInfoEmpty ? json['media_info'][0]['audio_codec'] : null,
      contentRating: json['content_rating'],
      directors: json['directors'],
      duration: int.tryParse(json['duration']),
      genres: json['genres'],
      grandparentRatingKey: json['grandparent_rating_key'] != ''
          ? int.tryParse(json['grandparent_rating_key'])
          : null,
      grandparentThumb:
          json['grandparent_thumb'] != '' ? json['grandparent_thumb'] : null,
      grandparentTitle: json['grandparent_title'],
      mediaIndex: int.tryParse(json['media_index']),
      parentMediaIndex: int.tryParse(json['parent_media_index']),
      parentRatingKey: json['parent_rating_key'] != ''
          ? int.tryParse(json['parent_rating_key'])
          : null,
      parentThumb: json['parent_thumb'] != '' ? json['parent_thumb'] : null,
      parentTitle: json['parent_title'],
      rating: double.tryParse(json['rating']),
      ratingImage: json['rating_image'],
      ratingKey:
          json['rating_key'] != '' ? int.tryParse(json['rating_key']) : null,
      studio: json['studio'],
      summary: json['summary'],
      tagline: json['tagline'],
      title: json['title'],
      thumb: json['thumb'] != '' ? json['thumb'] : null,
      videoCodec: !mediaInfoEmpty ? json['media_info'][0]['video_codec'] : null,
      videoFullResolution: !mediaInfoEmpty &&
              json['media_info'][0]['video_full_resolution'] != 'p'
          ? json['media_info'][0]['video_full_resolution']
          : null,
      writers: json['writers'],
      year: int.tryParse(json['year']),
    );
  }
}
