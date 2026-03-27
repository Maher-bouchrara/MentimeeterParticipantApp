import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionInitial()) {
    on<JoinSessionRequested>(_onJoinSessionRequested);
    on<SessionResetRequested>(_onSessionResetRequested);
  }

  static const _validCode = 'AB12CD';

  Future<void> _onJoinSessionRequested(
    JoinSessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    final normalizedCode = event.code.trim().toUpperCase();
    emit(SessionJoining(code: normalizedCode));

    await Future.delayed(const Duration(milliseconds: 500));

    if (normalizedCode != _validCode) {
      emit(SessionError(
        message: 'Code invalide. Entrez AB12CD.',
        prefilledCode: normalizedCode,
      ));
      emit(SessionInitial(prefilledCode: normalizedCode));
      return;
    }

    emit(const SessionWaitingRoom(code: _validCode));
  }

  void _onSessionResetRequested(
    SessionResetRequested event,
    Emitter<SessionState> emit,
  ) {
    emit(const SessionInitial());
  }
}
