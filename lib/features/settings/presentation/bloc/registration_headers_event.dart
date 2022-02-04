part of 'registration_headers_bloc.dart';

abstract class RegistrationHeadersEvent extends Equatable {
  const RegistrationHeadersEvent();

  @override
  List<Object> get props => [];
}

class RegistrationHeadersClear extends RegistrationHeadersEvent {}

class RegistrationHeadersDelete extends RegistrationHeadersEvent {
  final String title;

  const RegistrationHeadersDelete(this.title);

  @override
  List<Object> get props => [title];
}

class RegistrationHeadersUpdate extends RegistrationHeadersEvent {
  final String title;
  final String subtitle;
  final bool basicAuth;
  final String? previousTitle;

  const RegistrationHeadersUpdate({
    required this.title,
    required this.subtitle,
    required this.basicAuth,
    this.previousTitle,
  });

  @override
  List<Object> get props => [title, subtitle, basicAuth];
}
