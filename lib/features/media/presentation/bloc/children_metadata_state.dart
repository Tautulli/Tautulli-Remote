part of 'children_metadata_bloc.dart';

class ChildrenMetadataState extends Equatable {
  final BlocStatus status;
  final List<MediaModel>? children;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const ChildrenMetadataState({
    this.status = BlocStatus.initial,
    this.children,
    this.failure,
    this.message,
    this.suggestion,
  });

  ChildrenMetadataState copyWith({
    BlocStatus? status,
    List<MediaModel>? children,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return ChildrenMetadataState(
      status: status ?? this.status,
      children: children ?? this.children,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status];
}
