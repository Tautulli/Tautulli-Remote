part of 'announcements_bloc.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();

  @override
  List<Object> get props => [];
}

class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementsInProgress extends AnnouncementsState {}

class AnnouncementsSuccess extends AnnouncementsState {
  final List<AnnouncementModel> announcementList;
  final List<AnnouncementModel> filteredList;
  final int lastReadAnnouncementId;
  final int maxId;
  final bool unread;

  const AnnouncementsSuccess({
    required this.announcementList,
    required this.filteredList,
    required this.lastReadAnnouncementId,
    required this.maxId,
    required this.unread,
  });

  AnnouncementsSuccess copyWith({
    List<AnnouncementModel>? announcementList,
    List<AnnouncementModel>? filteredList,
    int? lastReadAnnouncementId,
    int? maxId,
    bool? unread,
  }) {
    return AnnouncementsSuccess(
      announcementList: announcementList ?? this.announcementList,
      filteredList: filteredList ?? this.filteredList,
      lastReadAnnouncementId:
          lastReadAnnouncementId ?? this.lastReadAnnouncementId,
      maxId: maxId ?? this.maxId,
      unread: unread ?? this.unread,
    );
  }

  @override
  List<Object> get props => [
        announcementList,
        filteredList,
        lastReadAnnouncementId,
        maxId,
        unread,
      ];
}

class AnnouncementsFailure extends AnnouncementsState {
  final Failure failure;
  final String message;
  final String suggestion;

  const AnnouncementsFailure({
    required this.failure,
    required this.message,
    required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
