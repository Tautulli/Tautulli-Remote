part of 'library_statistics_bloc.dart';

class LibraryStatisticsState extends Equatable {
  final BlocStatus watchTimeStatsStatus;
  final BlocStatus userStatsStatus;
  final List<LibraryWatchTimeStatModel> watchTimeStatsList;
  final List<LibraryUserStatModel> userStatsList;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const LibraryStatisticsState({
    this.watchTimeStatsStatus = BlocStatus.initial,
    this.userStatsStatus = BlocStatus.initial,
    this.watchTimeStatsList = const [],
    this.userStatsList = const [],
    this.failure,
    this.message,
    this.suggestion,
  });

  LibraryStatisticsState copyWith({
    BlocStatus? watchTimeStatsStatus,
    BlocStatus? userStatsStatus,
    List<LibraryWatchTimeStatModel>? watchTimeStatsList,
    List<LibraryUserStatModel>? userStatsList,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return LibraryStatisticsState(
      watchTimeStatsStatus: watchTimeStatsStatus ?? this.watchTimeStatsStatus,
      userStatsStatus: userStatsStatus ?? this.userStatsStatus,
      watchTimeStatsList: watchTimeStatsList ?? this.watchTimeStatsList,
      userStatsList: userStatsList ?? this.userStatsList,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [watchTimeStatsStatus, userStatsStatus, watchTimeStatsList, userStatsList];
}
