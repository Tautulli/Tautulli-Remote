import 'package:equatable/equatable.dart';

class MetadataItem extends Equatable {
  final List actors;
  final String art;
  final int audioChannels;
  final String audioCodec;
  final int bitrate;
  final String container;
  final String contentRating;
  final List directors;
  final int duration;
  final int fileSize;
  final List genres;
  final int grandparentRatingKey;
  final String grandparentThumb;
  final String grandparentTitle;
  final int mediaIndex;
  final String mediaType;
  final String originallyAvailableAt;
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
  String parentPosterUrl;
  String grandparentPosterUrl;

  MetadataItem({
    this.actors,
    this.art,
    this.audioChannels,
    this.audioCodec,
    this.bitrate,
    this.container,
    this.contentRating,
    this.directors,
    this.duration,
    this.fileSize,
    this.genres,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.mediaIndex,
    this.mediaType,
    this.originallyAvailableAt,
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
    this.parentPosterUrl,
    this.grandparentPosterUrl,
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
        mediaType,
        originallyAvailableAt,
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
        parentPosterUrl,
        grandparentPosterUrl,
      ];

  @override
  bool get stringify => true;
}
