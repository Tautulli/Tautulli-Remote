part of 'announcements_bloc.dart';

abstract class AnnouncementsEvent extends Equatable {
  const AnnouncementsEvent();

  @override
  List<Object> get props => [];
}

class AnnouncementsFetch extends AnnouncementsEvent {}

class AnnouncementsMarkRead extends AnnouncementsEvent {}
