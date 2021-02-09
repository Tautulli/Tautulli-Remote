import 'package:equatable/equatable.dart';

class LibraryMedia extends Equatable {
  final int mediaIndex;
  final String mediaType;
  final int parentMediaIndex;
  final int ratingKey;
  final String thumb;
  final String title;
  final int year;
  String posterUrl;

  LibraryMedia({
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.ratingKey,
    this.thumb,
    this.title,
    this.year,
    this.posterUrl,
  });

  @override
  List<Object> get props => [
        mediaIndex,
        mediaType,
        parentMediaIndex,
        ratingKey,
        thumb,
        title,
        year,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
