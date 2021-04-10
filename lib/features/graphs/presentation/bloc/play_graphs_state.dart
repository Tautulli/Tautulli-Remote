part of 'play_graphs_bloc.dart';

abstract class PlayGraphsState extends Equatable {
  const PlayGraphsState();
}

class PlayGraphsInitial extends PlayGraphsState {
  @override
  List<Object> get props => [];
}

class PlayGraphsInProgress extends PlayGraphsState {
  @override
  List<Object> get props => [];
}

class PlayGraphsSuccess extends PlayGraphsState {
  final GraphData playsByDate;
  final DateTime lastLoaded;

  PlayGraphsSuccess({
    @required this.playsByDate,
    @required this.lastLoaded,
  });

  PlayGraphsSuccess copyWith({
    GraphData playsByDate,
    @required DateTime lastLoaded,
  }) {
    return PlayGraphsSuccess(
      playsByDate: playsByDate ?? this.playsByDate,
      lastLoaded: lastLoaded,
    );
  }

  @override
  List<Object> get props => [playsByDate, lastLoaded];
}

class PlayGraphsFailure extends PlayGraphsState {
  final Failure failure;
  final String message;
  final String suggestion;

  PlayGraphsFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
