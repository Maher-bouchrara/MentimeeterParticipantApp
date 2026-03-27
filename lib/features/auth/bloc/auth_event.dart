part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.name, required this.password});
  final String name;
  final String password;
  @override
  List<Object?> get props => [name, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
