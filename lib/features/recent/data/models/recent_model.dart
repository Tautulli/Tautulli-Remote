import '../../domain/entities/recent.dart';

class RecentItemModel extends RecentItem {
  RecentItemModel({
    final int addedAt,
    final String art,
    final int childCount,
    final int grandparentRatingKey,
    final String grandparentThumb,
    final String grandparentTitle,
    final String libraryName,
    final int mediaIndex,
    final String mediaType,
    final int parentMediaIndex,
    final int parentRatingKey,
    final String parentThumb,
    final String parentTitle,
    String posterUrl,
    final int ratingKey,
    final int sectionId,
    final String thumb,
    final String title,
    final int year,
  }) : super(
          addedAt: addedAt,
          art: art,
          childCount: childCount,
          grandparentRatingKey: grandparentRatingKey,
          grandparentThumb: grandparentThumb,
          grandparentTitle: grandparentTitle,
          libraryName: libraryName,
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          parentMediaIndex: parentMediaIndex,
          parentRatingKey: parentRatingKey,
          parentThumb: parentThumb,
          parentTitle: parentTitle,
          posterUrl: posterUrl,
          ratingKey: ratingKey,
          sectionId: sectionId,
          thumb: thumb,
          title: title,
          year: year,
        );

  factory RecentItemModel.fromJson(Map<String, dynamic> json) {
    return RecentItemModel(
      addedAt: int.parse(json['added_at']),
      art: json['art'],
      childCount: int.tryParse(json['child_count']),
      grandparentRatingKey: int.tryParse(json['grandparent_rating_key']),
      grandparentThumb: json['grandparent_thumb'],
      grandparentTitle: json['grandparent_title'],
      libraryName: json['library_name'],
      mediaIndex: int.tryParse(json['media_index']),
      mediaType: json['media_type'],
      parentMediaIndex: int.tryParse(json['parent_media_index']),
      parentRatingKey: int.tryParse(json['parent_rating_key']),
      parentThumb: json['parent_thumb'],
      parentTitle: json['parent_title'],
      ratingKey: int.tryParse(json['rating_key']),
      sectionId: int.tryParse(json['section_id']),
      thumb: json['thumb'],
      title: json['title'],
      year: int.tryParse(json['year']),
    );
  }
}