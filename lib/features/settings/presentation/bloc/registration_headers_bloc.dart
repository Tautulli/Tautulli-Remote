import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../widgets/custom_header_list_tile.dart';

part 'registration_headers_event.dart';
part 'registration_headers_state.dart';

List<CustomHeaderListTile> headerListCache = [];

class RegistrationHeadersBloc
    extends Bloc<RegistrationHeadersEvent, RegistrationHeadersState> {
  RegistrationHeadersBloc()
      : super(RegistrationHeadersLoaded(headerListCache)) {
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

    headerListCache = [...newList];

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }

  void _onRegistrationHeadersUpdate(
    RegistrationHeadersUpdate event,
    Emitter<RegistrationHeadersState> emit,
  ) {
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
            title: 'Authorization',
            subtitle: 'Basic $base64Value',
          ),
        );
      } else {
        newList[currentIndex] = CustomHeaderListTile(
          title: 'Authorization',
          subtitle: 'Basic $base64Value',
        );
      }
    } else {
      if (event.previousTitle != null) {
        final oldIndex = newList.indexWhere(
          (header) => header.title == event.previousTitle,
        );

        newList[oldIndex] = CustomHeaderListTile(
          title: event.title,
          subtitle: event.subtitle,
        );
      } else {
        final currentIndex = newList.indexWhere(
          (header) => header.title == event.title,
        );

        if (currentIndex == -1) {
          newList.add(
            CustomHeaderListTile(
              title: event.title,
              subtitle: event.subtitle,
            ),
          );
        } else {
          newList[currentIndex] = CustomHeaderListTile(
            title: event.title,
            subtitle: event.subtitle,
          );
        }
      }
    }

    newList.sort((a, b) => a.title.compareTo(b.title));

    headerListCache = [...newList];

    emit(
      RegistrationHeadersLoaded(headerListCache),
    );
  }
}
