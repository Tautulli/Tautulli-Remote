// @dart=2.9

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/custom_header_model.dart';

part 'register_device_headers_event.dart';
part 'register_device_headers_state.dart';

List<CustomHeaderModel> headerList = [];

class RegisterDeviceHeadersBloc
    extends Bloc<RegisterDeviceHeadersEvent, RegisterDeviceHeadersState> {
  RegisterDeviceHeadersBloc() : super(RegisterDeviceHeadersInitial());

  @override
  Stream<RegisterDeviceHeadersState> mapEventToState(
    RegisterDeviceHeadersEvent event,
  ) async* {
    if (event is RegisterDeviceHeadersAdd) {
      List<CustomHeaderModel> newList = [...headerList];

      if (event.basicAuth) {
        final currentIndex = newList.indexWhere(
          (header) => header.key == 'Authorization',
        );

        final String base64Value =
            base64Encode(utf8.encode('${event.key}:${event.value}'));

        if (currentIndex == -1) {
          newList.add(
            CustomHeaderModel(
              key: 'Authorization',
              value: 'Basic $base64Value',
            ),
          );
        } else {
          newList[currentIndex] = CustomHeaderModel(
            key: 'Authorization',
            value: 'Basic $base64Value',
          );
        }
      } else {
        if (event.previousKey != null) {
          final oldIndex = newList.indexWhere(
            (header) => header.key == event.previousKey,
          );

          newList[oldIndex] = CustomHeaderModel(
            key: event.key,
            value: event.value,
          );
        } else {
          final currentIndex = newList.indexWhere(
            (header) => header.key == event.key,
          );

          if (currentIndex == -1) {
            newList.add(
              CustomHeaderModel(
                key: event.key,
                value: event.value,
              ),
            );
          } else {
            newList[currentIndex] = CustomHeaderModel(
              key: event.key,
              value: event.value,
            );
          }
        }
      }

      newList.sort((a, b) => a.key.compareTo(b.key));

      headerList = [...newList];

      yield RegisterDeviceHeadersLoaded(newList);
    }
    if (event is RegisterDeviceHeadersRemove) {
      List<CustomHeaderModel> newList = [...headerList];

      newList.removeWhere((header) => header.key == event.key);

      headerList = [...newList];

      yield RegisterDeviceHeadersLoaded(newList);
    }
    if (event is RegisterDeviceHeadersClear) {
      headerList = [];

      yield RegisterDeviceHeadersLoaded(const []);
    }
  }
}
