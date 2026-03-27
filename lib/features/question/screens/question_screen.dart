import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../bloc/question_bloc.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({
    super.key,
    required this.state,
    required this.onSelectChoice,
  });

  final QuestionInProgress state;
  final ValueChanged<String> onSelectChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ScreenHeader(
                    title:
                        'Q${state.questionIndex + 1}/${state.totalQuestions} - ${state.secondsLeft}s',
                    subtitle: 'Score: ${state.score}',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.question.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(state.question.choices.length, (index) {
                    final choice = state.question.choices[index];
                    final optionLetter = String.fromCharCode(65 + index);
                    final isSelected = state.selectedChoiceId == choice.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: state.selectedChoiceId != null
                            ? null
                            : () => onSelectChoice(choice.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.choiceSelected
                                : AppColors.choiceDefault,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.choiceBorderSel
                                  : AppColors.border,
                              width: isSelected ? 1.6 : 1,
                            ),
                          ),
                          child: Text(
                            '$optionLetter. ${choice.text}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
