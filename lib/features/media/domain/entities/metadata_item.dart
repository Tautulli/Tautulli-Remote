import 'package:equatable/equatable.dart';

class MetadataItem extends Equatable {
  final List actors;
  final String art;
  final int audioChannels;
  final String audioCodec;
  final int bitrate;
  final int childrenCount;
  final String container;
  final String contentRating;
  final List directors;
  final int duration;
  final int fileSize;
  final List genres;
  final int grandparentRatingKey;
  final String grandparentThumb;
  final String grandparentTitle;
  final int maxYear;
  final int mediaIndex;
  final String mediaType;
  final int minYear;
  final String originallyAvailableAt;
  final int parentMediaIndex;
  final int parentRatingKey;
  final String parentThumb;
  final String parentTitle;
  final String playlistType;
  final double rating;
  final String ratingImage;
  final int ratingKey;
  final String studio;
  final String subMediaType;
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
    this.childrenCount,
    this.container,
    this.contentRating,
    this.directors,
    this.duration,
    this.fileSize,
    this.genres,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.maxYear,
    this.mediaIndex,
    this.mediaType,
    this.minYear,
    this.originallyAvailableAt,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.playlistType,
    this.rating,
    this.ratingImage,
    this.ratingKey,
    this.studio,
    this.subMediaType,
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
        childrenCount,
        contentRating,
        directors,
        duration,
        genres,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        maxYear,
        mediaIndex,
        mediaType,
        minYear,
        originallyAvailableAt,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        playlistType,
        rating,
        ratingImage,
        ratingKey,
        studio,
        subMediaType,
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
