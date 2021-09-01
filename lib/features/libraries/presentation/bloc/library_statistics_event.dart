// @dart=2.9

part of 'library_statistics_bloc.dart';

abstract class LibraryStatisticsEvent extends Equatable {
  const LibraryStatisticsEvent();

  @override
  List<Object> get props => [];
}

class LibraryStatisticsFetch extends LibraryStatisticsEvent {
  final String tautulliId;
  final int sectionId;
  final SettingsBloc settingsBloc;

  LibraryStatisticsFetch({
    @required this.tautulliId,
    @required this.sectionId,
    @required this.settingsBloc,
  });

  @override
  List<Object> get props => [tautulliId, sectionId, settingsBloc];
}
