import '../../domain/entities/library.dart';

class LibraryModel extends Library {
  LibraryModel({
    final String agent,
    final String art,
    final int childCount,
    final int count,
    final int isActive,
    final int parentCount,
    final int sectionId,
    final String sectionName,
    final String sectionType,
    final String thumb,
    String backgroundUrl,
  }) : super(
          agent: agent,
          art: art,
          childCount: childCount,
          count: count,
          isActive: isActive,
          parentCount: parentCount,
          sectionId: sectionId,
          sectionName: sectionName,
          sectionType: sectionType,
          thumb: thumb,
          backgroundUrl: backgroundUrl,
        );

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      agent: json['agent'],
      art: json['art'],
      childCount: json.containsKey('child_count')
          ? int.tryParse(json['child_count'])
          : null,
      count: int.tryParse(json['count']),
      isActive: json['is_active'],
      parentCount: json.containsKey('parent_count')
          ? int.tryParse(json['parent_count'])
          : null,
      sectionId: int.tryParse(json['section_id']),
      sectionName: json['section_name'],
      sectionType: json['section_type'],
      thumb: json['thumb'],
    );
  }
}
