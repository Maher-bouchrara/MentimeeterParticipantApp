part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.name});
  final String name;
  @override
  List<Object?> get props => [name];
}

class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
