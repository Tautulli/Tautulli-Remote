// @dart=2.9

part of 'cache_bloc.dart';

abstract class CacheEvent extends Equatable {
  const CacheEvent();
}

class CacheClear extends CacheEvent {
  @override
  List<Object> get props => [];
}
