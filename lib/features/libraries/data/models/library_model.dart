import '../../../../core/helpers/value_helper.dart';
import '../../domain/entities/library.dart';

class LibraryModel extends Library {
  LibraryModel({
    final int childCount,
    final int count,
    // final String contentRating,
    // final String doNotify,
    // final String doNotifiyCreated,
    final int duration,
    // final String guid,
    // final int historyRowId,
    final int isActive,
    // final String keepHistory,
    // final List labels,
    // final int lastAccessed,
    // final String lastPlayed,
    final String libraryArt,
    final String libraryThumb,
    // final int live,
    // final int mediaIndex,
    // final String mediaType,
    // final String originallyAvailableAt,
    final int parentCount,
    // final int parentMediaIndex,
    // final String parentTitle,
    final int plays,
    // final int ratingKey,
    // final int rowId,
    final int sectionId,
    final String sectionName,
    final String sectionType,
    // final String serverId,
    // final String thumb,
    // final int year,
    String iconUrl,
    String backgroundUrl,
  }) : super(
          childCount: childCount,
          count: count,
          // contentRating: contentRating,
          // doNotify: doNotify,
          // doNotifiyCreated: doNotifiyCreated,
          duration: duration,
          // guid: guid,
          // historyRowId: historyRowId,
          isActive: isActive,
          // keepHistory: keepHistory,
          // labels: labels,
          // lastAccessed: lastAccessed,
          // lastPlayed: lastPlayed,
          libraryArt: libraryArt,
          libraryThumb: libraryThumb,
          // live: live,
          // mediaIndex: mediaIndex,
          // mediaType: mediaType,
          // originallyAvailableAt: originallyAvailableAt,
          parentCount: parentCount,
          // parentMediaIndex: parentMediaIndex,
          // parentTitle: parentTitle,
          plays: plays,
          // ratingKey: ratingKey,
          // rowId: rowId,
          sectionId: sectionId,
          sectionName: sectionName,
          sectionType: sectionType,
          // serverId: serverId,
          // thumb: thumb,
          // year: year,
          iconUrl: iconUrl,
          backgroundUrl: backgroundUrl,
        );

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      childCount: ValueHelper.cast(
        value: json['child_count'],
        type: CastType.int,
      ),
      count: ValueHelper.cast(
        value: json['count'],
        type: CastType.int,
      ),
      duration: ValueHelper.cast(
        value: json['duration'],
        type: CastType.int,
      ),
      isActive: ValueHelper.cast(
        value: json['is_active'],
        type: CastType.int,
      ),
      libraryArt: ValueHelper.cast(
        value: json['library_art'],
        type: CastType.string,
      ),
      libraryThumb: ValueHelper.cast(
        value: json['library_thumb'],
        type: CastType.string,
      ),
      parentCount: ValueHelper.cast(
        value: json['parent_count'],
        type: CastType.int,
      ),
      plays: ValueHelper.cast(
        value: json['plays'],
        type: CastType.int,
      ),
      sectionId: ValueHelper.cast(
        value: json['section_id'],
        type: CastType.int,
      ),
      sectionName: ValueHelper.cast(
        value: json['section_name'],
        type: CastType.string,
      ),
      sectionType: ValueHelper.cast(
        value: json['section_type'],
        type: CastType.string,
      ),
    );
  }
}
