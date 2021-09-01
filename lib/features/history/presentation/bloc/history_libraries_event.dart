// @dart=2.9

part of 'history_libraries_bloc.dart';

abstract class HistoryLibrariesEvent extends Equatable {
  const HistoryLibrariesEvent();

  @override
  List<Object> get props => [];
}

class HistoryLibrariesFetch extends HistoryLibrariesEvent {
  final String tautulliId;
  final int grouping;
  final String user;
  final int userId;
  final int ratingKey;
  final int parentRatingKey;
  final int grandparentRatingKey;
  final String startDate;
  final int sectionId;
  final String mediaType;
  final String transcodeDecision;
  final String guid;
  final String orderColumn;
  final String orderDir;
  final int start;
  final int length;
  final String search;
  final SettingsBloc settingsBloc;

  HistoryLibrariesFetch({
    @required this.tautulliId,
    this.grouping,
    this.user,
    this.userId,
    this.ratingKey,
    this.parentRatingKey,
    this.grandparentRatingKey,
    this.startDate,
    @required this.sectionId,
    this.mediaType,
    this.transcodeDecision,
    this.guid,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [
        tautulliId,
        grouping,
        user,
        userId,
        ratingKey,
        parentRatingKey,
        grandparentRatingKey,
        startDate,
        sectionId,
        mediaType,
        transcodeDecision,
        guid,
        orderColumn,
        orderDir,
        start,
        length,
        search,
        settingsBloc,
      ];
}
