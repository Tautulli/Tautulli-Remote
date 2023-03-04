import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/users.dart';

part 'user_individual_event.dart';
part 'user_individual_state.dart';

Map<String, UserModel> userCache = {};

class UserIndividualBloc extends Bloc<UserIndividualEvent, UserIndividualState> {
  final Users users;
  final Logging logging;

  UserIndividualBloc({
    required this.users,
    required this.logging,
  }) : super(
          const UserIndividualState(
            user: UserModel(),
          ),
        ) {
    on<UserIndividualFetched>(_onUserIndividualFetched);
  }

  void _onUserIndividualFetched(
    UserIndividualFetched event,
    Emitter<UserIndividualState> emit,
  ) async {
    if (userCache.containsKey('${event.server.tautulliId}:${event.userId}')) {
      return emit(
        state.copyWith(
          status: BlocStatus.success,
          user: userCache['${event.server.tautulliId}:${event.userId}'],
        ),
      );
    }

    emit(
      state.copyWith(
        status: BlocStatus.initial,
      ),
    );

    final failureOrUser = await users.getUser(
      tautulliId: event.server.tautulliId,
      userId: event.userId,
    );

    failureOrUser.fold(
      (failure) {
        logging.error(
          'User :: Failured to fetch user with ID ${event.userId} [$failure]',
        );

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
          ),
        );
      },
      (user) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: user.value2,
          ),
        );

        userCache['${event.server.tautulliId}:${event.userId}'] = user.value1;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            user: user.value1,
          ),
        );
      },
    );
  }
}
