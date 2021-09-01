// @dart=2.9

part of 'library_statistics_bloc.dart';

abstract class LibraryStatisticsState extends Equatable {
  const LibraryStatisticsState();

  @override
  List<Object> get props => [];
}

class LibraryStatisticsInitial extends LibraryStatisticsState {}

class LibraryStatisticsInProgress extends LibraryStatisticsState {}

class LibraryStatisticsSuccess extends LibraryStatisticsState {
  final List<LibraryStatistic> watchTimeStatsList;
  final List<LibraryStatistic> userStatsList;

  LibraryStatisticsSuccess({
    @required this.watchTimeStatsList,
    @required this.userStatsList,
  });

  @override
  List<Object> get props => [watchTimeStatsList, userStatsList];
}

class LibraryStatisticsFailure extends LibraryStatisticsState {
  final Failure failure;
  final String message;
  final String suggestion;

  LibraryStatisticsFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
