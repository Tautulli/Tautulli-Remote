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
      mediaIndex:
          json['media_index'] != '' ? int.tryParse(json['media_index']) : null,
      mediaType: json['media_type'] != '' ? json['media_type'] : null,
      parentMediaIndex: json['parent_media_index'] != ''
          ? int.tryParse(json['parent_media_index'])
          : null,
      ratingKey:
          json['rating_key'] != '' ? int.tryParse(json['rating_key']) : null,
      thumb: json['thumb'] != '' ? json['thumb'] : null,
      title: json['title'] != '' ? json['title'] : null,
      year: json['year'] != '' ? int.tryParse(json['year']) : null,
    );
  }
}
