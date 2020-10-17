import 'package:equatable/equatable.dart';

class MetadataItem extends Equatable {
  final int grandparentRatingKey;
  final String grandparentThumb;
  final int parentRatingKey;
  final String parentThumb;
  final int ratingKey;
  final String thumb;

  MetadataItem({
    this.grandparentRatingKey,
    this.grandparentThumb,
    this.parentRatingKey,
    this.parentThumb,
    this.ratingKey,
    this.thumb,
  });

  @override
  List<Object> get props => [
        grandparentRatingKey,
        grandparentThumb,
        parentRatingKey,
        parentThumb,
        ratingKey,
        thumb,
      ];

  @override
  bool get stringify => true;
}
