import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/users.dart';

part 'users_event.dart';
part 'users_state.dart';

Map<String, List<UserModel>> usersCache = {};

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final Users users;
  final Logging logging;

  UsersBloc({
    required this.users,
    required this.logging,
  }) : super(const UsersState(users: [])) {
    on<UsersFetched>(_onUsersFetched);
  }

  Future<void> _onUsersFetched(
    UsersFetched event,
    Emitter<UsersState> emit,
  ) async {
    if (usersCache.containsKey(event.server.tautulliId)) {
      return emit(
        state.copyWith(
          status: BlocStatus.success,
          users: usersCache[event.server.tautulliId],
        ),
      );
    } else {
      usersCache[event.server.tautulliId] = [];

      emit(
        state.copyWith(
          status: BlocStatus.initial,
          users: const [],
        ),
      );

      final failureOrUsers = await users.getUserNames(
        tautulliId: event.server.tautulliId,
      );

      failureOrUsers.fold(
        (failure) {
          logging.error('Users :: Failed to fetch users [$failure]');

          return emit(
            state.copyWith(
              status: BlocStatus.failure,
              users: usersCache[event.server.tautulliId],
              failure: failure,
              message: FailureHelper.mapFailureToMessage(failure),
              suggestion: FailureHelper.mapFailureToSuggestion(failure),
            ),
          );
        },
        (users) {
          event.settingsBloc.add(
            SettingsUpdatePrimaryActive(
              tautulliId: event.server.tautulliId,
              primaryActive: users.value2,
            ),
          );

          users.value1.sort(
            ((a, b) => a.friendlyName!.compareTo(b.friendlyName!)),
          );

          users.value1.insert(
            0,
            UserModel(
              userId: -1,
              friendlyName: LocaleKeys.all_users_title.tr(),
            ),
          );

          usersCache[event.server.tautulliId] = users.value1;

          return emit(
            state.copyWith(
              status: BlocStatus.success,
              users: usersCache[event.server.tautulliId],
            ),
          );
        },
      );
    }
  }
}
