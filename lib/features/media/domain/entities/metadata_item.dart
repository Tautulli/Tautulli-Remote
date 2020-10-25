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
  final int parentRatingKey;
  final String parentThumb;
  final String parentTitle;
  final double rating;
  final String ratingImage;
  final int ratingKey;
  final String studio;
  final String summary;
  final String title;
  final String thumb;
  final String videoCodec;
  final int videoResolution;
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
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.rating,
    this.ratingImage,
    this.ratingKey,
    this.studio,
    this.summary,
    this.title,
    this.thumb,
    this.videoCodec,
    this.videoResolution,
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
        parentRatingKey,
        parentThumb,
        parentTitle,
        rating,
        ratingImage,
        ratingKey,
        studio,
        summary,
        title,
        thumb,
        videoCodec,
        videoResolution,
        writers,
        year,
        posterUrl,
        backgroundUrl,
      ];

  @override
  bool get stringify => true;
}
