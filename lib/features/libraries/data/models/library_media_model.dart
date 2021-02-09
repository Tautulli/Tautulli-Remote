import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/library_media.dart';

class LibraryMediaModel extends LibraryMedia {
  LibraryMediaModel({
    final int mediaIndex,
    final String mediaType,
    final int parentMediaIndex,
    final int ratingKey,
    final String thumb,
    final String title,
    final int year,
    String posterUrl,
  }) : super(
          mediaIndex: mediaIndex,
          mediaType: mediaType,
          parentMediaIndex: parentMediaIndex,
          ratingKey: ratingKey,
          thumb: thumb,
          title: title,
          year: year,
          posterUrl: posterUrl,
        );

  factory LibraryMediaModel.fromJson(Map<String, dynamic> json) {
    return LibraryMediaModel(
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
      ratingKey: ValueHelper.cast(
        value: json['rating_key'],
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
