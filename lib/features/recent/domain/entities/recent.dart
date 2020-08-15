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
  String posterUrl;
  final int ratingKey;
  final int sectionId;
  final String thumb;
  final String title;
  final int year;

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
    this.posterUrl,
    this.ratingKey,
    this.sectionId,
    this.thumb,
    this.title,
    this.year,
  });

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
        posterUrl,
        ratingKey,
        sectionId,
        thumb,
        title,
        year,
      ];

  @override
  bool get stringify => true;
}
