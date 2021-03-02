import 'dart:async';
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
          int maxId = 0;
          if (announcementList.length > 0) {
            maxId = announcementList.map<int>((a) => a.id).reduce(max);
          }

          yield AnnouncementsSuccess(
            announcementList: announcementList,
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
          di.sl<Settings>().setLastReadAnnouncementId(maxId);
          yield currentState.copyWith(
            // lastReadAnnouncementId: maxId,
            unread: false,
          );
        }
      }
    }
  }
}
