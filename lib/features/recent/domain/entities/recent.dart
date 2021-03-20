import 'package:equatable/equatable.dart';

class RecentItem extends Equatable {
  final int addedAt;
  final String art;
  final int childCount;
  final int grandparentRatingKey;
  final String grandparentThumb;
  final String grandparentTitle;
  final String libraryName;
  final int mediaIndex;
  final String mediaType;
  final int parentMediaIndex;
  final int parentRatingKey;
  final String parentThumb;
  final String parentTitle;
  final int ratingKey;
  final int sectionId;
  final String thumb;
  final String title;
  final int year;
  final String posterUrl;

  RecentItem({
    this.addedAt,
    this.art,
    this.childCount,
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.grandparentTitle,
    this.libraryName,
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.parentRatingKey,
    this.parentThumb,
    this.parentTitle,
    this.ratingKey,
    this.sectionId,
    this.thumb,
    this.title,
    this.year,
    this.posterUrl,
  });

  RecentItem copyWith({
    String posterUrl,
  }) {
    return RecentItem(
      addedAt: this.addedAt,
      art: this.art,
      childCount: this.childCount,
      grandparentRatingKey: this.grandparentRatingKey,
      grandparentThumb: this.grandparentThumb,
      grandparentTitle: this.grandparentTitle,
      libraryName: this.libraryName,
      mediaIndex: this.mediaIndex,
      mediaType: this.mediaType,
      parentMediaIndex: this.parentMediaIndex,
      parentRatingKey: this.parentRatingKey,
      parentThumb: this.parentThumb,
      parentTitle: this.parentTitle,
      ratingKey: this.ratingKey,
      sectionId: this.sectionId,
      thumb: this.thumb,
      title: this.title,
      year: this.year,
      posterUrl: posterUrl,
    );
  }

  @override
  List<Object> get props => [
        addedAt,
        art,
        childCount,
        grandparentRatingKey,
        grandparentThumb,
        grandparentTitle,
        libraryName,
        mediaIndex,
        mediaType,
        parentMediaIndex,
        parentRatingKey,
        parentThumb,
        parentTitle,
        ratingKey,
        sectionId,
        thumb,
        title,
        year,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
