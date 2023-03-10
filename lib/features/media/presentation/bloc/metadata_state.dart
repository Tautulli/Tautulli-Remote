part of 'metadata_bloc.dart';

class MetadataState extends Equatable {
  final BlocStatus status;
  final MediaModel? metadata;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const MetadataState({
    this.status = BlocStatus.initial,
    this.metadata,
    this.failure,
    this.message,
    this.suggestion,
  });

  MetadataState copyWith({
    BlocStatus? status,
    MediaModel? metadata,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return MetadataState(
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status];
}
