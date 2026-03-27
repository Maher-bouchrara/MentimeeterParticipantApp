import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/leaderboard/screens/leaderboard_screen.dart';
import 'features/question/bloc/question_bloc.dart';
import 'features/question/screens/question_screen.dart';
import 'features/session/bloc/session_bloc.dart';
import 'features/session/screens/join_session_screen.dart';
import 'features/session/screens/waiting_room_screen.dart';

// Étapes suivantes :
// import 'features/leaderboard/bloc/leaderboard_bloc.dart';

void main() {
  runApp(const QuizParticipantApp());
}

class QuizParticipantApp extends StatelessWidget {
  const QuizParticipantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<SessionBloc>(create: (_) => SessionBloc()),
        BlocProvider<QuestionBloc>(create: (_) => QuestionBloc()),
      ],
      child: MaterialApp(
        title: 'QuizApp Player',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const _AppRouter(),
      ),
    );
  }
}

class _AppRouter extends StatelessWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        if (state is AuthAuthenticated) {
          return BlocConsumer<SessionBloc, SessionState>(
            listener: (ctx, sessionState) {
              if (sessionState is SessionError) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(sessionState.message),
                    backgroundColor: AppColors.danger,
                  ),
                );
              }
            },
            builder: (ctx, sessionState) {
              if (sessionState is SessionWaitingRoom) {
                return BlocBuilder<QuestionBloc, QuestionState>(
                  builder: (ctx, questionState) {
                    if (questionState is QuestionInProgress) {
                      return QuestionScreen(
                        state: questionState,
                        onSelectChoice: (choiceId) =>
                            ctx.read<QuestionBloc>().add(
                                  QuestionChoiceSelected(choiceId: choiceId),
                                ),
                      );
                    }

                    if (questionState is QuestionCompleted) {
                      return LeaderboardScreen(
                        playerName: state.name,
                        playerScore: questionState.finalScore,
                        onPlayAgain: () {
                          ctx.read<SessionBloc>().add(const SessionResetRequested());
                          ctx.read<QuestionBloc>().add(const QuestionResetRequested());
                        },
                      );
                    }

                    return WaitingRoomScreen(
                      sessionTitle: sessionState.sessionTitle,
                      joinedPlayers: sessionState.joinedPlayers,
                      onHostStarted: questionState is QuestionInitial
                          ? () => ctx
                              .read<QuestionBloc>()
                              .add(const QuestionFlowStarted())
                          : null,
                    );
                  },
                );
              }

              final code = switch (sessionState) {
                SessionInitial(:final prefilledCode) => prefilledCode,
                SessionJoining(:final code) => code,
                SessionError(:final prefilledCode) => prefilledCode,
                _ => 'AB12CD',
              };

              return JoinSessionScreen(
                initialCode: code,
                isLoading: sessionState is SessionJoining,
                onJoin: (enteredCode) => ctx.read<SessionBloc>().add(
                      JoinSessionRequested(code: enteredCode),
                    ),
              );
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}
