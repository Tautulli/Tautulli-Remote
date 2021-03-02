part of 'announcements_bloc.dart';

abstract class AnnouncementsState extends Equatable {
  const AnnouncementsState();
}

class AnnouncementsInitial extends AnnouncementsState {
  @override
  List<Object> get props => [];
}

class AnnouncementsInProgress extends AnnouncementsState {
  @override
  List<Object> get props => [];
}

class AnnouncementsSuccess extends AnnouncementsState {
  final List<Announcement> announcementList;
  final int lastReadAnnouncementId;
  final bool unread;

  AnnouncementsSuccess({
    @required this.announcementList,
    @required this.lastReadAnnouncementId,
    @required this.unread,
  });

  AnnouncementsSuccess copyWith({
    List<Announcement> announcementList,
    int lastReadAnnouncementId,
    bool unread,
  }) {
    return AnnouncementsSuccess(
      announcementList: announcementList ?? this.announcementList,
      lastReadAnnouncementId:
          lastReadAnnouncementId ?? this.lastReadAnnouncementId,
      unread: unread ?? this.unread,
    );
  }

  @override
  List<Object> get props => [announcementList, lastReadAnnouncementId, unread];
}

class AnnouncementsFailure extends AnnouncementsState {
  final Failure failure;
  final String message;
  final String suggestion;

  AnnouncementsFailure({
    @required this.failure,
    @required this.message,
    this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
