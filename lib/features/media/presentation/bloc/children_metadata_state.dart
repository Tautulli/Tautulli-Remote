part of 'children_metadata_bloc.dart';

abstract class ChildrenMetadataState extends Equatable {
  const ChildrenMetadataState();

  @override
  List<Object> get props => [];
}

class ChildrenMetadataInitial extends ChildrenMetadataState {}

class ChildrenMetadataInProgress extends ChildrenMetadataState {}

class ChildrenMetadataSuccess extends ChildrenMetadataState {
  final List<MetadataItem> childrenMetadataList;

  ChildrenMetadataSuccess({
    @required this.childrenMetadataList,
  });

  @override
  List<Object> get props => [childrenMetadataList];
}

class ChildrenMetadataFailure extends ChildrenMetadataState {
  final Failure failure;
  final String message;
  final String suggestion;

  ChildrenMetadataFailure({
    @required this.failure,
    @required this.message,
    @required this.suggestion,
  });

  @override
  List<Object> get props => [failure, message, suggestion];
}
