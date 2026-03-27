import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/mock_data.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(const QuestionInitial()) {
    on<QuestionFlowStarted>(_onQuestionFlowStarted);
    on<QuestionChoiceSelected>(_onQuestionChoiceSelected);
    on<QuestionNextRequested>(_onQuestionNextRequested);
    on<QuestionTimerTicked>(_onQuestionTimerTicked);
    on<QuestionResetRequested>(_onQuestionResetRequested);
  }

  final List<MockQuestion> _questions = MockData.session.questions;
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onQuestionFlowStarted(
    QuestionFlowStarted event,
    Emitter<QuestionState> emit,
  ) {
    _timer?.cancel();
    emit(QuestionInProgress(
      question: _questions.first,
      questionIndex: 0,
      totalQuestions: _questions.length,
      secondsLeft: MockData.questionDuration,
      score: 0,
    ));
    _startTimer();
  }

  Future<void> _onQuestionChoiceSelected(
    QuestionChoiceSelected event,
    Emitter<QuestionState> emit,
  ) async {
    final current = state;
    if (current is! QuestionInProgress || current.selectedChoiceId != null) {
      return;
    }

    final isCorrect = event.choiceId == current.question.choices.first.id;
    final updatedScore =
        current.score + (isCorrect ? MockData.scorePerCorrect : 0);

    emit(current.copyWith(
      selectedChoiceId: event.choiceId,
      score: updatedScore,
    ));

    await Future.delayed(const Duration(milliseconds: 700));
    add(const QuestionNextRequested());
  }

  void _onQuestionNextRequested(
    QuestionNextRequested event,
    Emitter<QuestionState> emit,
  ) {
    final current = state;
    if (current is! QuestionInProgress) return;

    final nextIndex = current.questionIndex + 1;
    if (nextIndex >= current.totalQuestions) {
      _timer?.cancel();
      emit(QuestionCompleted(
        finalScore: current.score,
        totalQuestions: current.totalQuestions,
      ));
      return;
    }

    emit(current.copyWith(
      question: _questions[nextIndex],
      questionIndex: nextIndex,
      secondsLeft: MockData.questionDuration,
      clearSelectedChoice: true,
    ));
  }

  void _onQuestionTimerTicked(
    QuestionTimerTicked event,
    Emitter<QuestionState> emit,
  ) {
    final current = state;
    if (current is! QuestionInProgress) return;

    if (current.secondsLeft <= 1) {
      add(const QuestionNextRequested());
      return;
    }

    emit(current.copyWith(secondsLeft: current.secondsLeft - 1));
  }

  void _onQuestionResetRequested(
    QuestionResetRequested event,
    Emitter<QuestionState> emit,
  ) {
    _timer?.cancel();
    emit(const QuestionInitial());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const QuestionTimerTicked());
    });
  }
}
