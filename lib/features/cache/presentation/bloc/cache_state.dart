// @dart=2.9

part of 'cache_bloc.dart';

abstract class CacheState extends Equatable {
  const CacheState();
}

class CacheInitial extends CacheState {
  @override
  List<Object> get props => [];
}

class CacheInProgress extends CacheState {
  @override
  List<Object> get props => [];
}

class CacheSuccess extends CacheState {
  @override
  List<Object> get props => [];
}
