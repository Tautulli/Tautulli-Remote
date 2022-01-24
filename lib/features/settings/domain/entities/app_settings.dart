import 'package:equatable/equatable.dart';

abstract class AppSettings extends Equatable {
  final int serverTimeout;

  const AppSettings({required this.serverTimeout});

  @override
  List<Object> get props => [serverTimeout];
}
