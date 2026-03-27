part of 'question_bloc.dart';

sealed class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object?> get props => [];
}

class QuestionInitial extends QuestionState {
  const QuestionInitial();
}

class QuestionInProgress extends QuestionState {
  const QuestionInProgress({
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.secondsLeft,
    required this.score,
    this.selectedChoiceId,
  });

  final MockQuestion question;
  final int questionIndex;
  final int totalQuestions;
  final int secondsLeft;
  final int score;
  final String? selectedChoiceId;

  QuestionInProgress copyWith({
    MockQuestion? question,
    int? questionIndex,
    int? totalQuestions,
    int? secondsLeft,
    int? score,
    String? selectedChoiceId,
    bool clearSelectedChoice = false,
  }) {
    return QuestionInProgress(
      question: question ?? this.question,
      questionIndex: questionIndex ?? this.questionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      score: score ?? this.score,
      selectedChoiceId: clearSelectedChoice
          ? null
          : (selectedChoiceId ?? this.selectedChoiceId),
    );
  }

  @override
  List<Object?> get props => [
        question,
        questionIndex,
        totalQuestions,
        secondsLeft,
        score,
        selectedChoiceId,
      ];
}

class QuestionCompleted extends QuestionState {
  const QuestionCompleted(
      {required this.finalScore, required this.totalQuestions});

  final int finalScore;
  final int totalQuestions;

  @override
  List<Object?> get props => [finalScore, totalQuestions];
}
