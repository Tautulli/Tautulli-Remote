part of 'recently_added_bloc.dart';

abstract class RecentlyAddedEvent extends Equatable {
  const RecentlyAddedEvent();
}

class RecentlyAddedFetched extends RecentlyAddedEvent {
  final String tautulliId;
  final String mediaType;

  RecentlyAddedFetched({
    @required this.tautulliId,
    @required this.mediaType,
  });

  @override
  List<Object> get props => [tautulliId, mediaType];
}

class RecentlyAddedFilter extends RecentlyAddedEvent {
  final String tautulliId;
  final String mediaType;

  RecentlyAddedFilter({
    @required this.tautulliId,
    @required this.mediaType,
  });

  @override
  List<Object> get props => [tautulliId, mediaType];
}
