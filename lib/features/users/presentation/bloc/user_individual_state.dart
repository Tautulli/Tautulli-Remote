part of 'user_individual_bloc.dart';

class UserIndividualState extends Equatable {
  final BlocStatus status;
  final UserModel user;

  const UserIndividualState({
    this.status = BlocStatus.initial,
    required this.user,
  });

  UserIndividualState copyWith({
    BlocStatus? status,
    UserModel? user,
  }) {
    return UserIndividualState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status, user];
}
