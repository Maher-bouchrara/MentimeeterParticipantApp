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
  const AuthAuthenticated({
    required this.displayName,
    this.email,
    this.userId,
    this.isGuest = false,
  });
  final String displayName;
  final String? email;
  final String? userId;
  final bool isGuest;

  // Kept for backward-compat with main.dart references to state.name
  String get name => displayName;

  @override
  List<Object?> get props => [displayName, email, userId, isGuest];
}

class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
