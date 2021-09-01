// @dart=2.9

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
  final String posterUrl;
  final String parentPosterUrl;
  final String grandparentPosterUrl;

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

  MetadataItem copyWith({
    String posterUrl,
    String parentPosterUrl,
    String grandparentPosterUrl,
  }) {
    return MetadataItem(
      actors: this.actors,
      art: this.art,
      audioChannels: this.audioChannels,
      audioCodec: this.audioCodec,
      bitrate: this.bitrate,
      childrenCount: this.childrenCount,
      container: this.container,
      contentRating: this.contentRating,
      directors: this.directors,
      duration: this.duration,
      fileSize: this.fileSize,
      genres: this.genres,
      grandparentRatingKey: this.grandparentRatingKey,
      grandparentThumb: this.grandparentThumb,
      grandparentTitle: this.grandparentTitle,
      maxYear: this.maxYear,
      mediaIndex: this.mediaIndex,
      mediaType: this.mediaType,
      minYear: this.minYear,
      originallyAvailableAt: this.originallyAvailableAt,
      parentMediaIndex: this.parentMediaIndex,
      parentRatingKey: this.parentRatingKey,
      parentThumb: this.parentThumb,
      parentTitle: this.parentTitle,
      playlistType: this.playlistType,
      rating: this.rating,
      ratingImage: this.ratingImage,
      ratingKey: this.ratingKey,
      studio: this.studio,
      subMediaType: this.subMediaType,
      summary: this.summary,
      tagline: this.tagline,
      title: this.title,
      thumb: this.thumb,
      videoCodec: this.videoCodec,
      videoFullResolution: this.videoFullResolution,
      writers: this.writers,
      year: this.year,
      posterUrl: posterUrl,
      parentPosterUrl: parentPosterUrl,
      grandparentPosterUrl: grandparentPosterUrl,
    );
  }

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
