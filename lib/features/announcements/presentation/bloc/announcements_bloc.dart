// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../injection_container.dart' as di;
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/domain/usecases/settings.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/usecases/get_announcements.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final GetAnnouncements getAnnouncements;
  final Logging logging;

  AnnouncementsBloc({
    @required this.getAnnouncements,
    @required this.logging,
  }) : super(AnnouncementsInitial());

  @override
  Stream<AnnouncementsState> mapEventToState(
    AnnouncementsEvent event,
  ) async* {
    final currentState = state;
    final readAnnouncementId =
        await di.sl<Settings>().getLastReadAnnouncementId() ?? -1;

    if (event is AnnouncementsFetch) {
      yield AnnouncementsInProgress();

      final failureOrAnnouncements = await getAnnouncements();

      yield* failureOrAnnouncements.fold(
        (failure) async* {
          logging.warning(
            'Announcements: Failed to fetch announcements ($failure)',
          );
          yield AnnouncementsFailure(
            failure: failure,
            message: 'Failed to load announcements.',
            suggestion: '',
          );
        },
        (announcementList) async* {
          final isIos = Platform.isIOS;
          int maxId = 0;
          final List<Announcement> filteredAnnouncements = [];

          for (Announcement announcement in announcementList) {
            if (announcement.platform == null) {
              filteredAnnouncements.add(announcement);
            } else if (announcement.platform == 'ios' && isIos) {
              filteredAnnouncements.add(announcement);
            } else if (announcement.platform == 'android' && !isIos) {
              filteredAnnouncements.add(announcement);
            }
          }

          if (filteredAnnouncements.isNotEmpty) {
            maxId = filteredAnnouncements.map<int>((a) => a.id).reduce(max);
          }

          yield AnnouncementsSuccess(
            announcementList: filteredAnnouncements,
            lastReadAnnouncementId: readAnnouncementId,
            unread: maxId > readAnnouncementId,
          );
        },
      );
    }
    if (event is AnnouncementsMarkRead) {
      if (currentState is AnnouncementsSuccess) {
        int maxId =
            currentState.announcementList.map<int>((a) => a.id).reduce(max);

        if (maxId > readAnnouncementId) {
          await di.sl<Settings>().setLastReadAnnouncementId(maxId);
          yield currentState.copyWith(
            unread: false,
          );
        }
      }
    }
  }
}
