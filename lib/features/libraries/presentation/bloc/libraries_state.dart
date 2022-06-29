part of 'libraries_bloc.dart';

class LibrariesState extends Equatable {
  final BlocStatus status;
  final List<LibraryTableModel> libraries;
  final String orderColumn;
  final String orderDir;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final bool hasReachedMax;

  const LibrariesState({
    this.status = BlocStatus.initial,
    this.libraries = const [],
    this.orderColumn = 'section_name',
    this.orderDir = 'asc',
    this.failure,
    this.message,
    this.suggestion,
    this.hasReachedMax = false,
  });

  LibrariesState copyWith({
    BlocStatus? status,
    List<LibraryTableModel>? libraries,
    String? orderColumn,
    String? orderDir,
    Failure? failure,
    String? message,
    String? suggestion,
    bool? hasReachedMax,
  }) {
    return LibrariesState(
      status: status ?? this.status,
      libraries: libraries ?? this.libraries,
      orderColumn: orderColumn ?? this.orderColumn,
      orderDir: orderDir ?? this.orderDir,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        status,
        libraries,
        orderColumn,
        orderDir,
        hasReachedMax,
      ];
}
