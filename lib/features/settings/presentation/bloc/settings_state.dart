part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();  

  @override
  List<Object> get props => [];
}
class SettingsInitial extends SettingsState {}
