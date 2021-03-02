part of 'announcements_bloc.dart';

abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();
}

class AnnouncementsFetch extends AnnouncementsEvent {
  @override
  List<Object> get props => [];
}

class AnnouncementsMarkRead extends AnnouncementsEvent {
  @override
  List<Object> get props => [];
}
