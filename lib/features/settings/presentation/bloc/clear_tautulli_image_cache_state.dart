part of 'clear_tautulli_image_cache_bloc.dart';

class ClearTautulliImageCacheState extends Equatable {
  final BlocStatus status;
  final ServerModel? server;

  const ClearTautulliImageCacheState({
    this.status = BlocStatus.initial,
    this.server,
  });

  ClearTautulliImageCacheState copyWith({
    BlocStatus? status,
    ServerModel? server,
  }) {
    return ClearTautulliImageCacheState(
      status: status ?? this.status,
      server: server ?? this.server,
    );
  }

  @override
  List<Object> get props => [status];
}
