part of 'library_recently_added_bloc.dart';

class LibraryRecentlyAddedState extends Equatable {
  final BlocStatus status;
  final List<RecentlyAddedModel> recentlyAdded;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const LibraryRecentlyAddedState({
    this.status = BlocStatus.initial,
    this.recentlyAdded = const [],
    this.failure,
    this.message,
    this.suggestion,
  });

  LibraryRecentlyAddedState copyWith({
    BlocStatus? status,
    List<RecentlyAddedModel>? recentlyAdded,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return LibraryRecentlyAddedState(
      status: status ?? this.status,
      recentlyAdded: recentlyAdded ?? this.recentlyAdded,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status, recentlyAdded];
}
