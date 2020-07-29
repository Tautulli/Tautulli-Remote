import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote_tdd/features/logging/domain/usecases/logging.dart';
import 'package:tautulli_remote_tdd/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote_tdd/features/onesignal/presentation/bloc/onesignal_health_bloc.dart';

class MockOneSignalDataSourceImpl extends Mock
    implements OneSignalDataSourceImpl {}

class MockLogging extends Mock implements Logging {}

void main() {
  OneSignalHealthBloc bloc;
  MockOneSignalDataSourceImpl mockOneSignalDataSourceImpl;
  MockLogging mockLogging;

  setUp(() {
    mockOneSignalDataSourceImpl = MockOneSignalDataSourceImpl();
    mockLogging = MockLogging();
    bloc = OneSignalHealthBloc(
      oneSignal: mockOneSignalDataSourceImpl,
      logging: mockLogging,
    );
  });

  test(
    'initialState should be OneSignalHealthInitial',
    () async {
      // assert
      expect(bloc.state, OneSignalHealthInitial());
    },
  );

  test(
    'should emit [OneSignalHealthInProgress, OneSignalHealthSuccess] when OneSignalHealthDataSource returns true',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.isReachable)
          .thenAnswer((_) async => true);
      // assert later
      final expected = [
        OneSignalHealthInProgress(),
        OneSignalHealthSuccess(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(OneSignalHealthCheck());
    },
  );

  test(
    'should emit [OneSignalHealthInProgress, OneSignalHealthFailure] when OneSignalHealthDataSource returns false',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.isReachable)
          .thenAnswer((_) async => false);
      // assert later
      final expected = [
        OneSignalHealthInProgress(),
        OneSignalHealthFailure(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(OneSignalHealthCheck());
    },
  );
}
