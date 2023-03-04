import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/helpers/failure_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../logging/domain/usecases/logging.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_table_model.dart';
import '../../domain/usecases/users.dart';

part 'users_table_event.dart';
part 'users_table_state.dart';

String? tautulliIdCache;
Map<String, List<UserTableModel>> usersCache = {};
bool hasReachedMaxCache = false;

const throttleDuration = Duration(milliseconds: 100);
const length = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UsersTableBloc extends Bloc<UsersTableEvent, UsersTableState> {
  final Users users;
  final Logging logging;

  UsersTableBloc({
    required this.users,
    required this.logging,
  }) : super(
          UsersTableState(
            users: tautulliIdCache != null ? usersCache[tautulliIdCache]! : [],
            hasReachedMax: hasReachedMaxCache,
          ),
        ) {
    on<UsersTableFetched>(
      _onUsersTableFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onUsersTableFetched(
    UsersTableFetched event,
    Emitter<UsersTableState> emit,
  ) async {
    if (event.server.id == null) {
      Failure failure = MissingServerFailure();

      return emit(
        state.copyWith(
          status: BlocStatus.failure,
          failure: failure,
          message: FailureHelper.mapFailureToMessage(failure),
          suggestion: FailureHelper.mapFailureToSuggestion(failure),
        ),
      );
    }

    final bool serverChange = tautulliIdCache != event.server.tautulliId;

    if (!usersCache.containsKey(event.server.tautulliId)) {
      usersCache[event.server.tautulliId] = [];
    }

    if (event.freshFetch || (tautulliIdCache != null && serverChange)) {
      emit(
        state.copyWith(
          status: BlocStatus.initial,
          users: serverChange ? [] : null,
          hasReachedMax: false,
        ),
      );
      usersCache[event.server.tautulliId] = [];
      hasReachedMaxCache = false;
    }

    tautulliIdCache = event.server.tautulliId;

    if (state.hasReachedMax) return;

    if (state.status == BlocStatus.initial) {
      // Prevent triggering initial fetch when navigating back to Users page
      if (usersCache[event.server.tautulliId]!.isNotEmpty) {
        return emit(
          state.copyWith(
            status: BlocStatus.success,
          ),
        );
      }

      final failureOrUsersTable = await users.getUsersTable(
        tautulliId: event.server.tautulliId,
        orderDir: event.orderDir,
        orderColumn: event.orderColumn,
        length: length,
      );

      return _emitFailureOrUsersTable(
        event: event,
        emit: emit,
        failureOrUsersTable: failureOrUsersTable,
      );
    } else {
      // Make sure bottom loader loading indicator displays when
      // attempting to fetch
      emit(
        state.copyWith(status: BlocStatus.success),
      );

      final failureOrUsersTable = await users.getUsersTable(
        tautulliId: event.server.tautulliId,
        orderDir: event.orderDir,
        orderColumn: event.orderColumn,
        length: length,
        start: usersCache[event.server.tautulliId]!.length,
      );

      return _emitFailureOrUsersTable(
        event: event,
        emit: emit,
        failureOrUsersTable: failureOrUsersTable,
      );
    }
  }

  void _emitFailureOrUsersTable({
    required UsersTableFetched event,
    required Emitter<UsersTableState> emit,
    required Either<Failure, Tuple2<List<UserTableModel>, bool>> failureOrUsersTable,
  }) {
    failureOrUsersTable.fold(
      (failure) {
        logging.error('UsersTable :: Failed to fetch users [$failure]');

        return emit(
          state.copyWith(
            status: BlocStatus.failure,
            users: event.freshFetch ? usersCache[event.server.tautulliId] : state.users,
            failure: failure,
            message: FailureHelper.mapFailureToMessage(failure),
            suggestion: FailureHelper.mapFailureToSuggestion(failure),
          ),
        );
      },
      (usersTable) {
        event.settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: event.server.tautulliId,
            primaryActive: usersTable.value2,
          ),
        );

        usersCache[event.server.tautulliId] = usersCache[event.server.tautulliId]! + usersTable.value1;
        hasReachedMaxCache = usersTable.value1.length < length;

        return emit(
          state.copyWith(
            status: BlocStatus.success,
            users: usersCache[event.server.tautulliId],
            hasReachedMax: hasReachedMaxCache,
          ),
        );
      },
    );
  }
}
