import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../../domain/usecases/clear_cache.dart';

part 'cache_event.dart';
part 'cache_state.dart';

class CacheBloc extends Bloc<CacheEvent, CacheState> {
  final ClearCache clearCache;
  final Logging logging;

  CacheBloc({
    @required this.clearCache,
    @required this.logging,
  }) : super(CacheInitial());

  @override
  Stream<CacheState> mapEventToState(
    CacheEvent event,
  ) async* {
    if (event is CacheClear) {
      yield CacheInProgress();

      await clearCache();
      logging.info('Settings: Cleared image cache');

      yield CacheSuccess();
    }
  }
}
