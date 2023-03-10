part of 'library_media_bloc.dart';

abstract class LibraryMediaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LibraryMediaFetched extends LibraryMediaEvent {
  final ServerModel server;
  final int sectionId;
  final int? ratingKey;
  final SectionType? sectionType;
  final String? orderColumn;
  final String? orderDir;
  final int? start;
  final int? length;
  final String? search;
  final bool? refresh;
  final bool? fullRefresh;
  final SettingsBloc settingsBloc;

  LibraryMediaFetched({
    required this.server,
    required this.sectionId,
    this.ratingKey,
    this.sectionType,
    this.orderColumn,
    this.orderDir,
    this.start,
    this.length,
    this.search,
    this.refresh,
    this.fullRefresh,
    required this.settingsBloc,
  });

  @override
  List<Object> get props => [server, sectionId, settingsBloc];
}
