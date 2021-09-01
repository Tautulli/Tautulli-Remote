// @dart=2.9

part of 'metadata_bloc.dart';

abstract class MetadataState extends Equatable {
  const MetadataState();

  @override
  List<Object> get props => [];
}

class MetadataInitial extends MetadataState {}

class MetadataInProgress extends MetadataState {}

class MetadataSuccess extends MetadataState {
  final MetadataItem metadata;

  MetadataSuccess({
    @required this.metadata,
  });

  @override
  List<Object> get props => [metadata];
}

class MetadataFailure extends MetadataState {
  final Failure failure;
  final String message;
  final String suggestion;

  MetadataFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
