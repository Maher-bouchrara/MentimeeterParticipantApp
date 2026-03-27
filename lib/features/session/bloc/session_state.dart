part of 'session_bloc.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial({this.prefilledCode = 'AB12CD'});

  final String prefilledCode;

  @override
  List<Object?> get props => [prefilledCode];
}

class SessionJoining extends SessionState {
  const SessionJoining({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}

class SessionWaitingRoom extends SessionState {
  const SessionWaitingRoom({
    required this.code,
    this.sessionTitle = 'JavaScript Basics',
    this.joinedPlayers = 4,
  });

  final String code;
  final String sessionTitle;
  final int joinedPlayers;

  @override
  List<Object?> get props => [code, sessionTitle, joinedPlayers];
}

class SessionError extends SessionState {
  const SessionError({required this.message, required this.prefilledCode});

  final String message;
  final String prefilledCode;

  @override
  List<Object?> get props => [message, prefilledCode];
}
