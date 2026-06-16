part of 'clear_tautulli_image_cache_bloc.dart';

abstract class ClearTautulliImageCacheEvent extends Equatable {
  const ClearTautulliImageCacheEvent();

  @override
  List<Object> get props => [];
}

class ClearTautulliImageCacheStart extends ClearTautulliImageCacheEvent {
  final ServerModel server;

  const ClearTautulliImageCacheStart({
    required this.server,
  });

  @override
  List<Object> get props => [server];
}
