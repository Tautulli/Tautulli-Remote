import 'package:equatable/equatable.dart';

class Library extends Equatable {
  final String agent;
  final String art;
  final int childCount;
  final int count;
  final int isActive;
  final int parentCount;
  final int sectionId;
  final String sectionName;
  final String sectionType;
  final String thumb;
  String backgroundUrl;

  Library({
    this.agent,
    this.art,
    this.childCount,
    this.count,
    this.isActive,
    this.parentCount,
    this.sectionId,
    this.sectionName,
    this.sectionType,
    this.thumb,
    this.backgroundUrl
  });

  @override
  List<Object> get props => [
        agent,
        art,
        childCount,
        count,
        isActive,
        parentCount,
        sectionId,
        sectionName,
        sectionType,
        thumb,
        backgroundUrl,
      ];

  @override
  bool get stringify => true;
}
