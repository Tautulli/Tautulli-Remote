import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tautulli_remote/features/onesignal/data/datasources/onesignal_data_source.dart';
import 'package:tautulli_remote/features/onesignal/presentation/bloc/onesignal_subscription_bloc.dart';

class MockOneSignalDataSourceImpl extends Mock
    implements OneSignalDataSourceImpl {}

void main() {
  OneSignalSubscriptionBloc bloc;
  MockOneSignalDataSourceImpl mockOneSignalDataSourceImpl;

  setUp(() {
    mockOneSignalDataSourceImpl = MockOneSignalDataSourceImpl();
    bloc = OneSignalSubscriptionBloc(
      oneSignal: mockOneSignalDataSourceImpl,
    );
  });

  test(
    'initialState should be OneSignalSubscriptionInitial',
    () async {
      // assert
      expect(bloc.state, OneSignalSubscriptionInitial());
    },
  );

  test(
    'should emit [OneSignalSubscriptionSuccess] when hasConsented is true, isSubscribed is true, and userId is not null',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.hasConsented)
          .thenAnswer((_) async => true);
      when(mockOneSignalDataSourceImpl.isSubscribed)
          .thenAnswer((_) async => true);
      when(mockOneSignalDataSourceImpl.userId).thenAnswer((_) async => 'abc');
      // assert later
      final expected = [
        OneSignalSubscriptionSuccess(),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalSubscriptionCheck());
    },
  );

  test(
    'should emit [OneSignalSubscriptionFailure] with appropriate messaging when hasConsented is false',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.hasConsented)
          .thenAnswer((_) async => false);
      // assert later
      final expected = [
        OneSignalSubscriptionFailure(
          title: CONSENT_ERROR_TITLE,
          message: CONSENT_ERROR_MESSAGE,
          consented: false,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalSubscriptionCheck());
    },
  );

  test(
    'should emit [OneSignalSubscriptionFailure] with appropriate messaging when hasConsented is true, isSubscribed is false, and userId is null',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.hasConsented)
          .thenAnswer((_) async => true);
      when(mockOneSignalDataSourceImpl.isSubscribed)
          .thenAnswer((_) async => false);
      when(mockOneSignalDataSourceImpl.userId).thenAnswer((_) async => null);
      // assert later
      final expected = [
        OneSignalSubscriptionFailure(
          title: REGISTER_ERROR_TITLE,
          message: REGISTER_ERROR_MESSAGE,
          consented: true,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalSubscriptionCheck());
    },
  );

  test(
    'should emit [OneSignalSubscriptionFailure] with appropriate messaging when hasConsented is true, isSubscribed is false, and userId is not null',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.hasConsented)
          .thenAnswer((_) async => true);
      when(mockOneSignalDataSourceImpl.isSubscribed)
          .thenAnswer((_) async => false);
      when(mockOneSignalDataSourceImpl.userId).thenAnswer((_) async => 'abc');
      // assert later
      final expected = [
        OneSignalSubscriptionFailure(
          title: REGISTER_ERROR_TITLE,
          message: REGISTER_ERROR_MESSAGE,
          consented: true,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalSubscriptionCheck());
    },
  );

  test(
    'should emit [OneSignalSubscriptionFailure] with appropriate messaging when hasConsented is true, isSubscribed is true, and userId is null or an empty string',
    () async {
      // arrange
      when(mockOneSignalDataSourceImpl.hasConsented)
          .thenAnswer((_) async => true);
      when(mockOneSignalDataSourceImpl.isSubscribed)
          .thenAnswer((_) async => true);
      when(mockOneSignalDataSourceImpl.userId).thenAnswer((_) async => '');
      // assert later
      final expected = [
        OneSignalSubscriptionFailure(
          title: UNEXPECTED_ERROR_TITLE,
          message: UNEXPECTED_ERROR_MESSAGE,
          consented: true,
        ),
      ];
      // ignore: unawaited_futures
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(OneSignalSubscriptionCheck());
    },
  );
}
