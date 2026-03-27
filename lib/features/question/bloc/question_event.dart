part of 'question_bloc.dart';

sealed class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object?> get props => [];
}

class QuestionFlowStarted extends QuestionEvent {
  const QuestionFlowStarted();
}

class QuestionChoiceSelected extends QuestionEvent {
  const QuestionChoiceSelected({required this.choiceId});

  final String choiceId;

  @override
  List<Object?> get props => [choiceId];
}

class QuestionNextRequested extends QuestionEvent {
  const QuestionNextRequested();
}

class QuestionTimerTicked extends QuestionEvent {
  const QuestionTimerTicked();
}

class QuestionResetRequested extends QuestionEvent {
  const QuestionResetRequested();
}
