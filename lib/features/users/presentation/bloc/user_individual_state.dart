part of 'user_individual_bloc.dart';

class UserIndividualState extends Equatable {
  final BlocStatus status;
  final UserModel user;
  final Failure? failure;
  final String? message;
  final String? suggestion;

  const UserIndividualState({
    this.status = BlocStatus.initial,
    required this.user,
    this.failure,
    this.message,
    this.suggestion,
  });

  UserIndividualState copyWith({
    BlocStatus? status,
    UserModel? user,
    Failure? failure,
    String? message,
    String? suggestion,
  }) {
    return UserIndividualState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      suggestion: suggestion ?? this.suggestion,
    );
  }

  @override
  List<Object?> get props => [status, user, failure, message, suggestion];
}
