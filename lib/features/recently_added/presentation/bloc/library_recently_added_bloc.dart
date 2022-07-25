import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'library_recently_added_event.dart';
part 'library_recently_added_state.dart';

class LibraryRecentlyAddedBloc extends Bloc<LibraryRecentlyAddedEvent, LibraryRecentlyAddedState> {
  LibraryRecentlyAddedBloc() : super(LibraryRecentlyAddedInitial()) {
    on<LibraryRecentlyAddedEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
