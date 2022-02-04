part of 'registration_headers_bloc.dart';

abstract class RegistrationHeadersState extends Equatable {
  const RegistrationHeadersState();

  @override
  List<Object> get props => [];
}

class RegistrationHeadersInitial extends RegistrationHeadersState {}

class RegistrationHeadersLoaded extends RegistrationHeadersState {
  final List<CustomHeaderListTile> headers;

  const RegistrationHeadersLoaded(this.headers);

  @override
  List<Object> get props => [headers];
}
