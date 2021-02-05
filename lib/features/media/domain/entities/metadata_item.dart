import 'package:equatable/equatable.dart';

class MetadataItem extends Equatable {
  final List actors;
  final String art;
  final int audioChannels;
  final String audioCodec;
  final String contentRating;
  final List directors;
  final int duration;
  final List genres;
  final int grandparentRatingKey;
  final String grandparentThumb;
  final String grandparentTitle;
  final int mediaIndex;
  final int parentMediaIndex;
  final int parentRatingKey;
  final String parentThumb;
  final String parentTitle;
  final double rating;
  final String ratingImage;
  final int ratingKey;
  final String studio;
  final String summary;
  final String tagline;
  final String title;
  final String thumb;
  final String videoCodec;
  final String videoFullResolution;
  final List writers;
  final int year;
  String posterUrl;
  String backgroundUrl;

  MetadataItem({
    this.actors,
    this.art,
    this.audioChannels,
    this.audioCodec,
    this.contentRating,
    this.directors,
    this.duration,
    this.genres,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.mediaIndex,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.rating,
    this.ratingImage,
    this.ratingKey,
    this.studio,
    this.summary,
    this.tagline,
    this.title,
    this.thumb,
    this.videoCodec,
    this.videoFullResolution,
    this.writers,
    this.year,
    this.posterUrl,
    this.backgroundUrl,
  });

  @override
  List<Object> get props => [
        actors,
        art,
        audioChannels,
        audioCodec,
        contentRating,
        directors,
        duration,
        genres,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        mediaIndex,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        rating,
        ratingImage,
        ratingKey,
        studio,
        summary,
        tagline,
        title,
        thumb,
        videoCodec,
        videoFullResolution,
        writers,
        year,
        posterUrl,
        backgroundUrl,
      ];

  @override
  bool get stringify => true;
}
