// @dart=2.9

part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class HistoryFetch extends HistoryEvent {
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

  HistoryFetch({
    @required this.tautulliId,
    this.grouping,
    this.user,
    this.userId,
    this.ratingKey,
    this.parentRatingKey,
    this.grandparentRatingKey,
    this.startDate,
    this.sectionId,
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

class HistoryFilter extends HistoryEvent {
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

  HistoryFilter({
    @required this.tautulliId,
    this.grouping,
    this.user,
    this.userId,
    this.ratingKey,
    this.parentRatingKey,
    this.grandparentRatingKey,
    this.startDate,
    this.sectionId,
    this.mediaType,
    this.transcodeDecision,
    this.guid,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
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
      ];
}
