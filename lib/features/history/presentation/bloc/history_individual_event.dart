part of 'history_individual_bloc.dart';

abstract class HistoryIndividualEvent extends Equatable {
  const HistoryIndividualEvent();

  @override
  List<Object> get props => [];
}

class HistoryIndividualFetch extends HistoryIndividualEvent {
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

  HistoryIndividualFetch({
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
