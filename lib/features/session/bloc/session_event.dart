part of 'session_bloc.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class JoinSessionRequested extends SessionEvent {
  const JoinSessionRequested({required this.code});

  final String code;

  @override
  List<Object?> get props => [code];
}

class SessionResetRequested extends SessionEvent {
  const SessionResetRequested();
}
