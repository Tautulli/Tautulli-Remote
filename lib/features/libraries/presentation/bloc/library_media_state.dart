part of 'library_media_bloc.dart';

class LibraryMediaState extends Equatable {
  final BlocStatus status;
  final List<LibraryMediaInfoModel> libraryItems;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const LibraryMediaState({
    this.status = BlocStatus.initial,
    this.libraryItems = const [],
    this.failure,
    this.message,
    this.suggestion,
  });

  LibraryMediaState copyWith({
    BlocStatus? status,
    List<LibraryMediaInfoModel>? libraryItems,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return LibraryMediaState(
      status: status ?? this.status,
      libraryItems: libraryItems ?? this.libraryItems,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object> get props => [status, libraryItems];
}
