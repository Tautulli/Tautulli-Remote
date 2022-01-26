import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onesignal_event.dart';
part 'onesignal_state.dart';

class OnesignalBloc extends Bloc<OnesignalEvent, OnesignalState> {
  OnesignalBloc() : super(OnesignalInitial()) {
    on<OnesignalEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
