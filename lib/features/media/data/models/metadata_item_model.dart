import '../../domain/entities/metadata_item.dart';

class MetadataItemModel extends MetadataItem {
  MetadataItemModel({
    int grandparentRatingKey,
    String grandparentThumb,
    int parentRatingKey,
    String parentThumb,
    int ratingKey,
    String thumb,
  }) : super(
          grandparentRatingKey: grandparentRatingKey,
          grandparentThumb: grandparentThumb,
          parentRatingKey: parentRatingKey,
          parentThumb: parentThumb,
          ratingKey: ratingKey,
          thumb: thumb,
        );

  factory MetadataItemModel.fromJson(Map<String, dynamic> json) {
    return MetadataItemModel(
      grandparentRatingKey: json['grandparent_rating_key'] != ''
          ? int.tryParse(json['grandparent_rating_key'])
          : null,
      grandparentThumb:
          json['grandparent_thumb'] != '' ? json['grandparent_thumb'] : null,
      parentRatingKey: json['parent_rating_key'] != ''
          ? int.tryParse(json['parent_rating_key'])
          : null,
      parentThumb: json['parent_thumb'] != '' ? json['parent_thumb'] : null,
      ratingKey:
          json['rating_key'] != '' ? int.tryParse(json['rating_key']) : null,
      thumb: json['thumb'] != '' ? json['thumb'] : null,
    );
  }
}
