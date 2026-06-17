import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/custom_header_helper.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../data/models/custom_header_model.dart';

part 'registration_headers_event.dart';
part 'registration_headers_state.dart';

List<CustomHeaderModel> headerListCache = [];

class RegistrationHeadersBloc extends Bloc<RegistrationHeadersEvent, RegistrationHeadersState> {
  final Logging logging;

  RegistrationHeadersBloc({
    required this.logging,
  }) : super(RegistrationHeadersLoaded(headerListCache)) {
    on<RegistrationHeadersClear>(
      (event, emit) => _onRegistrationHeadersClear(event, emit),
    );
    on<RegistrationHeadersDelete>(
      (event, emit) => _onRegistrationHeadersDelete(event, emit),
    );
    on<RegistrationHeadersUpdate>(
      (event, emit) => _onRegistrationHeadersUpdate(event, emit),
    );
  }

  void _onRegistrationHeadersClear(
    RegistrationHeadersClear event,
    Emitter<RegistrationHeadersState> emit,
  ) {
    headerListCache = [];

    emit(
      const RegistrationHeadersLoaded([]),
    );
  }

  void _onRegistrationHeadersDelete(
    RegistrationHeadersDelete event,
    Emitter<RegistrationHeadersState> emit,
  ) {
    List<CustomHeaderModel> newList = [...headerListCache];

    newList.removeWhere((header) => header.key == event.title);

    logging.info("Registration :: Removed '${event.title}' header");

    headerListCache = [...newList];

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }

  void _onRegistrationHeadersUpdate(
    RegistrationHeadersUpdate event,
    Emitter<RegistrationHeadersState> emit,
  ) {
    final result = applyCustomHeaderUpdate(
      headers: headerListCache,
      basicAuth: event.basicAuth,
      title: event.title,
      subtitle: event.subtitle,
      previousTitle: event.previousTitle,
    );

    logging.info('Registration :: ${result.logMessage}');

    headerListCache = sortCustomHeaders(result.headers);

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }
}
