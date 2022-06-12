part of 'recently_added_bloc.dart';

class RecentlyAddedState extends Equatable {
  final BlocStatus status;
  final MediaType? mediaType;
  final List<RecentlyAddedModel> recentlyAdded;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const RecentlyAddedState({
    this.status = BlocStatus.initial,
    this.mediaType,
    this.recentlyAdded = const [],
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  RecentlyAddedState copyWith({
    BlocStatus? status,
    MediaType? mediaType,
    List<RecentlyAddedModel>? recentlyAdded,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return RecentlyAddedState(
      status: status ?? this.status,
      mediaType: mediaType ?? this.mediaType,
      recentlyAdded: recentlyAdded ?? this.recentlyAdded,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, recentlyAdded, hasReachedMax];
}
