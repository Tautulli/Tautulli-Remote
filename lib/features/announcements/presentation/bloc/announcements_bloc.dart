import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/device_info/device_info.dart';
import '../../../../core/error/failure.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../data/models/announcement_model.dart';
import '../../domain/usecases/announcements.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final Announcements announcements;
  final DeviceInfo deviceInfo;
  final Logging logging;
  final Settings settings;

  AnnouncementsBloc({
    required this.announcements,
    required this.deviceInfo,
    required this.logging,
    required this.settings,
  }) : super(AnnouncementsInitial()) {
    on<AnnouncementsFetch>((event, emit) => _onAnnouncementsFetch(event, emit));
    on<AnnouncementsMarkRead>(
      (event, emit) => _onAnnouncementsMarkRead(event, emit),
    );
  }

  _onAnnouncementsFetch(
    AnnouncementsFetch event,
    Emitter<AnnouncementsState> emit,
  ) async {
    emit(
      AnnouncementsInProgress(),
    );

    final lastReadAnnouncementId = settings.getLastReadAnnouncementId();

    final failureOrAnnouncements = await announcements.get();

    failureOrAnnouncements.fold(
      (failure) {
        logging.warning(
          'Announcements :: Failed to fetch announcements [$failure]',
        );
        emit(
          AnnouncementsFailure(
            failure: failure,
            message: LocaleKeys.announcements_load_failed_message.tr(),
            suggestion: '',
          ),
        );
      },
      (announcementList) {
        final filteredList = [...announcementList];

        if (deviceInfo.platform != 'android') {
          filteredList.removeWhere(
            (announcement) => announcement.platform == DevicePlatform.android,
          );
        } else if (deviceInfo.platform != 'ios') {
          filteredList.removeWhere(
            (announcement) => announcement.platform == DevicePlatform.ios,
          );
        }

        int maxId = 0;
        if (filteredList.isNotEmpty) {
          maxId = filteredList.map((e) => e.id).reduce(max);
        }

        emit(
          AnnouncementsSuccess(
            announcementList: announcementList,
            filteredList: filteredList,
            lastReadAnnouncementId: lastReadAnnouncementId,
            maxId: maxId,
            unread: maxId > lastReadAnnouncementId,
          ),
        );
      },
    );
  }

  _onAnnouncementsMarkRead(
    AnnouncementsMarkRead event,
    Emitter<AnnouncementsState> emit,
  ) async {
    if (state is AnnouncementsSuccess) {
      final currentState = state as AnnouncementsSuccess;

      await settings.setLastReadAnnouncementId(currentState.maxId);
      logging.info('Announcements :: Marked read');

      emit(
        currentState.copyWith(
          lastReadAnnouncementId: currentState.maxId,
          unread: false,
        ),
      );
    }
  }
}
