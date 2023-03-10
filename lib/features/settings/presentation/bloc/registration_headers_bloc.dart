import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../logging/domain/usecases/logging.dart';
import '../widgets/list_tiles/custom_header_list_tile.dart';

part 'registration_headers_event.dart';
part 'registration_headers_state.dart';

List<CustomHeaderListTile> headerListCache = [];

class RegistrationHeadersBloc
    extends Bloc<RegistrationHeadersEvent, RegistrationHeadersState> {
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
    List<CustomHeaderListTile> newList = [...headerListCache];

    newList.removeWhere((header) => header.title == event.title);

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
    String loggingMessage =
        'Registration :: Header changed but logging missed it';
    List<CustomHeaderListTile> newList = [...headerListCache];

    if (event.basicAuth) {
      final currentIndex = newList.indexWhere(
        (header) => header.title == 'Authorization',
      );

      final String base64Value = base64Encode(
        utf8.encode('${event.title}:${event.subtitle}'),
      );

      if (currentIndex == -1) {
        newList.add(
          CustomHeaderListTile(
            forRegistration: true,
            title: 'Authorization',
            subtitle: 'Basic $base64Value',
          ),
        );

        loggingMessage = "Registration :: Added 'Authorization' header";
      } else {
        newList[currentIndex] = CustomHeaderListTile(
          forRegistration: true,
          title: 'Authorization',
          subtitle: 'Basic $base64Value',
        );

        loggingMessage = "Registration :: Updated 'Authorization' header";
      }
    } else {
      if (event.previousTitle != null) {
        final oldIndex = newList.indexWhere(
          (header) => header.title == event.previousTitle,
        );

        newList[oldIndex] = CustomHeaderListTile(
          forRegistration: true,
          title: event.title,
          subtitle: event.subtitle,
        );

        if (event.previousTitle != event.title) {
          loggingMessage =
              "Registration :: Replaced '${event.previousTitle}' header with '${event.title}'";
        } else {
          loggingMessage = "Registration :: Updated '${event.title}' header'";
        }
      } else {
        // No previous title means a new header is being added. We need to
        // check and make sure we don't end up with headers that have duplicate
        // keys/titles
        final currentIndex = newList.indexWhere(
          (header) => header.title == event.title,
        );

        if (currentIndex == -1) {
          newList.add(
            CustomHeaderListTile(
              forRegistration: true,
              title: event.title,
              subtitle: event.subtitle,
            ),
          );

          loggingMessage = "Registration :: Added '${event.title}' header";
        } else {
          newList[currentIndex] = CustomHeaderListTile(
            forRegistration: true,
            title: event.title,
            subtitle: event.subtitle,
          );

          loggingMessage = "Registration :: Updated '${event.title}' header";
        }
      }
    }

    logging.info(loggingMessage);

    // Sort headers and make sure Authorization is first
    newList.sort((a, b) => a.title.compareTo(b.title));
    final index = newList.indexWhere(
      (element) => element.title == 'Authorization',
    );
    if (index != -1) {
      final authHeader = newList.removeAt(index);
      newList.insert(0, authHeader);
    }

    headerListCache = [...newList];

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }
}
