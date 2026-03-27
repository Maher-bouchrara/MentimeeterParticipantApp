// Données fictives — Participant App

class MockChoice {
  final String id;
  final String text;
  const MockChoice({required this.id, required this.text});
}

class MockQuestion {
  final String id;
  final String text;
  final List<MockChoice> choices;
  const MockQuestion({
    required this.id,
    required this.text,
    required this.choices,
  });
}

class MockSession {
  final String code;
  final String quizTitle;
  final List<MockQuestion> questions;
  const MockSession({
    required this.code,
    required this.quizTitle,
    required this.questions,
  });
}

class MockLeaderboardEntry {
  final String name;
  final int score;
  const MockLeaderboardEntry({required this.name, required this.score});
}

class MockData {
  MockData._();

  /// Session mock à rejoindre
  static const session = MockSession(
    code: 'AB12CD',
    quizTitle: 'JavaScript Basics',
    questions: [
      MockQuestion(
        id: 'q1',
        text: 'What is a closure?',
        choices: [
          MockChoice(id: 'a', text: 'A function in a function'),
          MockChoice(id: 'b', text: 'An infinite loop'),
          MockChoice(id: 'c', text: 'A variable type'),
          MockChoice(id: 'd', text: 'An async promise'),
        ],
      ),
      MockQuestion(
        id: 'q2',
        text: 'What is a Promise in JavaScript?',
        choices: [
          MockChoice(id: 'a', text: 'A callback function'),
          MockChoice(id: 'b', text: 'An object for async operations'),
          MockChoice(id: 'c', text: 'A type of loop'),
          MockChoice(id: 'd', text: 'A CSS property'),
        ],
      ),
      MockQuestion(
        id: 'q3',
        text: 'Explain event bubbling',
        choices: [
          MockChoice(id: 'a', text: 'Events propagate upward'),
          MockChoice(id: 'b', text: 'DOM reloads'),
          MockChoice(id: 'c', text: 'Async events queue'),
          MockChoice(id: 'd', text: 'CSS animation trigger'),
        ],
      ),
      MockQuestion(
        id: 'q4',
        text: 'What is hoisting?',
        choices: [
          MockChoice(id: 'a', text: 'Variable declarations moved up'),
          MockChoice(id: 'b', text: 'DOM manipulation'),
          MockChoice(id: 'c', text: 'CSS transform'),
          MockChoice(id: 'd', text: 'Array method'),
        ],
      ),
      MockQuestion(
        id: 'q5',
        text: 'Difference between == and ===?',
        choices: [
          MockChoice(id: 'a', text: '=== checks type too'),
          MockChoice(id: 'b', text: 'No difference'),
          MockChoice(id: 'c', text: '== is stricter'),
          MockChoice(id: 'd', text: '=== is for objects only'),
        ],
      ),
    ],
  );

  /// Leaderboard final mock
  static const leaderboard = [
    MockLeaderboardEntry(name: 'Alice', score: 240),
    MockLeaderboardEntry(name: 'Bob', score: 180),
    MockLeaderboardEntry(name: 'Carol', score: 160),
    MockLeaderboardEntry(name: 'Dave', score: 120),
  ];

  /// Durée par question en secondes
  static const questionDuration = 15;

  /// Score par bonne réponse (+ bonus rapidité simulé)
  static const scorePerCorrect = 60;
}
