import '../../../../core/helpers/value_helper.dart';
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
    final int ratingKey,
    final int sectionId,
    final String thumb,
    final String title,
    final int year,
    final String posterUrl,
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
          ratingKey: ratingKey,
          sectionId: sectionId,
          thumb: thumb,
          title: title,
          year: year,
          posterUrl: posterUrl,
        );

  factory RecentItemModel.fromJson(Map<String, dynamic> json) {
    return RecentItemModel(
      addedAt: ValueHelper.cast(
        value: json['added_at'],
        type: CastType.int,
      ),
      art: ValueHelper.cast(
        value: json['art'],
        type: CastType.string,
      ),
      childCount: ValueHelper.cast(
        value: json['child_count'],
        type: CastType.int,
      ),
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
      ),
      libraryName: ValueHelper.cast(
        value: json['library_name'],
        type: CastType.string,
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
      ),
      ratingKey: ValueHelper.cast(
        value: json['rating_key'],
        type: CastType.int,
      ),
      sectionId: ValueHelper.cast(
        value: json['section_id'],
        type: CastType.int,
      ),
      thumb: ValueHelper.cast(
        value: json['thumb'],
        type: CastType.string,
      ),
      title: ValueHelper.cast(
        value: json['title'],
        type: CastType.string,
      ),
      year: ValueHelper.cast(
        value: json['year'],
        type: CastType.int,
      ),
    );
  }
}
